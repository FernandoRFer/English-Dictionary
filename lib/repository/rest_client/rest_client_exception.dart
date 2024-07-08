import 'dart:convert';
import 'package:english_dictionary/repository/rest_client/model/rest_error.dart';
import 'irest_response.dart';

class RestClientException implements Exception {
  final IRestResponse response;
  final String message;
  RestClientException(this.message, this.response);

  @override
  String toString() {
    RestError getMsg = RestError.fromJson(jsonDecode(response.content));
    return "${getMsg.title}\n${getMsg.message}\n${getMsg.resolution}";
  }

  // List<RestError> getErrors() {
  //   List<dynamic> data = jsonDecode(response.content);
  //   return data.map((json) => RestError.fromJson(json)).toList();
  // }

  String getMessage() {
    return RestError.fromJson(jsonDecode(response.content)).message;
  }
}
