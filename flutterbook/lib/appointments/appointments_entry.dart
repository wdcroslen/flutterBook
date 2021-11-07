import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterbook/appointments/appointments_db_worker.dart';
import 'package:scoped_model/scoped_model.dart';
import 'appointments_model.dart';
import 'package:flutterbook/utils.dart';
import 'package:flutterbook/appointments/appointments_model.dart';
import 'appointments_db_worker.dart';

class AppointmentsEntry extends StatelessWidget {

  final TextEditingController _titleEditingController = TextEditingController();
  final TextEditingController _contentEditingController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  AppointmentsEntry() {
    _titleEditingController.addListener(() {
     var a = _titleEditingController.text.split(' ');
     appointmentsModel.entityBeingEdited.title = a[0];
     appointmentsModel.entityBeingEdited.description = _titleEditingController.text;
    });
    _contentEditingController.addListener(() {
      appointmentsModel.entityBeingEdited.time  = _contentEditingController.text;
    });
  }

  Future<void> _selectTime(BuildContext context) async {
    TimeOfDay initialTime = TimeOfDay.now();
    // if (appointmentsModel.entityBeingEdited.time != '') {
    //   initialTime = toTime(appointmentsModel.entityBeingEdited.time);
    // }
    TimeOfDay? picked = await showTimePicker(context: context, initialTime: initialTime);
    if (picked != null) {
      appointmentsModel.entityBeingEdited.time = "${picked.hour},${picked.minute}";
      appointmentsModel.setTime(picked.format(context));
    }
  }


  void _save(BuildContext context, AppointmentsModel model) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    if (model.entityBeingEdited.id == -1) {
      await AppointmentsDBWorker.db.create(appointmentsModel.entityBeingEdited);
    } else {
      await AppointmentsDBWorker.db.update(appointmentsModel.entityBeingEdited);
    }
    appointmentsModel.loadData(AppointmentsDBWorker.db);

    model.setStackIndex(0);
    Scaffold.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2), content: Text('Appointment saved'),
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

  Row _buildControlButtons(BuildContext context, AppointmentsModel model) {
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
          _save(context, appointmentsModel);
        },
      )
    ]
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<AppointmentsModel>(
        builder: (BuildContext context, Widget? child, AppointmentsModel model) {
          if (model.entityBeingEdited!=null) {
            if (model.entityBeingEdited.description != '') {
              _titleEditingController.text =
                  model.entityBeingEdited.description;
            }
            if (model.entityBeingEdited.time != '') {
              _contentEditingController.text = model.entityBeingEdited.time;
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
                            leading: Icon(Icons.alarm),
                            title: Text("Time"),
                            subtitle: Text(appointmentsModel.time),
                            trailing: IconButton(
                                icon: Icon(Icons.edit),
                                color: Colors.blue,
                                onPressed: () => _selectTime(context)
                            )
                        )
                      ]
                  )
              )
          );
        }
    );
  }
}