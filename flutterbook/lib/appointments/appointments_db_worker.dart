import 'package:sqflite/sqflite.dart';

import 'appointments_model.dart';

class AppointmentsDBWorker {
  static final AppointmentsDBWorker _db = _SqfliteAppointmentsDBWorker._();

  static AppointmentsDBWorker get db => _db;

  @override
  Future<int> create(Appointment appointment) {
    return _db.create(appointment);
  }

  @override
  Future<void> delete(int id) {
    return _db.delete(id);
  }

  @override
  Future<Appointment> get(int id) {
    return _db.get(id);
  }

  @override
  Future<List<Appointment>> getAll() {
    return _db.getAll();
  }


  @override
  Future<void> update(Appointment appointment) {
    return _db.update(appointment);
  }
}

class _SqfliteAppointmentsDBWorker implements AppointmentsDBWorker {

  static const String DB_NAME = 'appointments.db';
  static const String TBL_NAME = 'appointments';
  static const String KEY_ID = 'id';
  static const String KEY_TITLE = 'title';
  static const String KEY_DESCRIPTION = 'description';
  static const String KEY_DATE = 'date';
  static const String KEY_TIME = 'time';

  Future<Database> _init() async {
    return await openDatabase(DB_NAME,
        version: 1,
        onOpen: (db) {},
        onCreate: (Database db, int version) async {
          await db.execute(
              "CREATE TABLE IF NOT EXISTS $TBL_NAME ("
                  "$KEY_ID INTEGER PRIMARY KEY,"
                  "$KEY_TITLE TEXT,"
                  "$KEY_DESCRIPTION TEXT,"
                  "$KEY_DATE TEXT,"
                  "$KEY_TIME TEXT"
                  ")"
          );
        }
    );
  }

  var _db;

  _SqfliteAppointmentsDBWorker._();

  Future<Database> get database async =>
      _db ??= await _init();

  @override
  Future<int> create(Appointment appointment) async {
    Database db = await database;
    int id = await db.rawInsert(
        "INSERT INTO $TBL_NAME ($KEY_TITLE, $KEY_DESCRIPTION, $KEY_DATE, $KEY_TIME) "
            "VALUES (?, ?, ?, ?)",
        [appointment.title, appointment.description, appointment.date, appointment.time]
    );
    print("Added: $appointment");
    return id;
  }

  @override
  Future<void> delete(int id) async {
    Database db = await database;
    await db.delete(TBL_NAME, where: "$KEY_ID = ?", whereArgs: [id]);
  }

  @override
  Future<void> update(Appointment appointment) async {
    Database db = await database;
    await db.update(TBL_NAME, _appointmentToMap(appointment),
        where: "$KEY_ID = ?", whereArgs: [appointment.id]);
  }

  @override
  Future<Appointment> get(int id) async {
    Database db = await database;
    var values = await db.query(TBL_NAME, where: "$KEY_ID = ?", whereArgs: [id]);
    return _appointmentFromMap(values.first);
  }

  @override
  Future<List<Appointment>> getAll() async {
    Database db = await database;
    var values = await db.query(TBL_NAME);
    return values.isNotEmpty ? values.map((m) => _appointmentFromMap(m)).toList() : [];
  }

  Appointment _appointmentFromMap(Map map) {
    return Appointment()
      ..id = map[KEY_ID]
      ..title = map[KEY_TITLE]
      ..description = map[KEY_DESCRIPTION]
      ..date = map[KEY_DATE]
      ..time = map[KEY_TIME];
  }

  Map<String, dynamic> _appointmentToMap(Appointment appointment) {
    return Map<String, dynamic>()
      ..[KEY_ID] = appointment.id
      ..[KEY_TITLE] = appointment.title
      ..[KEY_DESCRIPTION] = appointment.description
      ..[KEY_DATE] = appointment.date
      ..[KEY_TIME] = appointment.time;
  }
}