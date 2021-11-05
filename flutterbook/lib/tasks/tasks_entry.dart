import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterbook/tasks/tasks_db_worker.dart';
import 'package:intl/intl.dart';
import 'package:scoped_model/scoped_model.dart';

import '../utils.dart';
import 'tasks_model.dart';

class TasksEntry extends StatelessWidget {

  final TextEditingController _titleEditingController = TextEditingController();
  final TextEditingController _contentEditingController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TasksEntry() {
    _titleEditingController.addListener(() {
      tasksModel.entityBeingEdited.description = _titleEditingController.text;
    });
    _contentEditingController.addListener(() {
      tasksModel.entityBeingEdited.dueDate  = _contentEditingController.text;
    });
  }

  void _save(BuildContext context, TasksModel model) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    if (model.entityBeingEdited.id == -1) {
      await TasksDBWorker.db.create(tasksModel.entityBeingEdited);
    } else {
      await TasksDBWorker.db.update(tasksModel.entityBeingEdited);
    }
    tasksModel.loadData(TasksDBWorker.db);

    model.setStackIndex(0);
    Scaffold.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2), content: Text('Task saved'),
        )
    );
  }

  ListTile _buildContentListTile() {
    return ListTile(
        leading: Icon(Icons.content_paste),
        title: TextFormField(
            keyboardType: TextInputType.multiline,
            maxLines: 8,
            decoration: InputDecoration(hintText: 'Description'),
            controller: _titleEditingController,
            validator: (String? value) {
              if (value!.length == 0) {
                return 'Please enter description';
              }
              return null;
            }
        )
    );
  }

  Row _buildControlButtons(BuildContext context, TasksModel model) {
    return Row(children: [
      TextButton(
        child: Text('Cancel'),
        onPressed: () {
          FocusScope.of(context).requestFocus(FocusNode());
          model.setStackIndex(0);
        },
      ),
      Spacer(),
      TextButton(
        child: Text('Save'),
        onPressed: () {
          _save(context, tasksModel);
        },
      )
    ]
    );
  }

  String _dueDate() {
    if (tasksModel.entityBeingEdited != null && tasksModel.entityBeingEdited.hasDueDate()) {
      return tasksModel.entityBeingEdited.dueDate;
    }
    return '';
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
    return "${picked?.month}/${picked?.day}/${picked?.year}";
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<TasksModel>(
        builder: (BuildContext context, Widget? child, TasksModel model) {
          if (model.entityBeingEdited!=null) {
            if (model.entityBeingEdited.description != '') {
              _titleEditingController.text =
                  model.entityBeingEdited.description;
            }
            if (model.entityBeingEdited.dueDate != '') {
              _contentEditingController.text = model.entityBeingEdited.dueDate;
            }
          }
          return Scaffold(
              bottomNavigationBar: Padding(
                  padding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                  child: _buildControlButtons(context, model)
              ),
              body:
              Form(
                  key: _formKey,
                  child: ListView(
                      children: [
                        _buildContentListTile(),
                        ListTile(
                          leading: Icon(Icons.today),
                          title: Text("Due Date"),
                          subtitle: Text(_dueDate()),
                          trailing: IconButton(
                            icon: Icon(Icons.edit),
                            color: Colors.blue,
                            onPressed: () async {
                              String chosenDate = await selectDate(context, model,
                                  model.entityBeingEdited?.dueDate);
                              if (chosenDate != null) {
                                model.entityBeingEdited?.dueDate = chosenDate;
                              }
                            },
                          ),
                        ),
                      ]
                  )
              )
          );
        }
    );
  }
}