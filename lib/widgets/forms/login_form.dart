import 'package:flutter/material.dart';
import 'package:libridex_mobile/actions/login_action.dart';
import 'package:libridex_mobile/screens/register_screen.dart';

class FormLogin extends StatefulWidget {
  const FormLogin({super.key});

  @override
  _FormLoginState createState() => _FormLoginState();
}

class _FormLoginState extends State<FormLogin> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _obscureText = true;
  bool _isPasswordFieldFocused = false;

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter an email';
    }
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Center(
        child: SizedBox(
            height: size.height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: size.width,
                  margin: const EdgeInsets.only(top: 40, left: 20, right: 20),
                  padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                  decoration: BoxDecoration(
                    border: const Border(
                      top: BorderSide(width: 5, color: Colors.brown),
                      bottom: BorderSide(width: 5, color: Colors.brown),
                    ),
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: size.width * 0.15),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          const SizedBox(height: 50),
                          const Text("Libridex", style: TextStyle(fontSize: 55, color: Colors.brown)),
                          const SizedBox(height: 40),
                          TextFormField(
                            controller: _emailController,
                            decoration: const InputDecoration(labelText: 'Email'),
                            validator: _validateEmail,
                          ),
                          const SizedBox(height: 20),
                          Focus(
                            onFocusChange: (hasFocus) {
                              setState(() {
                                _isPasswordFieldFocused = hasFocus;
                              });
                            },
                            child: TextFormField(
                              controller: _passwordController,
                              decoration: InputDecoration(
                                labelText: 'Password',
                                suffixIcon: _isPasswordFieldFocused
                                    ? IconButton(
                                        icon: Icon(
                                          _obscureText ? Icons.visibility : Icons.visibility_off,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            _obscureText = !_obscureText;
                                          });
                                        },
                                      )
                                    : null,
                              ),
                              obscureText: _obscureText,
                            ),
                          ),
                          const SizedBox(height: 50),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 8),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onPressed: () {
                              if (_formKey.currentState?.validate() ?? false) {
                                loginAction(context, _emailController.text, _passwordController.text);
                              }
                            },
                            child: const Text(
                              'Login',
                              style: TextStyle(
                                fontSize: 20,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 50,
                          ),
                          const Text("Don't have an account?"),
                          const SizedBox(
                            height: 10,
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color.fromARGB(255, 113, 77, 63),
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(builder: (context) => const RegisterScreen()),
                              );
                            },
                            child: const Text(
                              'Register',
                              style: TextStyle(fontSize: 16, color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            )));
  }
}
