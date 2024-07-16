import 'package:english_dictionary/repository/model/user_changer_password.dart';
import '../model/user_model.dart';
import '../rest_client/irest_client.dart';
import 'iuser_repository.dart';

class UserRepository implements IUserRepository {
  final IRestClient _restClient;

  UserRepository(
    this._restClient,
  );

  static String url = "http://localhost:8080";

  @override
  Future<String> login(
      {required String eMail, required String password}) async {
    var resp = await _restClient.sendPost(
      url: "$url/login",
      headers: {'Content-Type': 'application/json'},
      body: {"email": eMail, "password": password},
    );

    if (resp.statusCode == 403) {
      throw Exception("Usuário ou senha inválido");
    }

    resp.ensureSuccess(
      restClientExceptionMessage: "Erro ao fazer login",
    );

    return resp.content;
  }

  @override
  Future<String> register(UserModel user) async {
    var resp = await _restClient.sendPost(
      url: "$url/login",
      body: user.toJson(),
    );

    resp.ensureSuccess(restClientExceptionMessage: "Ocorreu um erro");

    return resp.content;
  }

  @override
  String? changePassword(UserChangerPassword userUpdate) {
    return null;
  }
}
