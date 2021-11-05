import 'package:flutter/material.dart';
import 'package:flutterbook/notes/notes_model.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutterbook/base_model.dart';


TasksModel tasksModel = TasksModel();

class Task {
  int id = -1;
  String description = '';
  String dueDate = '';
  bool completed = false; // note that the textbook uses String.

  String toString() {
    return "{ id=$id, description=$description, dueDate=$dueDate, completed=$completed }";
  }

  bool hasDueDate() {
    return dueDate != '';
  }
}

class TasksModel extends BaseModel<Task> with DateSelection {}
