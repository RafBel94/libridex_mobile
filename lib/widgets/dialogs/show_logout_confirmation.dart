// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:libridex_mobile/providers/user_provider.dart';
import 'package:libridex_mobile/screens/login_screen.dart';
import 'package:provider/provider.dart';

void showLogoutConfirmation(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Logout'),
        content: const Text('Do you really want to logout?'),
        actions: [
          TextButton(
            onPressed: () async {
              await context.read<UserProvider>().logoutUser();
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const LoginScreen()));
            },
            child: const Text('Yes'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('No'),
          ),
        ],
      );
    },
  );
}
