import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:libridex_mobile/providers/user_provider.dart';

void loginAction(BuildContext context, String email, String password) async {
  final userProvider = Provider.of<UserProvider>(context, listen: false);

  await userProvider.loginUser(email, password);

  if (userProvider.errorMessage != null) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(userProvider.errorMessage!)),
    );
  } else {
    Navigator.pushReplacementNamed(context, '/home');
  }
}
