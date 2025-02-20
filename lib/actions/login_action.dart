// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:libridex_mobile/providers/user_provider.dart';
import 'package:libridex_mobile/screens/catalog_screen.dart';
import 'package:libridex_mobile/screens/user_home_screen.dart';
import 'package:provider/provider.dart';

void loginAction(BuildContext context, String email, String password) async {
  final userProvider = context.read<UserProvider>();

  await userProvider.loginUser(email, password);
  final user = userProvider.currentUser!;

  if (userProvider.errorMessage != null) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(userProvider.errorMessage!)),
    );
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Successfully logged in!')),
    );

    if (user.role! == 'ROLE_USER') {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const UserHomeScreen()));
    } else if (user.role! == 'ROLE_ADMIN') {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const CatalogScreen()));
    }
  }
}
