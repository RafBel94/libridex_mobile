import 'package:flutter/material.dart';
import 'package:libridex_mobile/actions/action_register.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _rePasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Center(
      child: Container(
        width: size.width,
        padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: size.width * 0.15),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[

              const SizedBox(height: 50),

              const Icon(Icons.account_circle, size: 100),

              const SizedBox(height: 20),

              TextField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
              ),

              const SizedBox(height: 20),

              TextField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
              ),

              TextField(
                controller: _rePasswordController,
                decoration: const InputDecoration(labelText: 'Repeat password'),
                obscureText: true,
              ),

              const SizedBox(height: 40),

              ElevatedButton(
                onPressed: () => registerAction(context, _emailController.text, _passwordController.text, _rePasswordController.text),
                child: const Text('Submit', style: TextStyle(
                  fontSize: 16,
                ),),
              ),

              const SizedBox(height: 20,)
            ],
          ),
        ),
      ),
    );
  }
}
