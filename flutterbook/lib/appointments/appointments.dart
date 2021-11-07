import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'appointments_entry.dart';
import 'appointments_model.dart';
import 'appointments_list.dart';
import 'package:flutterbook/appointments/appointments_db_worker.dart';


class Appointments extends StatelessWidget {

  Appointments() {
    appointmentsModel.loadData(AppointmentsDBWorker.db);
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel<AppointmentsModel>(
        model: appointmentsModel,
        child: ScopedModelDescendant<AppointmentsModel>(
            builder: (BuildContext context, Widget? child, AppointmentsModel model) {
              return IndexedStack(
                index: model.stackIndex,
                children: <Widget>[AppointmentsList(), AppointmentsEntry()],
              );
            }
        )
    );
  }
}