import 'package:sqflite/sqflite.dart';
import 'grids_model.dart';

class GridsDBWorker {
  static final GridsDBWorker _db = _SqfliteGridsDBWorker._();

  static GridsDBWorker get db => _db;

  @override
  Future<int> create(Grid grid) {
    return _db.create(grid);
  }

  @override
  Future<void> delete(int id) {
    return _db.delete(id);
  }

  @override
  Future<Grid> get(int id) {
    return _db.get(id);
  }

  @override
  Future<List<Grid>> getAll() {
    return _db.getAll();
  }


  @override
  Future<void> update(Grid grid) {
    return _db.update(grid);
  }
}

class _SqfliteGridsDBWorker implements GridsDBWorker {

  static const String DB_NAME = 'grids.db';
  static const String TBL_NAME = 'grids';
  static const String KEY_ID = 'id';
  static const String KEY_BACKGROUND_COLOR = 'backgroundColor';
  static const String KEY_TEXT_COLOR = 'textColor';
  static const String KEY_TEXT = 'text';

  Future<Database> _init() async {
    return await openDatabase(DB_NAME,
        version: 1,
        onOpen: (db) {},
        onCreate: (Database db, int version) async {
          await db.execute(
              "CREATE TABLE IF NOT EXISTS $TBL_NAME ("
                  "$KEY_ID INTEGER PRIMARY KEY,"
                  "$KEY_BACKGROUND_COLOR TEXT,"
                  "$KEY_TEXT_COLOR TEXT,"
                  "$KEY_TEXT TEXT"
                  ")"
          );
        }
    );
  }


  var _db;

  _SqfliteGridsDBWorker._();

  Future<Database> get database async =>
      _db ??= await _init();

  @override
  Future<int> create(Grid grid) async {
    Database db = await database;
    int id = await db.rawInsert(
        "INSERT INTO $TBL_NAME ($KEY_BACKGROUND_COLOR, $KEY_TEXT_COLOR, $KEY_TEXT) "
            "VALUES (?, ?, ?, ?)",
        [grid.backgroundColor, grid.textColor, grid.text]
    );
    print("Added: $grid");
    return id;
  }

  @override
  Future<void> delete(int id) async {
    Database db = await database;
    await db.delete(TBL_NAME, where: "$KEY_ID = ?", whereArgs: [id]);
  }

  @override
  Future<void> update(Grid grid) async {
    Database db = await database;
    await db.update(TBL_NAME, _gridToMap(grid),
        where: "$KEY_ID = ?", whereArgs: [grid.id]);
  }

  @override
  Future<Grid> get(int id) async {
    Database db = await database;
    var values = await db.query(TBL_NAME, where: "$KEY_ID = ?", whereArgs: [id]);
    return _gridFromMap(values.first);
  }

  @override
  Future<List<Grid>> getAll() async {
    Database db = await database;
    var values = await db.query(TBL_NAME);
    return values.isNotEmpty ? values.map((m) => _gridFromMap(m)).toList() : [];
  }

  Grid _gridFromMap(Map map) {
    return Grid()
      ..id = map[KEY_ID]
      ..backgroundColor = map[KEY_BACKGROUND_COLOR]
      ..textColor = map[KEY_TEXT_COLOR]
      ..text = map[KEY_TEXT];
  }

  Map<String, dynamic> _gridToMap(Grid grid) {
    return Map<String, dynamic>()
      ..[KEY_ID] = grid.id
      ..[KEY_BACKGROUND_COLOR] = grid.backgroundColor
      ..[KEY_TEXT_COLOR] = grid.textColor
      ..[KEY_TEXT] = grid.text;
  }
}