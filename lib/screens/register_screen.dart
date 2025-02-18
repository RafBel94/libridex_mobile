import 'package:flutter/material.dart';
import 'package:libridex_mobile/widgets/forms/register_form.dart';
import '../widgets/shared/bg_auth.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: <Widget>[
            BgAuth(),
            RegisterForm(),
          ],
        ),
      ),
    );
  }
}
