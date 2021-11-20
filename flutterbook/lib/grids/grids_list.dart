import 'package:flutter/material.dart';
import 'package:flutterbook/grids/grids_model.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:scoped_model/scoped_model.dart';
import 'grids_db_worker.dart';
import 'grids_model.dart';
import 'grid_entry.dart';
import 'dart:io';

class GridsList extends StatelessWidget {
  const GridsList({Key? key}) : super(key: key);

  _deleteGrid(BuildContext context, GridsModel model,
      Grid grid) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (alertContext) {
          return AlertDialog(
            title: const Text('Delete Grid'),
            content: Text('Are you sure you want to delete \'${grid.text}\''),
            actions: [
              TextButton(
                child: const Text('Cancel'),
                onPressed: () => Navigator.of(alertContext).pop(),
              ),
              TextButton(
                child: const Text('Delete'),
                onPressed: () {
                  model.entityList.remove(grid);
                  model.setStackIndex(0);
                  Navigator.of(alertContext).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          backgroundColor: Colors.red,
                          duration: Duration(seconds: 2),
                          content: Text('Grid deleted')
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
    return ScopedModel<GridsModel>(
        model: gridsModel,
        child: ScopedModelDescendant<GridsModel>(
            builder: (BuildContext inContext, Widget? inChild,
                GridsModel inModel) {
              return Scaffold(
                floatingActionButton: FloatingActionButton(
                    child: const Icon(Icons.add, color: Colors.white),
                    onPressed: () {
                      gridsModel.entityBeingEdited = Grid();
                      gridsModel.setStackIndex(1);
                    }
                ),
                body: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisSpacing: 2,
                      mainAxisSpacing: 2,
                      crossAxisCount: 3,
                    ),
                    itemCount: gridsModel.entityList.length,
                    itemBuilder: (context, index) {
                      Grid grid = gridsModel.entityList[index];

                      return GestureDetector(
                          onTap: () {
                            gridsModel.entityBeingEdited = grid;
                            gridsModel.setStackIndex(1);
                          },
                        child: Container(
                          padding: const EdgeInsets.fromLTRB(5, 5, 5, 0),
                        child: Container(
                          child: Slidable(
                            actionPane: SlidableDrawerActionPane(),
                            actionExtentRatio: .40,
                            secondaryActions: [
                              IconSlideAction(
                                  caption: "Delete",
                                  color: Colors.red,
                                  icon: Icons.delete,
                                  onTap: () => _deleteGrid(context, gridsModel, grid)
                              )
                            ],
                            child:
                              Center(child: Text(gridsModel.entityList[index].text,
                                  style: TextStyle(
                                      color: Color(int.parse(gridsModel.entityList[index]
                                          .textColor)),
                                      fontSize: 20)))
                          ),
                          decoration: BoxDecoration(shape: BoxShape.circle,
                              color: Color(int.parse(gridsModel.entityList[index]
                                  .backgroundColor))),
                          width: 40,
                          height: 40,
                        )
                        ),
                      );
                    }
                ),
              );
            })
    );
  }
}