import 'package:sqflite/sqflite.dart';
import 'contacts_model.dart';

class ContactsDBWorker {
  static final ContactsDBWorker _db = _SqfliteContactsDBWorker._();

  static ContactsDBWorker get db => _db;

  @override
  Future<int> create(Contact contact) {
    return _db.create(contact);
  }

  @override
  Future<void> delete(int id) {
    return _db.delete(id);
  }

  @override
  Future<Contact> get(int id) {
    return _db.get(id);
  }

  @override
  Future<List<Contact>> getAll() {
    return _db.getAll();
  }


  @override
  Future<void> update(Contact contact) {
    return _db.update(contact);
  }
}

class _SqfliteContactsDBWorker implements ContactsDBWorker {

  static const String DB_NAME = 'contacts.db';
  static const String TBL_NAME = 'contacts';
  static const String KEY_ID = 'id';
  static const String KEY_NAME = 'name';
  static const String KEY_PHONE = 'phone';
  static const String KEY_EMAIL = 'email';
  static const String KEY_BIRTHDAY = 'birthday';

  Future<Database> _init() async {
    return await openDatabase(DB_NAME,
        version: 1,
        onOpen: (db) {},
        onCreate: (Database db, int version) async {
          await db.execute(
              "CREATE TABLE IF NOT EXISTS $TBL_NAME ("
                  "$KEY_ID INTEGER PRIMARY KEY,"
                  "$KEY_NAME TEXT,"
                  "$KEY_PHONE TEXT,"
                  "$KEY_EMAIL TEXT,"
                  "$KEY_BIRTHDAY TEXT"
                  ")"
          );
        }
    );
  }


  var _db;

  _SqfliteContactsDBWorker._();

  Future<Database> get database async =>
      _db ??= await _init();

  @override
  Future<int> create(Contact contact) async {
    Database db = await database;
    int id = await db.rawInsert(
        "INSERT INTO $TBL_NAME ($KEY_NAME, $KEY_PHONE, $KEY_EMAIL, $KEY_BIRTHDAY) "
            "VALUES (?, ?, ?, ?)",
        [contact.name, contact.phone, contact.email, contact.birthday]
    );
    print("Added: $contact");
    return id;
  }

  @override
  Future<void> delete(int id) async {
    Database db = await database;
    await db.delete(TBL_NAME, where: "$KEY_ID = ?", whereArgs: [id]);
  }

  @override
  Future<void> update(Contact contact) async {
    Database db = await database;
    await db.update(TBL_NAME, _contactToMap(contact),
        where: "$KEY_ID = ?", whereArgs: [contact.id]);
  }

  @override
  Future<Contact> get(int id) async {
    Database db = await database;
    var values = await db.query(TBL_NAME, where: "$KEY_ID = ?", whereArgs: [id]);
    return _contactFromMap(values.first);
  }

  @override
  Future<List<Contact>> getAll() async {
    Database db = await database;
    var values = await db.query(TBL_NAME);
    return values.isNotEmpty ? values.map((m) => _contactFromMap(m)).toList() : [];
  }

  Contact _contactFromMap(Map map) {
    return Contact()
      ..id = map[KEY_ID]
      ..name = map[KEY_NAME]
      ..phone = map[KEY_PHONE]
      ..email = map[KEY_EMAIL]
      ..birthday = map[KEY_BIRTHDAY];
  }

  Map<String, dynamic> _contactToMap(Contact contact) {
    return Map<String, dynamic>()
      ..[KEY_ID] = contact.id
      ..[KEY_NAME] = contact.name
      ..[KEY_PHONE] = contact.phone
      ..[KEY_EMAIL] = contact.email
      ..[KEY_BIRTHDAY] = contact.birthday;
  }
}