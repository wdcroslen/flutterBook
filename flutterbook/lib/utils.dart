import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


DateTime toDate(String date) {
  List<String> parts = date.split(",");
  print(parts);
  return DateTime(int.parse(parts[0]), int.parse(parts[1]), int.parse(parts[2]));
}

TimeOfDay toTime(String time) { //TODO: FIX This method to return an actual time
  List<String> parts = time.split(",");
  print(parts);
  return TimeOfDay.now();
}

Future<String> selectDate(BuildContext context, dynamic model, String date) async {
  DateTime initialDate = DateTime.now();
  DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100));
  if (picked != null) {
    model.setChosenDate(DateFormat.yMMMMd('en_US').format(picked.toLocal()));
  }
  return "${picked?.year},${picked?.month},${picked?.day}";
}
