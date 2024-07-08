import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:english_dictionary/repository/rest_client/irest_client.dart';
import 'package:english_dictionary/repository/rest_client/irest_response.dart';
import 'package:english_dictionary/repository/rest_client/rest_response.dart';
import 'package:http/http.dart' as http;

class RestClient implements IRestClient {
  final int secondsTimeout = 20;

  @override
  Future<IRestResponse> sendGet(
      {required String url,
      Map<String, String>? headers,
      String? authorization}) async {
    http.Request request = http.Request('GET', Uri.parse(url));

    request.headers.addAll(headers ?? {});

    http.StreamedResponse response =
        await request.send().timeout(Duration(seconds: secondsTimeout));

    Uint8List bytes = await response.stream.toBytes();

    return RestResponse(
        url: url,
        statusCode: response.statusCode,
        content: utf8.decode(bytes),
        contentBytes: bytes);
  }
}
