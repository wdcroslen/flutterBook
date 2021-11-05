import 'package:flutter/material.dart';
import 'package:flutterbook/tasks/tasks_model.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:scoped_model/scoped_model.dart';
import 'tasks_db_worker.dart';

class TasksList extends StatelessWidget {
  const TasksList({Key? key}) : super(key: key);

  _deleteTask(BuildContext context, TasksModel model, Task task) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (alertContext) {
          return AlertDialog(
            title: const Text('Delete Task'),
            content: Text('Are you sure you want to delete \'${task.description}\''),
            actions: [
              TextButton(
                child: const Text('Cancel'),
                onPressed: () => Navigator.of(alertContext).pop(),
              ),
              TextButton(
                child: const Text('Delete'),
                onPressed: () {
                  model.entityList.remove(task);
                  model.setStackIndex(0);
                  Navigator.of(alertContext).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          backgroundColor: Colors.red,
                          duration: Duration(seconds: 2),
                          content: Text('Task deleted')
                      )
                  );
                },
              )
            ],
          );
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<TasksModel> (
        builder: (context, child, model) =>
            Scaffold(
              floatingActionButton: FloatingActionButton(
                child: const Icon(
                    Icons.add,
                    color: Colors.white
                ),
                onPressed: () {
                  model.entityBeingEdited = Task();
                  model.setStackIndex(1);
                },
              ),
              body: ListView.builder(
                  itemCount: model.entityList.length,
                  itemBuilder: (context, int index) {
                    Task task = tasksModel.entityList[index];
                    Color color = Colors.green;
                    return Container(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                      child: Slidable(
                        actionPane: const SlidableDrawerActionPane(),
                        actionExtentRatio: .25,
                        secondaryActions: [
                          IconSlideAction(
                              caption: 'Delete',
                              color: Colors.red,
                              icon: Icons.delete,
                              onTap: () => _deleteTask(context, model, task)
                          )
                        ],
                        child: ListTile(
                          leading: Checkbox(
                            value: task.completed,
                            onChanged: (bool? value) {
                              task.completed = !value!;
                              TasksDBWorker.db.update(task);
                              tasksModel.loadData(TasksDBWorker.db);
                            },
                          ),
                          title: Text(
                            task.description,
                            style: task.completed ? TextStyle(color: Theme.of(context).disabledColor, decoration: TextDecoration.lineThrough) : null,
                          ),
                          subtitle: Text(task.dueDate),
                          onTap: () {
                            model.entityBeingEdited = task;
                            model.setStackIndex(1);
                          },
                        ),
                      ),
                    );
                  }
              ),
            )
    );
  }
}