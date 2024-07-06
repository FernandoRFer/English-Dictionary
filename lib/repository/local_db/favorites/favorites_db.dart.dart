import 'dart:developer';
import 'dart:io' as io;

import 'package:english_dictionary/repository/local_db/favorites/favorites_model.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

abstract class IDbFavorites {
  Future<int> insert(FavoritesModel searHistoryModel);
  Future<List<String>> get();
  Future<int> remove(String value);
}

class DbFavorites implements IDbFavorites {
  final String _tableName = "favoriteWords";
  final String _id = "id";
  final String _word = "word";
  final String _dateTime = "dateTime";

  Database? _db;

  DbFavorites() {
    _sqfliteTestInit();
  }

  get db async {
    _db ??= await starDB();
    return _db;
  }

  Future<void> _onCreate(Database db, int version) async {
    String sql =
        "CREATE TABLE $_tableName ($_id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, $_dateTime INTEGER ,$_word TEXT)";
    await db.execute(sql);
  }

  Future<Database> starDB() async {
    _sqfliteTestInit();
    final io.Directory appDocumentsDir =
        await getApplicationDocumentsDirectory();

    if (!await appDocumentsDir.exists()) {
      appDocumentsDir.create(recursive: true);
    }

    String dbPath = p.join(appDocumentsDir.path, "produtos.db");

    Database db = await databaseFactory.openDatabase(dbPath,
        options: OpenDatabaseOptions(version: 1, onCreate: _onCreate));

    return db;
  }

  @override
  Future<int> insert(FavoritesModel favorites) async {
    Database bancoDados = await db;
    final json = favorites.toJson();

    final resul = await bancoDados.rawQuery(
        "SELECT * FROM $_tableName WHERE $_word = '${favorites.word}'");

    if (resul.isNotEmpty) {
      await remove(favorites.word);
    }
    return await bancoDados.insert(_tableName, json);
  }

  @override
  Future<List<String>> get() async {
    Database bancoDados = await db;
    final result = await bancoDados
        .rawQuery("SELECT $_word FROM $_tableName ORDER BY $_dateTime DESC");
    log(result.toString());
    return result.map((e) => FavoritesModel.fromJson(e).word).toList();
  }

  @override
  Future<int> remove(String value) async {
    Database bancoDados = await db;
    return await bancoDados
        .delete(_tableName, where: "$_word = ?", whereArgs: [value]);
  }

  void _sqfliteTestInit() {
    // Initialize ffi implementation
    sqfliteFfiInit();
    // Set global factory
    databaseFactory = databaseFactoryFfi;
  }
}
