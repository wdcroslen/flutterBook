import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'grids_model.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter/cupertino.dart';
import 'grids_db_worker.dart';

// class GridEntry extends StatelessWidget {
//
//   final TextEditingController _nameEditingController = TextEditingController();
//   final TextEditingController _phoneEditingController = TextEditingController();
//   final TextEditingController _emailEditingController = TextEditingController();
//
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//
//   GridEntry() {
//     _nameEditingController.addListener(() {
//       contactsModel.entityBeingEdited.name = _nameEditingController.text;
//     });
//     _phoneEditingController.addListener(() {
//       contactsModel.entityBeingEdited.phone = _phoneEditingController.text;
//     });
//     _emailEditingController.addListener(() {
//       contactsModel.entityBeingEdited.email = _emailEditingController.text;
//     });
//   }


class GridEntry extends StatelessWidget {
  String imageURL = '';

  final TextEditingController _backgroundColorEditingController = TextEditingController();
  final TextEditingController _textColorEditingController = TextEditingController();

  GridEntry(String url) {
    imageURL = url;
    print('GridEntry');
    print(url);
    // _backgroundColorEditingController.addListener(() {
    //   gridsModel.entityBeingEdited.backgroundColor = _backgroundColorEditingController.text;
    // });
    // _backgroundColorEditingController.addListener(() {
    //   gridsModel.entityBeingEdited.phone = _textColorEditingController.text;
    // });
  }


//     return ScopedModelDescendant<NotesModel>(
//         builder: (BuildContext context, Widget? child, NotesModel model) {
//           _titleEditingController.text = model.entryBeingEdited.title;
//           _contentEditingController.text = model.entryBeingEdited.content;
//           return Scaffold(
//               bottomNavigationBar: Padding(
//                   padding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
//                   child: _buildControlButtons(context, model)
//               ),
//               body: Form(
//                   key: _formKey,
//                   child: ListView(
//                       children: [
//                         _buildTitleListTile(),
//                         _buildContentListTile(),
//                         _buildColorListTile(context)
//                       ]
//                   )
//               )
//           );
//         }
//     );
//   }
// }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<GridsModel>(
        builder: (BuildContext context, Widget? child, GridsModel model) {
          return Scaffold(
            body:SliderPage(imageURL),
          );
        }
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   return ScopedModel<GridsModel>(
  //       model: gridsModel,
  //       child: ScopedModelDescendant<GridsModel>(
  //           builder: (BuildContext context, Widget? child, GridsModel model) {
  //             return IndexedStack(
  //               index: model.stackIndex,
  //               children: <Widget>[SliderPage(imageURL)],
  //             );
  //           }
  //       )
  //   );
  // }
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
  Color currentColor = Colors.red;

  colorToHexString(Color color) {
    String c = color.value.toRadixString(16).substring(2, 8);
    String first = c.substring(0,2);
    String mid = c.substring(2,4);
    String last = c.substring(4);
    print(c);
    print(first);
    print(mid);
    print(last);
    print('hello');
    String newColor = mid + first + last;
    print(newColor);
    return newColor;
  }

  Widget buildColorPicker() => ColorPicker(
    pickerColor: currentColor,
    enableAlpha: false,
    showLabel: false,
    onColorChanged: (color) => setState(() => currentColor = color),
  );

  void pickColor(BuildContext context) {
    var open = true;
    showDialog(context: context,
        builder: (context) =>
            AlertDialog(
                title: const Text('Pick Color'),
                content: Column(children: [
                    buildColorPicker(),
                TextButton(
                    child: const Text('Select',
                      style: TextStyle(fontSize: 20),
                    ),
                    onPressed: () {
                      if (open) Navigator.pop(context);
                      open = false;
                    }
    ),]
    )
    )
    );
  }


  double _sliderValue = 150.0;
  bool? _blockCheck = true;
  String _imageURL = '';

  _SliderPageState(String url){
    _imageURL = url;
  }

  void printColor(){
    print(colorToHexString(currentColor));
  }

  Row _buildControlButtons(BuildContext context, GridsModel model) {
    return Row(children: [
      FlatButton(
        child: Text('Cancel'),
        onPressed: () {
          FocusScope.of(context).requestFocus(FocusNode());
          model.setStackIndex(0);
        },
      ),
      Spacer(),
      FlatButton(
        child: Text('Save'),
        onPressed: () {
          _save(context, gridsModel);
        },
      )
    ]
    );
  }

  void _save(BuildContext context, GridsModel model) async {
    if (model.entityBeingEdited.id == -1) {
      await GridsDBWorker.db.create(gridsModel.entityBeingEdited);
    } else {
      await GridsDBWorker.db.update(gridsModel.entityBeingEdited);
    }
    gridsModel.loadData(GridsDBWorker.db);
    model.setStackIndex(0);
    Scaffold.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2), content: Text('Item saved'),
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Padding(
      padding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
      child: _buildControlButtons(context, gridsModel)
      ),
      body: Container(
          padding: EdgeInsets.only(top: 50.0),
          child: Column(children: <Widget>[
            _createSlider(),
            _createSwitch(),
          Container(
              padding: EdgeInsets.only(left: 30.0),
              child: Row(
              children: [
            ElevatedButton(
              child: const Text('Select TextColor',
                style: TextStyle(fontSize: 14),
              ),
              onPressed: () {
                pickColor(context);
                printColor();
              }
            ),
            SizedBox(width: 10,),
            ElevatedButton(
                child: const Text('Select BackgroundColor',
                  style: TextStyle(fontSize: 14),
                ),
                onPressed: () {
                  pickColor(context);
                  printColor();
                }
            ),]),
          ),
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