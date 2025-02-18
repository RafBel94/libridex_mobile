// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:libridex_mobile/screens/login_screen.dart';

class PresentationScreen extends StatefulWidget {
  const PresentationScreen({super.key});

  @override
  _PresentationScreenState createState() => _PresentationScreenState();
}

class _PresentationScreenState extends State<PresentationScreen> {
  double _opacity = 0.0;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        _opacity = 1.0;
      });
    });

    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Center(
        child: SizedBox(
          height: size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedOpacity(
                opacity: _opacity,
                duration: const Duration(seconds: 2),
                child: const Text(
                  'Libridex',
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Colors.brown
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
