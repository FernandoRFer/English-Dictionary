import 'package:english_dictionary/repository/model/user_changer_password.dart';

import '../model/user_model.dart';

abstract class IUserRepository {
  Future<String> login({required String eMail, required String password});
  Future<void> register(UserModel user);
  String? changePassword(UserChangerPassword userUpdate);
}
