import 'dart:typed_data';
import 'irest_response.dart';
import 'rest_client_exception.dart';

class RestResponse extends IRestResponse {
  final int _statusCode;
  final String _content;
  final Uint8List _contentBytes;
  final String _url;

  RestResponse(
      {required int statusCode,
      required String content,
      required Uint8List contentBytes,
      required String url})
      : _statusCode = statusCode,
        _content = content,
        _contentBytes = contentBytes,
        _url = url;

  @override
  String get content => _content;

  @override
  int get statusCode => _statusCode;

  @override
  Uint8List get contentBytes => _contentBytes;

  @override
  String get url => _url;

  @override
  void ensureSuccess(
      {Function()? customErrorMessage,
      required String restClientExceptionMessage}) {
    if (statusCode == 200) {
      return;
    } else if (statusCode == 404) {
      throw RestClientException("Not found", this);
    } else {
      throw RestClientException("Ocorreu um erro na requisição", this);
    }
  }
}

// extension ResponseExtension on IRestResponse {
//   void ensureSuccess(
//       {Function()? customErrorMessage,
//       required String restClientExceptionMessage}) {
//     if (statusCode == 200) {
//       return;
//     } else if (unauthorized) {
//       throw RestClientException("Sem permissão.", this);
//     } else if (statusCode == 404) {
//       throw RestClientException("Not found", this);
//     } else {
//       throw RestClientException("Ocorreu um erro na requisição", this);
//     }
//   }
// }
