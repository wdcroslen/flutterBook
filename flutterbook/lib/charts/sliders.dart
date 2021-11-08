import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'indicator.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
// import 'contacts_entry.dart';
import 'charts_model.dart';
// import 'contacts_list.dart';
import 'package:flutterbook/contacts/contacts_db_worker.dart';



class Sliders extends StatelessWidget {
  String imageURL = '';
  // Sliders() {
  //   // contactsModel.loadData(ContactsDBWorker.db);
  // }

  Sliders(String url) {
    imageURL = url;
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel<ChartsModel>(
        model: chartsModel,
        child: ScopedModelDescendant<ChartsModel>(
            builder: (BuildContext context, Widget? child, ChartsModel model) {
              return IndexedStack(
                index: model.stackIndex,
                children: <Widget>[SliderPage(imageURL)],
              );
            }
        )
    );
  }
}

class SliderPage extends StatefulWidget {
  String imageURL = '';

  SliderPage(String url){
    imageURL = url;
  }
  //const SliderPage({Key? key}) : super(key: key);

  @override
  _SliderPageState createState() => _SliderPageState(imageURL);
}

class _SliderPageState extends State<SliderPage> {


  double _sliderValue = 150.0;
  bool? _blockCheck = true;
  String _imageURL = '';

  _SliderPageState(String url){
    _imageURL = url;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          padding: EdgeInsets.only(top: 50.0),
          child: Column(children: <Widget>[
            _createSlider(),
            _createSwitch(),
            Expanded(child: _createImage())
          ])
      ),
    );
  }

  Widget _createSlider() {
    return Slider(
      activeColor: Colors.blueAccent,
      label: 'Image size',
      //divisions: 20,
      value: _sliderValue,
      min: 10.0,
      max: 400.0,
      onChanged: (_blockCheck!) ? null :
          (value) {
        setState(() {
          _sliderValue = value;
        });
        //print(_sliderValue);
      },
    );
  }

  Widget _createImage() {
    return Image(
      image:
      NetworkImage(_imageURL),
      width: _sliderValue,
      fit: BoxFit.contain,
    );
  }

  Widget _createSwitch() {
    return SwitchListTile(
        title: (_blockCheck!) ? Text('Unlock slider') : Text('Block slider'),
        value: _blockCheck!,
        onChanged: (value) {
          setState(() {
            _blockCheck = value;
          });
        }
    );
  }
}