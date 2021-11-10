import 'package:flutterbook/base_model.dart';

GridsModel gridsModel = GridsModel();

class Grid {
  int id = -1;
  String backgroundColor = '';
  String textColor = '';
  String text = '';


  @override
  String toString()  =>
      "{ id=$id, text=$text, textColor=$textColor, backgroundColor=$backgroundColor,}";
}

class GridsModel extends BaseModel<Grid> {}