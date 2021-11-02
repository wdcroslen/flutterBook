import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'notes_entry.dart';
import 'notes_model.dart' show NotesModel, notesModel;
import 'notes_list.dart';

class Notes extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return ScopedModel<NotesModel>(
        model: notesModel,
        child: ScopedModelDescendant<NotesModel>(
            builder: (BuildContext context, Widget? child, NotesModel model) {
              return IndexedStack(
                index: model.stackIndex,
                children: <Widget>[NotesList(), NotesEntry()],
              );
            }
        )
    );
  }
}
