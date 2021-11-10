import 'package:flutter/material.dart';
import 'package:flutterbook/grids/grid_entry.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'grid_entry.dart';
import 'grids_model.dart';
import 'grids_list.dart';
import 'grids_db_worker.dart';
import 'package:flutterbook/contacts/contacts_db_worker.dart';

final List<String> _items = ['assets/images/tv.png','assets/images/clothes.png','assets/images/phones.png'];
final List<String> _networkItems = ['https://dummyimage.com/400x400/000/f44336&text=water','https://dummyimage.com/400x400/000/f44336&text=clothes','https://dummyimage.com/400x400/000/fff&text=phones'];
//https://dummyimage.com/600x400/000/fff&text=fire


  class Grids extends StatelessWidget {

    Grids() {
      gridsModel.loadData(GridsDBWorker.db);
    }

    @override
    Widget build(BuildContext context) {
      return ScopedModel<GridsModel>(
          model: gridsModel,
          child: ScopedModelDescendant<GridsModel>(
              builder: (BuildContext context, Widget? child, GridsModel model) {
                return IndexedStack(
                  index: model.stackIndex,
                  children: <Widget>[GridsList(), GridEntry('https://dummyimage.com/400x400/000/fff&text=EnterText')],
                );
              }
          )
      );
    }

  }





