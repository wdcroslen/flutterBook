import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterbook/contacts/contacts_db_worker.dart';
import 'package:scoped_model/scoped_model.dart';
import 'contacts_model.dart';
import 'package:flutterbook/utils.dart';
import 'package:flutterbook/contacts/contacts_model.dart';
import 'contacts_db_worker.dart';
import 'dart:io';
import 'package:path/path.dart';
// import 'package:image_picker/image_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'avatar.dart';

class ContactsEntry extends StatelessWidget {

  final TextEditingController _nameEditingController = TextEditingController();
  final TextEditingController _phoneEditingController = TextEditingController();
  final TextEditingController _emailEditingController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  ContactsEntry() {
    _nameEditingController.addListener(() {
      contactsModel.entityBeingEdited.name = _nameEditingController.text;
    });
    _phoneEditingController.addListener(() {
      contactsModel.entityBeingEdited.phone = _phoneEditingController.text;
    });
    _emailEditingController.addListener(() {
      contactsModel.entityBeingEdited.email = _emailEditingController.text;
    });
  }

  void _save(BuildContext context, ContactsModel model) async {
    // id = await ContactsDBWorker.db.create( contactsModel.entityBeingEdited);
    // ...some other code you’re already familiar with...
    // File avatarFile = File(join(utils.docsDir.path, "avatar")); if (avatarFile.existsSync()) {
    // avatarFile.renameSync( join(utils.docsDir.path, id.toString())
    // ); }
    if (!_formKey.currentState!.validate()) {
      return;
    }
    File avatarFile = File(join(Avatar.docsDir.path, "avatar"));
    if (avatarFile.existsSync()) {
      avatarFile.renameSync
          (join(Avatar.docsDir.path, model.entityBeingEdited.id.toString()));
    }

    if (model.entityBeingEdited.id == -1) {
      await ContactsDBWorker.db.create(contactsModel.entityBeingEdited);
    } else {
      await ContactsDBWorker.db.update(contactsModel.entityBeingEdited);
    }
    contactsModel.loadData(ContactsDBWorker.db);

    model.setStackIndex(0);
    Scaffold.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2), content: Text('Contact saved'),
        )
    );
  }

  Future _selectAvatar(BuildContext inContext) {
    return showDialog(context: inContext,
        builder: (BuildContext inDialogContext) {
          return AlertDialog(content: SingleChildScrollView(
              child: ListBody(children: [
                GestureDetector(child: Text("Take a picture"),
                    onTap: () async {
                      ImagePicker imagePicker = ImagePicker();
                      var cameraImage = await imagePicker.pickImage(
                          source: ImageSource.camera);
                      File cameraImageFile = File(cameraImage!.path);
                      if (cameraImage != null) {
                          cameraImageFile.copySync(
                        join(Avatar.docsDir.path, "avatar") );
                        contactsModel.triggerRebuild();
                      }
                      Navigator.of(inDialogContext).pop();
                    }
                ),
                GestureDetector(
                    child: Text("Select From Gallery"), onTap: () async {
                  ImagePicker imagePicker = ImagePicker();
                  var galleryImage = await imagePicker.pickImage(
                      source: ImageSource.gallery);
                  File galleryImageFile = File(galleryImage!.path);
                  if (galleryImage != null) {
                    galleryImageFile.copySync( join(Avatar.docsDir.path, "avatar"));
                    contactsModel.triggerRebuild();
                  }
                  Navigator.of(inDialogContext).pop();
                }
                ),
              ]
              )
          )
          );
        }
    );
  }

  Row _buildControlButtons(BuildContext context, ContactsModel model) {
    return Row(children: [
      TextButton(child: Text("Cancel"), onPressed: () {
        File avatarFile = File(join(Avatar.docsDir.path,
            "avatar"));
        if (avatarFile.existsSync()) {
          avatarFile.deleteSync();
        }
        FocusScope.of(context).requestFocus(FocusNode());
        model.setStackIndex(0);
      }),
      Spacer(),
      TextButton(child: Text("Save"),
          onPressed: () {
            _save(context, model);
          })
    ]
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel(model : contactsModel,
        child : ScopedModelDescendant<ContactsModel>(
        builder : (BuildContext inContext, Widget? inChild, ContactsModel inModel) {
          File avatarFile =
          File(join(Avatar.docsDir.path, "avatar"));
          if (avatarFile.existsSync() == false) {
            if (inModel.entityBeingEdited != null &&
                inModel.entityBeingEdited.id != -1
            ) {
              avatarFile = File(join(Avatar.docsDir.path,
                  inModel.entityBeingEdited.id.toString()));
            }
          }

          if (inModel.entityBeingEdited!=null) {
            if (inModel.entityBeingEdited.name != '') {
              _nameEditingController.text =
                  inModel.entityBeingEdited.name;
            }
            if (inModel.entityBeingEdited.phone != '') {
              _phoneEditingController.text = inModel.entityBeingEdited.phone;
            }
            if (inModel.entityBeingEdited.email != '') {
              _emailEditingController.text = inModel.entityBeingEdited.email;
            }
          }
          return Scaffold(bottomNavigationBar: Padding(
              padding:
              EdgeInsets.symmetric(vertical: 0, horizontal: 10),
              child: _buildControlButtons(context, inModel)),

              body: Form(key: _formKey, child: ListView(
                  children: [
                    ListTile(title: avatarFile.existsSync()
                        ? Image.file(avatarFile)
                        :
                    Text("No avatar image for this contact"),
                        trailing: IconButton(icon: Icon(Icons.edit),
                            color: Colors.blue,
                            onPressed: () => _selectAvatar(inContext))
                    )
                    ,
                    ListTile(leading: Icon(Icons.person), title: TextFormField(
                        decoration: InputDecoration(hintText: "Name"),
                        controller: _nameEditingController,
                        validator: (String? inValue) {
                          if (inValue?.length == 0) {
                            return "Please enter a name";
                          }
                          return null;
                        }
                    )),

                    ListTile(leading: const Icon(Icons.phone), title: TextFormField(
                        keyboardType: TextInputType.phone,
                        decoration: const InputDecoration(hintText: "Phone"),
                        controller: _phoneEditingController)
                    ),
                    ListTile(leading: const Icon(Icons.email),
                        title: TextFormField(
                            keyboardType: TextInputType.emailAddress,
                            decoration: const InputDecoration(hintText: "Email"),
                            controller: _emailEditingController)
                    ),
                    ListTile(leading: const Icon(Icons.today),
                        title: const Text("Birthday"),
                        subtitle: Text(contactsModel.chosenDate == '' ?
                        "" : contactsModel.chosenDate),
                        trailing: IconButton(icon: const Icon(Icons.edit),
                            color: Colors.blue, onPressed: () async {
                              String chosenDate = await selectDate(
                                  inContext, contactsModel,
                                  contactsModel.entityBeingEdited.birthday
                              );
                              if (chosenDate != '') {
                                contactsModel.entityBeingEdited.birthday =
                                    chosenDate;
                              }
                            })
                    )
                  ]
              )
              )
          );
        }
        )
    );

  }
}