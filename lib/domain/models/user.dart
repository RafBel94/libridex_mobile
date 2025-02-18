class User {
  String email;
  String? password;
  String? repeatPassword;
  String? token;

  User({
    required this.email,
    this.password,
    this.repeatPassword,
    this.token,
  });

  //Add factories here

  factory User.fromLoginJson(Map<String, dynamic> json) {
    return User(
      email: json['email'],
      token: json['token'],
    );
  }
}
