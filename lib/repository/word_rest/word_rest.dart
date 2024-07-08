import 'dart:convert';
import 'dart:developer';

import 'package:english_dictionary/repository/rest_client/irest_client.dart';
import 'package:english_dictionary/repository/model/word_details_entity.dart';

abstract class IWordRepository {
  Future<WordDetailsEntity> getWord(String word);
}

class WordRepository implements IWordRepository {
  final IRestClient _restClient;

  WordRepository(
    this._restClient,
  );

  static String url = "https://api.dictionaryapi.dev/api/v2/entries/en";

  @override
  Future<WordDetailsEntity> getWord(String word) async {
    var resp = await _restClient.sendGet(
      url: "$url/$word",
    );
    resp.ensureSuccess(restClientExceptionMessage: "Ocorreu um erro");
    List<dynamic> list = jsonDecode(resp.content);
    var result = list.map((e) => WordDetailsEntity.fromJson(e)).toList();
    return result[0];
  }
}
