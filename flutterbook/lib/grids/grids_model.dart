import 'package:flutterbook/base_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

GridsModel gridsModel = GridsModel();

class Grid {
  int id = -1;
  Color backgroundColor = Colors.black;
  Color textColor = Colors.white;
  String text = '';


  // updateColor(){
  //   url = defaultURL + backgroundColor + '/' + textColor + '&text=' + text;
  //   print(url);
  // }


  @override
  String toString()  =>
      "{ id=$id, text=$text, textColor=$textColor, backgroundColor=$backgroundColor,}";
}

class GridsModel extends BaseModel<Grid> {}