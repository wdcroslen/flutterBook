import "../base_model.dart";

ContactsModel contactsModel = ContactsModel();

class Contact {
  int id = -1;
  String name = '';
  String phone = '';
  String email = '';
  String birthday = '';

  String toString() {
    return "{ id=$id, name=$name, phone=$phone, email=$email, birthday=$birthday }";
  }
}
class ContactsModel
    extends BaseModel<Contact>
    with DateSelection {

  void setBirthday(String date) {
    super.setChosenDate(date);
  }

  void triggerRebuild() {
    notifyListeners();
  }
}
