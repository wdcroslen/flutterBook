import 'package:flutter/material.dart';
import 'package:flutterbook/contacts/contacts_model.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:scoped_model/scoped_model.dart';
import 'contacts_db_worker.dart';
import 'dart:io';
import 'package:path/path.dart';
import 'package:flutterbook/utils.dart';
import 'package:intl/intl.dart';
import 'avatar.dart';

class ContactsList extends StatelessWidget with Avatar {
  const ContactsList({Key? key}) : super(key: key);

  _deleteContact(BuildContext context, ContactsModel model,
      Contact contact) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (alertContext) {
          return AlertDialog(
            title: const Text('Delete Contact'),
            content: Text('Are you sure you want to delete \'${contact.name}\''),
            actions: [
              TextButton(
                child: const Text('Cancel'),
                onPressed: () => Navigator.of(alertContext).pop(),
              ),
              TextButton(
                child: const Text('Delete'),
                onPressed: () async {
                  File avatarFile = File(
                      join(Avatar.docsDir.path, model.entityBeingEdited.id.toString()));
                  if (avatarFile.existsSync()) {
                    avatarFile.deleteSync();
                  }
                  /*
                  File avatarFile = File(
                      join(Avatar.docsDir.path, model.entityBeingEdited.id.toString()));
                  if (avatarFile.existsSync()) {
                    avatarFile.deleteSync();
                  }
                  await ContactsDBWorker.db.delete(model.entityBeingEdited.id);
                  Navigator.of(alertContext).pop();
                  Scaffold.of(context).showSnackBar(
                      SnackBar(backgroundColor : Colors.red, duration : Duration(seconds : 2), content : Text("Contact deleted")));
                  contactsModel.loadData("contacts", ContactsDBWorker.db);
                  */
                  model.entityList.remove(contact);
                  model.setStackIndex(0);
                  Navigator.of(alertContext).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          backgroundColor: Colors.red,
                          duration: Duration(seconds: 2),
                          content: Text('Contact deleted')
                      )
                  );
                },
              )
            ],
          );
        }
    );
  }

  // Future deleteContact(BuildContext inContext,
  //     Contact inContact) async {
  //   return showDialog(context : inContext,
  //   barrierDismissible : false,
  //   builder : (BuildContext inAlertContext) {
  //     return AlertDialog(title : Text("Delete Contact"), content : Text(
  //         "Are you sure you want to delete ${inContact.name}?" ),
  //         actions : [
  //         FlatButton(child : Text("Cancel"),
  //   onPressed: () { Navigator.of(inAlertContext).pop();
  //   } ),
  //   FlatButton(child : Text("Delete"), onPressed : () async {
  //   File avatarFile = File(
  //   join(utils.docsDir.path, inContact.id.toString()));
  //   if (avatarFile.existsSync()) { avatarFile.deleteSync();
  //   }
  //   await ContactsDBWorker.db.delete(inContact.id); Navigator.of(inAlertContext).pop(); Scaffold.of(inContext).showSnackBar(
  //   SnackBar(backgroundColor : Colors.red, duration : Duration(seconds : 2), content : Text("Contact deleted")));
  //   contactsModel.loadData("contacts", ContactsDBWorker.db); }
  //   )
  //   );
  //   }
  //   );
  // }

  // void _editContact(BuildContext inContext, Contact
  // inContact) async {
  //   contactsModel.entityBeingEdited =
  //   await ContactsDBWorker.db.get(inContact.id);
  //   if (contactsModel.entityBeingEdited.date == '') {
  //     contactsModel.setChosenDate('');
  //   } else {
  //     List dateParts =
  //     contactsModel.entityBeingEdited.date.split(",");
  //     DateTime apptDate = DateTime(
  //         int.parse(dateParts[0]), int.parse(dateParts[1]),
  //         int.parse(dateParts[2]));
  //     contactsModel.setChosenDate(
  //         DateFormat.yMMMMd("en_US").format(apptDate.toLocal()));
  //   }
  //   if (contactsModel.entityBeingEdited.time == '') {
  //     contactsModel.setTime('');
  //   } else {
  //     List timeParts = contactsModel.entityBeingEdited.time.split(",");
  //     TimeOfDay apptTime = TimeOfDay(
  //         hour: int.parse(timeParts[0]), minute: int.parse(timeParts[1]));
  //     contactsModel.setTime(apptTime.format(inContext));
  //   }
  //   contactsModel.setStackIndex(1); Navigator.pop(inContext);
  // }


  @override
  Widget build(BuildContext context) {
    return ScopedModel<ContactsModel>(
        model: contactsModel,
        child: ScopedModelDescendant<ContactsModel>(
            builder: (BuildContext inContext, Widget? inChild,
                ContactsModel inModel) {
              return Scaffold(
                  floatingActionButton: FloatingActionButton(
                      child: const Icon(Icons.add, color: Colors.white),
                      onPressed: () async {
                        File avatarFile = File(
                            join(Avatar.docsDir.path, "avatar"));
                        if (avatarFile.existsSync()) {
                          avatarFile.deleteSync();
                        }
                        contactsModel.entityBeingEdited = Contact();
                        contactsModel.setChosenDate('');
                        contactsModel.setStackIndex(1);
                      }
                  ),

                  body: ListView.builder(
                      itemCount: contactsModel.entityList.length,
                      itemBuilder: (BuildContext inBuildContext, int inIndex) {
                        Contact contact = contactsModel.entityList[inIndex];
                        File avatarFile =
                        File(join(Avatar.docsDir.path, contact.id.toString()));
                        bool avatarFileExists = avatarFile.existsSync();
                        return Column(children : [
                            Slidable(
                            actionPane : const SlidableDrawerActionPane(),
                            actionExtentRatio : .25, child : ListTile( leading : CircleAvatar(
                            backgroundColor : Colors.indigoAccent, foregroundColor : Colors.white, backgroundImage : avatarFileExists ?
                            FileImage(avatarFile) : null,
                            child : avatarFileExists ? null :
                            Text(contact.name.substring(0, 1).toUpperCase()) ),

                            title : Text(contact.name), subtitle : contact.phone == '' ? null : Text(contact.phone),
                            onTap : () async {
                              File avatarFile =
                            File(join(Avatar.docsDir.path, "avatar"));
                            if (avatarFile.existsSync()) {
                              avatarFile.deleteSync();
                            }
                            contactsModel.entityBeingEdited =
                            await ContactsDBWorker.db.get(contact.id);
                            if (contactsModel.entityBeingEdited.birthday == null) {
                              contactsModel.setChosenDate('');
                            } else {
                              List dateParts = contactsModel.entityBeingEdited.birthday.split(",");
                              DateTime birthday = DateTime( int.parse(dateParts[0]), int.parse(dateParts[1]), int.parse(dateParts[2]));
                              contactsModel.setChosenDate( DateFormat.yMMMMd("en_US").format(birthday.toLocal())
                            );
                            }
                            contactsModel.setStackIndex(1);
                            }),

                            secondaryActions : [
                            IconSlideAction(caption : "Delete", color : Colors.red,
                            icon : Icons.delete,
                            onTap : () => _deleteContact(inContext, inModel, contact)) ]
                            ),
                            const Divider(),
                        ]
                        );
                      }
                  )
              );
            }
        )
    );
  }

}