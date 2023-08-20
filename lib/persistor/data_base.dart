import 'dart:convert';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

const String databaseName = 'counter_state_db';

class InitializeDBHelper {
  Future<Database> initializeDB(String dbName) async {
    final String dbPath = await getDatabasesPath();
    final String path = join(dbPath, dbName);
    return await openDatabase(
      path,
      version: 1,
      onCreate: onCreateCallback,
    );
  }

  Future<void> onCreateCallback(Database db, int version) async {
    await db.execute(
        '''CREATE TABLE IF NOT EXISTS CounterState (count TEXT) ''');
  }

  Future<void> saveState(
    Map<String, dynamic> data,
  ) async {
    const String tableName = 'CounterState';

    final Database db = await initializeDB(databaseName);

    // await db.insert(
    //   tableName,
    //   data,
    //   conflictAlgorithm: ConflictAlgorithm.replace,
    // );

    await db.rawInsert(
      'INSERT INTO $tableName VALUES(?)',
      <dynamic>[jsonEncode(data)],
    );
  }

  Future<Map<String, dynamic>> retrieveState(String tableName) async {

    final Database db = await initializeDB(databaseName);

    final List<Map<String, dynamic>> states = await db.query(tableName);

    final Map<String, dynamic> state = Map<String, dynamic>.from(states.last);

    final dynamic localState = jsonDecode(jsonEncode(state));

    return localState as Map<String, dynamic>;
    
  }

  Future<void> clearStateDatabase() async {
    final Database db = await initializeDB(databaseName);
    await deleteDatabase(db.path);
  }

}