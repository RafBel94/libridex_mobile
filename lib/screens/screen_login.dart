import 'package:flutter/material.dart';
import '../widgets/shared/bg_auth.dart';
import '../widgets/forms/form_login.dart';

class ScreenLogin extends StatelessWidget {
  const ScreenLogin({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Stack(
        children: <Widget>[
          BgAuth(),
          Center(child: FormLogin()),
        ],
      ),
    );
  }
}
