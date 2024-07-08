import 'irest_response.dart';

abstract class IRestClient {
  Future<IRestResponse> sendGet(
      {required String url,
      Map<String, String>? headers,
      String? authorization});
}
