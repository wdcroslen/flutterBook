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

  final TextEditingController _backgroundColorEditingController = TextEditingController();
  final TextEditingController _textColorEditingController = TextEditingController();

  GridEntry() {
    // print('GridEntry');
    // _backgroundColorEditingController.addListener(() {
    //   gridsModel.entityBeingEdited.backgroundColor = _backgroundColorEditingController.text;
    // });
    // _backgroundColorEditingController.addListener(() {
    //   gridsModel.entityBeingEdited.phone = _textColorEditingController.text;
    // });
  }

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

  /*
  Widget build(BuildContext context) {
    return ScopedModelDescendant<NotesModel>(
        builder: (BuildContext context, Widget? child, NotesModel model) {
      _titleEditingController.text = model.entryBeingEdited.title;
      _contentEditingController.text = model.entryBeingEdited.content;
      return Scaffold(
          bottomNavigationBar: Padding(
          padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
    child: _buildControlButtons(context, model)
    ),
    body: Form(
    key: _formKey,
    child: ListView(
    children: [
    _buildTitleListTile(),
    _buildContentListTile(),
    _buildColorListTile(context)
    ]
    */
}

class SliderPage extends StatefulWidget {
  String imageURL = '';

  //const SliderPage({Key? key}) : super(key: key);

  @override
  _SliderPageState createState() => _SliderPageState();
}

class _SliderPageState extends State<SliderPage> {
  Color currentColor = Colors.black;
  Color textColor = Colors.white; //Color(int.parse(model.entityBeingEdited.textColor))

  colorToHexString(Color color) {
    String a = color.toString();
    int val = color.value;
    String valString = val.toString();

    String c = color.value.toRadixString(16).substring(2, 8);
    String first = c.substring(0,2);
    String mid = c.substring(2,4);
    String last = c.substring(4);
    print('before');
    // print(a);
    // Color aColor = Color(val);
    // print(aColor.toString());
    print(valString);
    var q = int.parse(valString);
    // print(val);
    print(q);
    print('here');
    // print(c);
    // print(first);
    // print(mid);
    // print(last);
    // print('hello');
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
    // return Image(
    //   image:
    //   NetworkImage(_imageURL),
    //   width: _sliderValue,
    //   fit: BoxFit.contain,
    // );
    return Container(
      decoration: BoxDecoration(shape: BoxShape.circle,
          color: currentColor),
      width: _sliderValue,
       // fit: BoxFit.contain,
      height: 20,
      child: Center(child: Text('Hello', style: TextStyle(color: textColor,fontSize: _sliderValue/5)))
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