class User {
  String email;
  String? password;
  String? repeatPassword;
  String? token;
  String? role;

  User({
    required this.email,
    this.password,
    this.repeatPassword,
    this.token,
    this.role,
  });

  //Factories

  factory User.fromLoginJson(Map<String, dynamic> json) {
    return User(
      email: json['email'],
      role: json['role'],
      token: json['token'],
    );
  }
}
