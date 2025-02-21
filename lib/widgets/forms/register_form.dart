// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:libridex_mobile/actions/action_register.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _rePasswordController = TextEditingController();

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
            const Text(
              'Register Form',
              style: TextStyle(color: Colors.white, fontSize: 40, fontWeight: FontWeight.w400, overflow: TextOverflow.ellipsis),
            ),
            Container(
              width: size.width,
              margin: const EdgeInsets.only(top: 40, left: 20, right: 20),
              padding: const EdgeInsets.only(left: 8, right: 8, bottom: 25),
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
                child: RegisterFormContainer(formKey: _formKey, emailController: _emailController, passwordController: _passwordController, rePasswordController: _rePasswordController),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RegisterFormContainer extends StatefulWidget {
  const RegisterFormContainer({
    super.key,
    required GlobalKey<FormState> formKey,
    required TextEditingController emailController,
    required TextEditingController passwordController,
    required TextEditingController rePasswordController,
  })  : _formKey = formKey,
        _emailController = emailController,
        _passwordController = passwordController,
        _rePasswordController = rePasswordController;

  final GlobalKey<FormState> _formKey;
  final TextEditingController _emailController;
  final TextEditingController _passwordController;
  final TextEditingController _rePasswordController;

  @override
  State<RegisterFormContainer> createState() => _RegisterFormContainerState();
}

class _RegisterFormContainerState extends State<RegisterFormContainer> {
  bool _obscurePasswordText = true;
  bool _obscureRePasswordText = true;
  bool _isPasswordFieldFocused = false;
  bool _isRePasswordFieldFocused = false;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget._formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const SizedBox(height: 50),

          const Icon(
            Icons.account_circle,
            size: 120,
            color: Color.fromARGB(255, 101, 101, 101),
          ),

          const SizedBox(height: 30),

          // Email field
          TextFormField(
            controller: widget._emailController,
            decoration: const InputDecoration(labelText: 'Email'),
            keyboardType: TextInputType.emailAddress,
            onTapOutside: (event) => FocusScope.of(context).unfocus(),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your email';
              }
              if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                return 'Please enter a valid email address';
              }
              return null;
            },
          ),

          const SizedBox(height: 20),

          // Password field
          Focus(
            onFocusChange: (hasFocus) {
              setState(() {
                _isPasswordFieldFocused = hasFocus;
              });
            },
            child: TextFormField(
              controller: widget._passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
                suffixIcon: _isPasswordFieldFocused
                    ? IconButton(
                        icon: Icon(
                          _obscurePasswordText ? Icons.visibility : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePasswordText = !_obscurePasswordText;
                          });
                        },
                      )
                    : null,
              ),
              onTapOutside: (event) => FocusScope.of(context).unfocus(),
              obscureText: _obscurePasswordText,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your password';
                }
                if (value.length < 6) {
                  return 'Password must be at least 6 characters long';
                }
                return null;
              },
            ),
          ),

          const SizedBox(height: 20),

          // Repeat password field
          Focus(
            onFocusChange: (hasFocus) {
              setState(() {
                _isRePasswordFieldFocused = hasFocus;
              });
            },
            child: TextFormField(
              controller: widget._rePasswordController,
              decoration: InputDecoration(
                labelText: 'Repeat password',
                suffixIcon: _isRePasswordFieldFocused
                    ? IconButton(
                        icon: Icon(
                          _obscureRePasswordText ? Icons.visibility : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureRePasswordText = !_obscureRePasswordText;
                          });
                        },
                      )
                    : null,
              ),
              onTapOutside: (event) => FocusScope.of(context).unfocus(),
              obscureText: _obscureRePasswordText,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please repeat your password';
                }
                if (value != widget._passwordController.text) {
                  return 'Passwords do not match';
                }
                return null;
              },
            ),
          ),

          const SizedBox(height: 60),

          // Buttons row
          Row(
            children: [
              SizedBox(width: MediaQuery.of(context).size.width * 0.035),

              // Return button
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 113, 77, 63),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  'Return',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),

              SizedBox(width: MediaQuery.of(context).size.width * 0.1),

              // Submit button
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 113, 77, 63),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  if (widget._formKey.currentState!.validate()) {
                    registerAction(context, widget._emailController.text, widget._passwordController.text, widget._rePasswordController.text);
                  }
                },
                child: const Text(
                  'Submit',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
