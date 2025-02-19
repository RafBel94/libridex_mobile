import 'package:flutter/material.dart';
import '../widgets/shared/bg_auth.dart';
import '../widgets/forms/login_form.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: const Scaffold(
        body: Stack(
          children: <Widget>[
            BgAuth(),
            Center(child: FormLogin()),
          ],
        ),
      ),
    );
  }
}
