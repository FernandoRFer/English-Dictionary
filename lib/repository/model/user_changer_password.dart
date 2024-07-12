class UserChangerPassword {
  String newPassord;
  String password;
  String eMail;
  UserChangerPassword({
    required this.newPassord,
    required this.password,
    required this.eMail,
  });

  factory UserChangerPassword.fromJson(Map<String, dynamic> json) {
    return UserChangerPassword(
      password: json["password"] ?? "",
      eMail: json["email"] ?? "",
      newPassord: json['newpassord'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'password': password,
      'email': eMail,
      'newpassord': newPassord,
    };
  }
}
