// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:libridex_mobile/providers/user_provider.dart';
import 'package:provider/provider.dart';

void registerAction(BuildContext context, String email, String password, String repeatPassword) async {
  final userProvider = context.read<UserProvider>();

  await userProvider.registerUser(email, password, repeatPassword);

  if (userProvider.errorMessage != null) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(userProvider.errorMessage!)),
    );
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Registered successfully!')),
    );
    Navigator.pop(context);
  }
}
