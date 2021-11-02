import 'package:flutter/material.dart';
import 'package:flutterbook/notes/notes.dart';
import 'package:flutterbook/notes/notes_model.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter_slidable/flutter_slidable.dart';


class NotesList extends StatelessWidget {

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

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<NotesModel>(
        builder: (BuildContext context, Widget? child, NotesModel model)
    {
      return Scaffold(
          floatingActionButton: FloatingActionButton(
              child: Icon(Icons.add, color: Colors.white),
              onPressed: () {
                model.noteBeingEdited = Note();
                model.setColor('');
                model.setStackIndex(1);
              }
          ),
          body: ListView.builder(
              itemCount: model.noteList.length,
              itemBuilder: (BuildContext context, int index) {
                Note note = model.noteList[index];
                Color color = _toColor(note.color);
//
                return Container(
                    padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                    child: Slidable(
                        actionPane: SlidableDrawerActionPane(),
                        actionExtentRatio: .25,
                        secondaryActions: [
                          IconSlideAction(
                              caption: "Delete",
                              color: Colors.red,
                              icon: Icons.delete,
                              onTap: () => _deleteNote(context, model, note)
                          )
                        ],

//                            return Container(
//                        padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                        child: Card(
                            elevation: 8,
                            color: color,
                            child: ListTile(
                              title: Text(note.title),
                              subtitle: Text(note.content),
                              onTap: () {
                                model.noteBeingEdited = note;
                                model.setColor(model.noteBeingEdited.color);
                                model.setStackIndex(1);
                              },
                            )
                        )
                    )
                );
              }
          )
      );
    }
    );
  }

  _deleteNote(BuildContext context, NotesModel model, Note note) {
    return showDialog(
        context : context,
        barrierDismissible : false,
        builder : (BuildContext alertContext) {
          return AlertDialog(
              title : Text("Delete Note"),
              content : Text("Are you sure you want to delete ${note.title}?"),
              actions : [
                ElevatedButton(child : Text("Cancel"),
                    onPressed: () {
                          Navigator.of(alertContext).pop();
                    }
                ),
                ElevatedButton(child : Text("Delete"),
                    onPressed : () {
                      model.noteList.remove(note);
                      model.setStackIndex(0);
                      Navigator.of(alertContext).pop();
                      Scaffold.of(context).showSnackBar(
                          SnackBar(
                              backgroundColor : Colors.red,
                              duration : Duration(seconds : 2),
                              content : Text("Note deleted")
                          )
                      );
                    }
                ) ] ); } );
  }

}

