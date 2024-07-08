import 'dart:convert';

import 'package:english_dictionary/repository/model/word_model.dart';
import 'package:flutter/services.dart';

abstract class IWordListFile {
  Future<List<WordModel>> get wordList;
}

class WordListFile implements IWordListFile {
  List<WordModel>? _wordList;

  @override
  Future<List<WordModel>> get wordList async {
    _wordList ??= await _initList();
    return _wordList ?? [];
  }

  Future<List<WordModel>> _initList() async {
    List<WordModel> provisorList = [];
    List<String> words = [];
    final String jsonString =
        await rootBundle.loadString('assets/words_dictionary.json');
    final Map<dynamic, dynamic> data = jsonDecode(jsonString);

    data.forEach((key, value) {
      words.add(capitalize1Word(key));
    });

    for (var i = 0; i < data.length; i++) {
      provisorList.add(WordModel(id: i, word: words[i]));
    }
    return provisorList;
  }

  String capitalize1Word(String value) {
    if (value.trim().isEmpty) return "";
    return "${value[0].toUpperCase()}${value.substring(1).toLowerCase()}";
  }
}
