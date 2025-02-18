import 'package:flutter/material.dart';

void loginAction(BuildContext context, String email, String password) {
  // Placeholder for login logic
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('Login attempted with email: $email')),
  );
}
