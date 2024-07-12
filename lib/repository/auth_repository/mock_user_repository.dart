import 'dart:convert';

import 'package:english_dictionary/repository/model/user_changer_password.dart';

import '../model/user_model.dart';
import 'iuser_repository.dart';

class MockUserRepository implements IUserRepository {
  final users = <String, UserModel>{
    "ZmVybmFuZG8=": UserModel(
      eMail: "fernando@fernando.com",
      name: 'Fernando',
      password: 'fernando',
      phoneNumber: 19981254183,
    ),
  };

  String _generateKey(String seed) => base64Encode(utf8.encode(seed));

  MockUserRepository();

  @override
  Future<String> login(
      {required String eMail, required String password}) async {
    final key = _generateKey(eMail);

    final user = users[key];

    if (user != null && user.password == password) {
      return key;
    }
    throw ("Username or password not found");
  }

  @override
  Future<void> register(UserModel user) async {
    final newUser = _generateKey(user.eMail);

    final key = _generateKey(newUser.toString());

    if (users.containsKey(key)) {
      return;
    }
    users[key] = user;
  }

  @override
  String? changePassword(UserChangerPassword userUpdate) {
    final key = _generateKey(userUpdate.eMail);
    final user = users[key];

    if (user != null && user.password == userUpdate.password) {
      users.remove(key);
      users[key]!.password = userUpdate.password;
      final keyUpdate = _generateKey(userUpdate.eMail);

      users[keyUpdate] = UserModel(
          name: user.name,
          password: userUpdate.newPassord,
          phoneNumber: user.phoneNumber,
          eMail: user.eMail);
    }

    return null;
  }
}
