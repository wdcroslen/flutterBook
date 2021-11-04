import 'package:flutter/material.dart';
import 'package:flutterbook/notes/notes_model.dart';
import 'package:scoped_model/scoped_model.dart';

class BaseModel<T> extends Model {
  int stackIndex = 0;
  List<T> entityList = [];
  var entityBeingEdited;

  void setStackIndex(int stackIndex) {
    this.stackIndex = stackIndex;
    notifyListeners();
  }

  void loadData(database) async {
    entityList.clear();
    entityList.addAll(await database.getAll());
    notifyListeners();
  }
}

mixin DateSelection on Model {
  String chosenDate = '';

  void setChosenDate(String date) {
    this.chosenDate = date;
    notifyListeners();
  }
}
