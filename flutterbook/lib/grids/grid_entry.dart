import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'grids_model.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter/cupertino.dart';
import 'grids_db_worker.dart';

class GridEntry extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<GridsModel>(
        builder: (BuildContext context, Widget? child, GridsModel model) {
          return Scaffold(
            body:SliderPage(),
          );
        }
    );
  }
}

class SliderPage extends StatefulWidget {

  @override
  _SliderPageState createState() => _SliderPageState();
}

class _SliderPageState extends State<SliderPage> {
  Color currentColor = gridsModel.entityBeingEdited != null ?
  Color(int.parse(gridsModel.entityBeingEdited.backgroundColor)) : Colors.black;
  Color textColor = gridsModel.entityBeingEdited != null ? Color(int.parse(gridsModel.entityBeingEdited.textColor)) : Colors.white;

  colorToHexString(Color color) {
    String a = color.toString();
    int val = color.value;
    String valString = val.toString();

    String c = color.value.toRadixString(16).substring(2, 8);
    String first = c.substring(0,2);
    String mid = c.substring(2,4);
    String last = c.substring(4);
    print('before');
    print(valString);
    var q = int.parse(valString);
    print(q);
    print('here');
    String newColor = mid + first + last;
    return newColor;
  }

  Widget buildTextColorPicker() => ColorPicker(
    pickerColor: textColor,
    enableAlpha: false,
    showLabel: false,
    onColorChanged: (color) => setState(() => textColor = color),
  );

  Widget buildColorPicker() => ColorPicker(
    pickerColor: currentColor,
    enableAlpha: false,
    showLabel: false,
    onColorChanged: (color) => setState(() => currentColor = color),
  );

  void pickColor(BuildContext context, bool background) {
    var open = true;
    showDialog(context: context,
        builder: (context) =>
            AlertDialog(
                title: const Text('Pick Color'),
                content: Column(children: [
                    if (background) buildColorPicker(),
                    if (!background)  buildTextColorPicker(),
                    if (background) TextButton(
                    child: const Text('Select Background',
                      style: TextStyle(fontSize: 20),
                    ),
                    onPressed: () {
                      if (open) Navigator.pop(context);
                      open = false;
                    }
                  ),
                  if (!background) TextButton(
                      child: const Text('Select Text',
                        style: TextStyle(fontSize: 20),
                      ),
                      onPressed: () {
                        if (open) Navigator.pop(context);
                        open = false;
                      }
                  )

                  ,]
    )
    )
    );
  }

  double _sliderValue = 150.0;
  bool? _blockCheck = true;

  void printColor(){
    print(colorToHexString(currentColor));
    print("__________________");
    print(_values['text']);
  }

  String getTextColor(){
    return colorToHexString(textColor);
  }

  getColorString(Color color){
    return colorToHexString(color);
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
          _save(context, model);
        },
      )
    ]
    );
  }

  void _save(BuildContext context, GridsModel model) async {
    model.entityBeingEdited.textColor = textColor.value.toString();
    model.entityBeingEdited.backgroundColor = currentColor.value.toString();
    model.entityBeingEdited.text = _values['text'].length>0 ? _values['text'].toString() : "Hello";
    if (model.entityBeingEdited.id == -1) {
      await GridsDBWorker.db.create(model.entityBeingEdited);
    } else {
      await GridsDBWorker.db.update(model.entityBeingEdited);
    }
    model.loadData(GridsDBWorker.db);
    model.setStackIndex(0);
    Scaffold.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2), content: Text('Item saved'),
        )
    );
  }





  final GlobalKey<FormFieldState<String>> _customTextKey = GlobalKey();

  _notEmpty(String value) => value != null && value.isNotEmpty;
  get _values =>
      ({
        'text': _customTextKey.currentState?.value,
      });


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Padding(
      padding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
      child: _buildControlButtons(context, gridsModel)
      ),
      body: Container(
          padding: EdgeInsets.only(left: 20.0),
          child: Column(children: <Widget>[
            TextFormField(
            key: _customTextKey,
            initialValue: gridsModel.entityBeingEdited.text,
            decoration: const InputDecoration(
              labelText: 'Custom Text',
              hintText: 'Enter a Name',
            ),
            validator: (value) =>
            !_notEmpty(value.toString()) ? 'Title is required' : null,
          ),
            _createSlider(),
            _createSwitch(),
          Container(
              padding: EdgeInsets.only(left: 30.0),
              child: Row(
              children: [
                Column(children: [
            Container(
              decoration: BoxDecoration(shape: BoxShape.circle,
              color: textColor),
            width: 20,
              height: 20,
            ),
                  ElevatedButton(
              child: const Text('Select TextColor',
                style: TextStyle(fontSize: 14),
              ),
              onPressed: () {
                pickColor(context, false);
                printColor();
              }
            ),
                ]),
            SizedBox(width: 10,),
        Column(children: [
          Container(
            decoration: BoxDecoration(shape: BoxShape.circle,
                color: currentColor),
            width: 20,
            height: 20,
          ),
            ElevatedButton(
                child: const Text('Select BackgroundColor',
                  style: TextStyle(fontSize: 14),
                ),
                onPressed: () {
                  pickColor(context, true);
                  printColor();
                }
            )
          ],),
              ]),
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
    return Container(
      decoration: BoxDecoration(shape: BoxShape.circle,
          color: currentColor),
      width: _sliderValue,
       // fit: BoxFit.contain,
      height: 20,
      child: Center(child: Text(_values['text'] != null  ? _values['text'].toString() : "Hello", style: TextStyle(color: textColor,fontSize: _sliderValue/5)))
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