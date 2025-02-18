import 'package:flutter/material.dart';
import '../widgets/shared/bg_auth.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Stack(
        children: <Widget>[
          // Background image
          BgAuth(),
          Center(child: Text('Hello')),
        ],
      ),
    );
  }
}
