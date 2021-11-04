import 'package:flutter/material.dart';
import 'package:flutterbook/notes/notes_model.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutterbook/tasks/tasks_model.dart';
import 'package:intl/intl.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutterbook/tasks/tasks_db_worker.dart';


//import 'package:intl/date_symbol_data_local.dart';


class TasksList extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<TasksModel>( /*TasksModel*/
        builder: (BuildContext context, Widget? child, TasksModel model) {
          return Scaffold(
              floatingActionButton: FloatingActionButton(
                  child: Icon(Icons.add, color: Colors.white),
                  onPressed: () {
                    model.entityBeingEdited = Task();
                    model.setStackIndex(1);
                  }
              ),
              body: ListView.builder(
                  padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                  itemCount: tasksModel.entityList.length,
                  itemBuilder: (BuildContext inBuildContext, int inIndex) {
                    Task task = tasksModel.entityList[inIndex];
                    String sDueDate = '';

                    if (task.dueDate != null) {
                      List dateParts = task.dueDate.split(",");
                      DateTime dueDate = DateTime(
                          int.parse(dateParts[0]), int.parse(dateParts[1]),
                          int.parse(dateParts[2]));
                      sDueDate =
                          DateFormat.yMMMMd("en_US").format(dueDate.toLocal());
                    }
                    return Slidable(actionPane: SlidableDrawerActionPane(), actionExtentRatio : .25, child : ListTile(
                        leading : Checkbox(
                        value : task.completed == "true" ? true : false, onChanged : (inValue) async {
                          task.completed = false;
//                          await TasksDBWorker.db.update(task);
//                          tasksModel.loadData("tasks", TasksDBWorker.db);
                        } ),

                    )
                    );
                  }
              )
          );
        }
    );
  }


}
