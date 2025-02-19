import 'package:english_dictionary/repository/model/favorites_fields.dart';
import 'package:english_dictionary/repository/model/favorites_model.dart';
import 'package:english_dictionary/repository/model/word_model.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'package:english_dictionary/repository/local_db/Database.dart';

abstract class IDbFavorites {
  Future<int> insert(FavoritesModel searHistoryModel);
  Future<List<WordModel>> getAll();
  Future<WordModel?> getWord(String word);
  Future<int> remove(String value);
}

class DbFavorites implements IDbFavorites {
  final IDatabaseConfigure _databaseConfigure;
  DbFavorites(
    this._databaseConfigure,
  );

  @override
  Future<int> insert(FavoritesModel favorites) async {
    Database bancoDados = await _databaseConfigure.db;
    final json = favorites.toJson();

    final resul = await bancoDados.rawQuery("""SELECT * 
        FROM ${FavoritesFields.tableName} 
        WHERE ${FavoritesFields.word} = '${favorites.word}'""");

    if (resul.isNotEmpty) {
      await remove(favorites.word);
    }
    return await bancoDados.insert(FavoritesFields.tableName, json);
  }

  @override
  Future<List<WordModel>> getAll() async {
    Database bancoDados = await _databaseConfigure.db;
    final result = await bancoDados.rawQuery("""SELECT ${FavoritesFields.word} 
        FROM ${FavoritesFields.tableName} 
        ORDER BY ${FavoritesFields.dateTime} DESC""");
    return result.map((e) => WordModel.fromJson(e)).toList();
  }

  @override
  Future<int> remove(String value) async {
    Database bancoDados = await _databaseConfigure.db;
    return await bancoDados.delete(FavoritesFields.tableName,
        where: "${FavoritesFields.word} = ?", whereArgs: [value]);
  }

  @override
  Future<WordModel?> getWord(String word) async {
    Database bancoDados = await _databaseConfigure.db;
    final result = await bancoDados.rawQuery("""SELECT * 
        FROM ${FavoritesFields.tableName} 
        WHERE ${FavoritesFields.word} = '$word'""");
    if (result.isNotEmpty) {
      return WordModel.fromJson(result[0]);
    }
    return null;
  }
}
