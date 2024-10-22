import 'package:english_dictionary/repository/model/history_model.dart';
import 'package:english_dictionary/repository/model/hitsory_fields.dart';
import 'package:english_dictionary/repository/model/word_model.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'package:english_dictionary/repository/local_db/Database.dart';

abstract class IDbHistory {
  Future<int> insert(HistoryModel history);
  Future<List<WordModel>> get();
  Future<int> remove(String value);
}

class DbHistory implements IDbHistory {
  final IDatabaseConfigure _databaseConfigure;
  DbHistory(
    this._databaseConfigure,
  );

  @override
  Future<int> insert(HistoryModel history) async {
    Database bancoDados = await _databaseConfigure.db;
    final json = history.toJson();

    final resul = await bancoDados.rawQuery("""SELECT * 
        FROM ${HistoryFields.tableName} 
        WHERE ${HistoryFields.word} = '${history.word}'""");

    if (resul.isNotEmpty) {
      await remove(history.word);
    }
    return await bancoDados.insert(HistoryFields.tableName, json);
  }

  @override
  Future<List<WordModel>> get() async {
    Database bancoDados = await _databaseConfigure.db;
    final result = await bancoDados.rawQuery("""
        SELECT ${HistoryFields.word} 
        FROM ${HistoryFields.tableName} 
        ORDER BY ${HistoryFields.dateTime} DESC""");
    return result.map((e) => WordModel.fromJson(e)).toList();
  }

  @override
  Future<int> remove(String word) async {
    Database bancoDados = await _databaseConfigure.db;
    return await bancoDados.delete(HistoryFields.tableName,
        where: "${HistoryFields.word} = ?", whereArgs: [word]);
  }
}
