import 'dart:io' as io;
import 'package:english_dictionary/repository/local_db/model/favorites_fields.dart';
import 'package:english_dictionary/repository/local_db/model/hitsory_fields.dart';
import 'package:english_dictionary/view/home/components/home_history.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

abstract class IDatabaseConfigure {
  get db;
}

class DatabaseConfigure implements IDatabaseConfigure {
  Database? _db;

  @override
  get db async {
    _db ??= await _starDB();
    return _db;
  }

  Future<Database> _starDB() async {
    _sqfliteTestInit();
    final io.Directory appDocumentsDir =
        await getApplicationDocumentsDirectory();

    if (!await appDocumentsDir.exists()) {
      appDocumentsDir.create(recursive: true);
    }

    String dbPath = p.join(appDocumentsDir.path, "english_dictionary.db");

    return await databaseFactory.openDatabase(dbPath,
        options: OpenDatabaseOptions(
          onCreate: _onCreate,
          version: 1,
        ));
  }

  Future<void> _onCreate(Database db, int version) async {
    String favorites = """CREATE TABLE ${FavoritesFields.tableName} (
        ${FavoritesFields.id} ${FavoritesFields.idType} ,
        ${FavoritesFields.word} ${FavoritesFields.wordType} ,
        ${FavoritesFields.dateTime} ${FavoritesFields.dateTimeType})
        """;

    String history = """CREATE TABLE ${HistoryFields.tableName} (
        ${HistoryFields.id} ${HistoryFields.idType} ,
        ${HistoryFields.word} ${HistoryFields.wordType} ,
        ${HistoryFields.dateTime} ${HistoryFields.dateTimeType})
        """;

    await db.execute(favorites);
    await db.execute(history);
  }

  void _sqfliteTestInit() {
    // Initialize ffi implementation
    sqfliteFfiInit();
    // Set global factory
    databaseFactory = databaseFactoryFfi;
  }
}
