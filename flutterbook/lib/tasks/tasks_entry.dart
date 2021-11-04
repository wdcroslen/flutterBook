import 'package:flutter/material.dart';
//import 'package:flutter_book/utils.dart';
import 'package:scoped_model/scoped_model.dart';
import 'tasks_model.dart';
import 'package:intl/intl.dart';

class TasksEntry extends StatelessWidget {
  const TasksEntry({Key? key}) : super(key: key);

  DateTime toDate(String date) {
    List<String> parts = date.split(",");
    return DateTime(int.parse(parts[0]), int.parse(parts[1]), int.parse(parts[2]));
  }

  String _dueDate() {
    if (tasksModel.entityBeingEdited != null && tasksModel.entityBeingEdited!.hasDueDate()) {
      return tasksModel.entityBeingEdited!.dueDate!;
    }
    return '';
  }

  Future<String> selectDate(BuildContext context, dynamic model, String? date) async {
    DateTime initialDate = date != null ? toDate(date) : DateTime.now();
    DateTime? picked = await showDatePicker(
        context: context,
        initialDate: initialDate,
        firstDate: DateTime(1900),
        lastDate: DateTime(2100)
    );
    if (picked != null) {
      model.setDateChosen(DateFormat.yMMMMd('en_US').format(picked.toLocal()));
    }
    return '${picked!.year},${picked.month},${picked.day}';
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<TasksModel>(
      builder: (context, child, model) {

        // ?
        return Scaffold(
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.symmetric(
                vertical: 0,
                horizontal: 10
            ),
            child: ListTile(
              leading: const Icon(Icons.today),
              title: const Text('Due Date'),
              subtitle: Text(_dueDate()),
              trailing: IconButton(
                icon: const Icon(Icons.edit),
                color: Colors.blue,
                onPressed: () async {
                  String chosenDate = await selectDate(context, tasksModel, tasksModel.entityBeingEdited!.dueDate);
                  if (chosenDate != null) {
                    tasksModel.entityBeingEdited!.dueDate = chosenDate;
                  }
                },
              ),
            ),
          ),
        );
      },
    );
  }
}