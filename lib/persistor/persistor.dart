import 'package:async_redux/async_redux.dart';
import 'package:sqflite/sqflite.dart';
import 'package:state_management/persistor/data_base.dart';
import 'package:state_management/state/counter_state.dart';

class MyPersistor extends Persistor<CounterState> {
  final dbHelper = InitializeDBHelper();

  Future<void> init() async {
    await InitializeDBHelper().initializeDB(databaseName);
  }

  @override
  Future<void> deleteState() async {
    await dbHelper.clearStateDatabase();
  }

  @override
  Future<void> persistDifference({
    required CounterState? lastPersistedState,
    required CounterState newState,
  }) async {
    if (lastPersistedState?.count != newState.count) {
      await dbHelper.saveState(newState.toJson());
    }
  }

  @override
  Future<CounterState?> readState() async {
    final Database db = await dbHelper.initializeDB(databaseName);

    // final int? count = Sqflite.firstIntValue(await db.query('CounterState'));

    final List<Map<String, dynamic>> states = await db.query('CounterState');

    if (states.isEmpty) {
      return CounterState.initial();
    } else {
      return CounterState.fromJson(await dbHelper.retrieveState('CounterState'));
    }
  }
}
