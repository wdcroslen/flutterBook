import 'package:flutterbook/base_model.dart';

ChartsModel chartsModel = ChartsModel();

class Chart {
  int id = -1;
  String title = '';
  String description = '';
  String date = '';
  String time = '';

  bool hasTime() => time != '';

  @override
  String toString()  =>
      "{ id=$id, title=$title, description=$description, date=$date, time=$time }";
}

class ChartsModel extends BaseModel<Chart>
    with DateSelection {

  String time = '';

  void setDate(String date) {
    super.setChosenDate(date);
  }

  void setTime(String time) {
    this.time = time;
    notifyListeners();
  }
}