import 'dart:convert';
import 'dart:developer';

import 'package:english_dictionary/repository/model/word_details_entity.dart';
import 'package:hive/hive.dart';

import 'dart:async';

import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

abstract class IHistoryCache {
  Future<WordDetailsEntity?> get(String id);
  Future<void> put(WordDetailsEntity data);
}

class HistoryCache implements IHistoryCache {
  final completer = Completer<Box>();

  HistoryCache() {
    _initDb();
  }
  Future _initDb() async {
    var appDocDirectory = await getApplicationDocumentsDirectory();
    Hive.init(appDocDirectory.path);
    // ..registerAdapter(CacheModelAdapter());

    final box = await Hive.openBox('HistoryDetailsWord');
    if (!completer.isCompleted) completer.complete(box);
  }

  @override
  Future<void> put(WordDetailsEntity data) async {
    final box = await completer.future;
    log(jsonEncode(data.toJson()));
    await box.put(data.word, data.toJson());
  }

  @override
  Future<WordDetailsEntity?> get(String id) async {
    final box = await completer.future;
    final data = await box.get(id);

    if (data == null) return null;
    var convertStrint = (jsonEncode(data));

    return WordDetailsEntity.fromJson(jsonDecode(convertStrint));
  }
}
