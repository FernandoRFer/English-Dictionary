import 'package:english_dictionary/repository/local_db/model/hitsory_fields.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'package:english_dictionary/repository/local_db/Database.dart';
import 'package:english_dictionary/repository/local_db/History/History_model.dart';

abstract class IDbHistory {
  Future<int> insert(HistoryModel searHistoryModel);
  Future<List<String>> get();
  Future<int> remove(String value);
}

class DbHistory implements IDbHistory {
  final IDatabaseConfigure _databaseConfigure;
  DbHistory(
    this._databaseConfigure,
  );

  @override
  Future<int> insert(HistoryModel History) async {
    Database bancoDados = await _databaseConfigure.db;
    final json = History.toJson();

    final resul = await bancoDados.rawQuery("""SELECT * 
        FROM ${HistoryFields.tableName} 
        WHERE ${HistoryFields.word} = '${History.word}'""");

    if (resul.isNotEmpty) {
      await remove(History.word);
    }
    return await bancoDados.insert(HistoryFields.tableName, json);
  }

  @override
  Future<List<String>> get() async {
    Database bancoDados = await _databaseConfigure.db;
    final result = await bancoDados.rawQuery("""
        SELECT ${HistoryFields.word} 
        FROM ${HistoryFields.tableName} 
        ORDER BY ${HistoryFields.dateTime} DESC""");
    return result.map((e) => HistoryModel.fromJson(e).word).toList();
  }

  @override
  Future<int> remove(String value) async {
    Database bancoDados = await _databaseConfigure.db;
    return await bancoDados.delete(HistoryFields.tableName,
        where: "${HistoryFields.word} = ?", whereArgs: [value]);
  }
}
