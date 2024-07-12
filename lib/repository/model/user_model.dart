class UserModel {
  String? id;
  String name;
  String password;
  int phoneNumber;
  String eMail;

  UserModel({
    this.id,
    required this.name,
    required this.password,
    required this.phoneNumber,
    required this.eMail,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json["id"] ?? "",
      name: json["name"] ?? "",
      password: json["password"] ?? "",
      eMail: json["email"] ?? "",
      phoneNumber: json["phonenumber"] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'password': password,
      'email': eMail,
      'phonenumer': phoneNumber
    };
  }

  // factory UserModel.fromMap(Map<String, dynamic> map) {
  //   return UserModel(
  //     id: map['Id'],
  //     usuario: map['Usuario'],
  //     senha: map['Senha'],
  //   );
  // }

  // Map<String, dynamic> toMap() {
  //   return {
  //     'Usuario': usuario,
  //     'Senha': senha,
  //   };
  // }
}
