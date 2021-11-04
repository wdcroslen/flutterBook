import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutterbook/notes/notes_model.dart';
import 'package:flutterbook/notes/notes_list.dart';
import 'package:flutterbook/notes/notes_db_worker.dart';

class NotesEntry extends StatelessWidget {

  final TextEditingController _titleEditingController = TextEditingController();
  final TextEditingController _contentEditingController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  _toColor(String color) {
    Color c = Colors.red;
    switch (color) {
      case "red" : c = Colors.red; break;
      case "green" : c = Colors.green; break;
      case "blue" : c = Colors.blue; break;
      case "yellow" : c = Colors.yellow; break;
      case "grey" : c = Colors.grey; break;
      case "purple" : c = Colors.purple; break;
    }
    return c;
  }

  NotesEntry() {
    _titleEditingController.addListener(() {
      notesModel.entryBeingEdited.title = _titleEditingController.text;
    });
    _contentEditingController.addListener(() {
      notesModel.entryBeingEdited.content  = _contentEditingController.text;
    });
  }

  ListTile _buildTitleListTile() {
    return ListTile(
        leading: Icon(Icons.title),
        title: TextFormField(
          decoration: InputDecoration(hintText: 'Title'),
          controller: _titleEditingController,
          validator: (String? value) {
            if (value?.length == 0) {
              return 'Please enter a title';
            }
            return null;
          },
        )
    );
  }

  ListTile _buildContentListTile() {
    return ListTile(
        leading: Icon(Icons.content_paste),
        title: TextFormField(
            keyboardType: TextInputType.multiline,
            maxLines: 8,
            decoration: InputDecoration(hintText: 'Content'),
            controller: _contentEditingController,
            validator: (String? value) {
              if (value?.length == 0) {
                return 'Please enter content';
              }
              return null;
            }
        )
    );
  }

  ListTile _buildColorListTile(BuildContext context) {
    const colors = ['red', 'green', 'blue', 'yellow', 'grey', 'purple'];
    return ListTile(
        leading: const Icon(Icons.color_lens),
        title: Row(
            children: colors.expand((c) =>
            [_buildColorBox(context, c), Spacer()]).toList()..removeLast()
        )
    );
  }

  GestureDetector _buildColorBox(BuildContext context, String color) {
    final Color colorValue = _toColor(color);
    return GestureDetector(
        child: Container(
            decoration: ShapeDecoration(
                shape: Border.all(width: 16, color: colorValue) +
                    Border.all(width: 4,  color: notesModel.color == color ? colorValue : Theme.of(context).canvasColor)
            )
        ),
        onTap: () {
          notesModel.entryBeingEdited.color = color;
          notesModel.setColor(color);
        }
    );
  }

  Row _buildControlButtons(BuildContext context, NotesModel model) {
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
          _save(context, notesModel);
        },
      )
    ]
    );
  }

  void _save(BuildContext context, NotesModel model) async {
//    if (!_formKey.currentState.validate()) {
//      return;
//    }
//    if (!model.entryList.contains(model.entryBeingEdited)) {
//      model.entryList.add(model.entryBeingEdited);
//    }

    if (model.entryBeingEdited.id == -1) {
      await NotesDBWorker.db.create(notesModel.entryBeingEdited);
    } else {
      await NotesDBWorker.db.update(notesModel.entryBeingEdited);
    }
    notesModel.loadData(NotesDBWorker.db);


    model.setStackIndex(0);
    Scaffold.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2), content: Text('Note saved'),
        )
    );
  }








  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<NotesModel>(
        builder: (BuildContext context, Widget? child, NotesModel model) {
          _titleEditingController.text = model.entryBeingEdited.title;
          _contentEditingController.text = model.entryBeingEdited.content;
          return Scaffold(
              bottomNavigationBar: Padding(
                  padding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
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
                  )
              )
          );
        }
    );
  }
}


