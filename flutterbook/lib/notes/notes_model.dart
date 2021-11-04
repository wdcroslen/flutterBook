import 'package:flutterbook/base_model.dart';
import 'package:scoped_model/scoped_model.dart';

NotesModel notesModel = NotesModel();

class Note {
  int id = -1;
  String title = "";
  String content ="";
  String color = "";

  String toString() => "{ id=$id, title=$title, content=$content, color=$color }";

}

class NotesModel extends BaseModel<Note> {
  int stackIndex = 0;
  List<Note> entryList = [];
  Note entryBeingEdited = Note();
  String color = '';

  void setStackIndex(int stackIndex) {
    this.stackIndex = stackIndex;
    notifyListeners();
  }

  void setColor(String color) {
    this.color = color;
    notifyListeners();
  }
  void loadData(dynamic database) async {
    entryList.clear();
    entryList.addAll(await database.getAll());
    notifyListeners();
  }
}