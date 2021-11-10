import 'package:flutterbook/base_model.dart';

GridsModel gridsModel = GridsModel();

class Grid {
  int id = -1;
  String backgroundColor = '000';
  String textColor = 'fff';
  String text = '';
  String url = 'https://dummyimage.com/400x400/000/fff&text=';
  String defaultURL = 'https://dummyimage.com/400x400/';


  updateURL(){
    url = defaultURL+text;
  }

  updateColor(){
    url = defaultURL + backgroundColor + '/' + textColor + '&text=' + text;
    print(url);
  }


  @override
  String toString()  =>
      "{ id=$id, text=$text, textColor=$textColor, backgroundColor=$backgroundColor,}";
}

class GridsModel extends BaseModel<Grid> {}