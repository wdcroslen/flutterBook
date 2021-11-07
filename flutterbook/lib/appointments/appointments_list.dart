import 'package:flutter/material.dart';
import 'package:flutterbook/appointments/appointments_model.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:scoped_model/scoped_model.dart';
import 'appointments_db_worker.dart';
import 'package:flutterbook/utils.dart';
import "package:flutter_calendar_carousel/" "flutter_calendar_carousel.dart";
import "package:flutter_calendar_carousel/classes/event.dart";
import "package:flutter_calendar_carousel/classes/event_list.dart";
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart' show CalendarCarousel;
import 'package:intl/intl.dart';


DateTime currentDate = DateTime.now();
class AppointmentsList extends StatelessWidget {
  const AppointmentsList({Key? key}) : super(key: key);

  _deleteAppointment(BuildContext context, AppointmentsModel model,
      Appointment appointment) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (alertContext) {
          return AlertDialog(
            title: const Text('Delete Appointment'),
            content: Text('Are you sure you want to delete \'${appointment
                .description}\''),
            actions: [
              TextButton(
                child: const Text('Cancel'),
                onPressed: () => Navigator.of(alertContext).pop(),
              ),
              TextButton(
                child: const Text('Delete'),
                onPressed: () {
                  model.entityList.remove(appointment);
                  model.setStackIndex(0);
                  Navigator.of(alertContext).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          backgroundColor: Colors.red,
                          duration: Duration(seconds: 2),
                          content: Text('Appointment deleted')
                      )
                  );
                },
              )
            ],
          );
        }
    );
  }

  void _editAppointment(BuildContext inContext, Appointment
  inAppointment) async {
    appointmentsModel.entityBeingEdited =
    await AppointmentsDBWorker.db.get(inAppointment.id);
    if (appointmentsModel.entityBeingEdited.date == '') {
      appointmentsModel.setChosenDate('');
    } else {
      List dateParts =
      appointmentsModel.entityBeingEdited.date.split(",");
      DateTime apptDate = DateTime(
          int.parse(dateParts[0]), int.parse(dateParts[1]),
          int.parse(dateParts[2]));
      appointmentsModel.setChosenDate(
          DateFormat.yMMMMd("en_US").format(apptDate.toLocal()));
    }
  if (appointmentsModel.entityBeingEdited.time == '') {
    appointmentsModel.setTime('');
  } else {
    List timeParts = appointmentsModel.entityBeingEdited.time.split(",");
    TimeOfDay apptTime = TimeOfDay(
        hour: int.parse(timeParts[0]), minute: int.parse(timeParts[1]));
    appointmentsModel.setTime(apptTime.format(inContext));
  }
  appointmentsModel.setStackIndex(1); Navigator.pop(inContext);
}

  void _showAppointments(DateTime inDate, BuildContext inContext) async {
    showModalBottomSheet(context: inContext,
        builder: (BuildContext inContext) {
          return ScopedModel<AppointmentsModel>(
              model: appointmentsModel,
              child: ScopedModelDescendant<AppointmentsModel>(
                  builder: (BuildContext inContext, Widget? inChild,
                      AppointmentsModel inModel) {
                    return Scaffold(
                        body: Container(child: Padding(
                            padding: EdgeInsets.all(10), child: GestureDetector(
                            child: Column(
                                children: [
                                  Text(DateFormat.yMMMMd("en_US").format(inDate
                                      .toLocal()), textAlign: TextAlign.center,
                                      style: TextStyle(color:
                                      Theme
                                          .of(inContext)
                                          .accentColor, fontSize: 24)),
                                  Divider(),
                                  Expanded(
                                      child: ListView.builder(
                                          itemCount: appointmentsModel
                                              .entityList
                                              .length,
                                          itemBuilder: (
                                              BuildContext inBuildContext,
                                              int inIndex) {
                                            Appointment appointment =
                                            appointmentsModel
                                                .entityList[inIndex];
                                            if (appointment.date !=
                                                "${inDate.year},${inDate
                                                    .month},${inDate
                                                    .day}") {
                                              return Container(height: 0);
                                            }
                                            String apptTime = "";
                                            if (appointment.time != '') {
                                              List timeParts = appointment.time
                                                  .split(
                                                  ",");
                                              TimeOfDay at = TimeOfDay(
                                                  hour: int.parse(timeParts[0]),
                                                  minute: int.parse(
                                                      timeParts[1]));
                                              apptTime =
                                              " (${at.format(inContext)})";
                                            }

                                            return Slidable(
                                                actionPane: const SlidableDrawerActionPane(),
                                                actionExtentRatio: .25,
                                                child: Container(
                                                    margin: EdgeInsets.only(
                                                        bottom: 8),
                                                    color: Colors.grey.shade300,
                                                    child: ListTile(
                                                        title: Text(
                                                            "${appointment
                                                                .title}$apptTime"),
                                                        subtitle: appointment.description == ''
                                                            ? null
                                                            : Text(appointment.description),
                                                        onTap: () async {
                                                          _editAppointment(
                                                              inContext,
                                                              appointment);
                                                        })
                                                ),
                                                secondaryActions: [
                                                  IconSlideAction(
                                                      caption: "Delete",
                                                      color: Colors.red,
                                                      icon: Icons.delete,
                                                      onTap: () =>
                                                          _deleteAppointment(
                                                              inBuildContext,
                                                              inModel,
                                                              appointment)
                                                  )
                                                ]
                                            );
                                          }
                                      )
                                  )
                                ]
                            )
                        )
                        )
                        )
                    );
                  }
              )
          );
        });
  }


  @override
  Widget build(BuildContext context) {
    EventList<Event> markedDateMap = EventList<Event>(
      events: {
        DateTime(20201, 11, 5): [
          Event(
            date: DateTime(2021, 11, 5),
            title: 'Event 1',
            icon: const Icon(Icons.add),
            dot: Container(
              margin: EdgeInsets.symmetric(horizontal: 1.0),
              color: Colors.green,
              height: 5.0,
              width: 5.0,
            ),
          ),
        ],
      },
    );
    markedDateMap.clear();
    for (Appointment app in appointmentsModel.entityList) {
      DateTime date = toDate(app.date);
      markedDateMap.add(date, Event(date: date,
          icon: Container(decoration: BoxDecoration(color: Colors.black))));
    }
    return ScopedModel<AppointmentsModel>(
        model: appointmentsModel,
        child: ScopedModelDescendant<AppointmentsModel>(
            builder: (inContext, inChild, inModel) {
              return Scaffold(
                  floatingActionButton: FloatingActionButton(
                      child: Icon(Icons.add, color: Colors.white),
                      onPressed: () async {
                        appointmentsModel.entityBeingEdited =
                            Appointment();
                        DateTime now = currentDate;
                        print(currentDate);
                        appointmentsModel.entityBeingEdited.date =
                        "${now.year},${now.month},${now.day}";
                        now = DateTime.now();
                        appointmentsModel.setChosenDate(
                            DateFormat.yMMMMd("en_US").format(now.toLocal()));
                        appointmentsModel.setTime('');
                        appointmentsModel.setStackIndex(1);
                      }
                  ),
                  body: Column(
                      children: [
                        Expanded(
                            child: Container(
                                margin: EdgeInsets.symmetric(horizontal: 10),
                                child: CalendarCarousel<Event>(
                                    thisMonthDayBorderColor: Colors.grey,
                                    daysHaveCircularBorder: false,
                                    markedDatesMap: markedDateMap,
                                    selectedDateTime: currentDate,
                                    onDayPressed:
                                        (DateTime inDate, List<
                                        Event> inEvents) {
                                        currentDate = inDate;
                                        _showAppointments(inDate, inContext);
                                    },)
                            ))
                      ])
              );
            }
        )
    );
  }
}