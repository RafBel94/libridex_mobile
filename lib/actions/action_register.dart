import 'package:flutter/material.dart';

void registerAction(BuildContext context, String email, String password, String repeatPassword) {
  // Placeholder for login logic
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('Login attempted with email: $email')),
  );
}
