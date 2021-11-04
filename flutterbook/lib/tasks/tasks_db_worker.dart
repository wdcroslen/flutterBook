import 'package:flutter/material.dart';
import 'package:flutterbook/notes/notes_model.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutterbook/main.dart';

class TasksDBWorker {
  static const String DB_NAME = 'tasks.db';
  static const String TBL_NAME = 'tasks';
  static const String KEY_ID = 'id';
  static const String KEY_DESCRIPTION = 'description';
  static const String KEY_DUE_DATE = 'dueDate';
  static const String KEY_COMPLETED = 'completed';


  Database? db;

  TasksDBWorker._();

  Future<Database> get database async =>
      db ??= await _init();

  Future<Database> _init() async {
    return await openDatabase(DB_NAME,
        version: 1,
        onOpen: (db) {},
        onCreate: (Database db, int version) async {
          await db.execute(
              "CREATE TABLE IF NOT EXISTS $TBL_NAME ("
                  "$KEY_ID INTEGER PRIMARY KEY,"
                  "$KEY_DESCRIPTION TEXT,"
                  "$KEY_DUE_DATE TEXT,"
                  "$KEY_COMPLETED INTEGER"
                  ")"
          );
        }
    );
  }

}

