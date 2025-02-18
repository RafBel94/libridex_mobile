import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:libridex_mobile/providers/user_provider.dart';
import 'package:libridex_mobile/services/token_service.dart';
import 'package:libridex_mobile/services/user_service.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserProvider(TokenService(), UserService()),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Libridex',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.brown),
          useMaterial3: true,
        ),
        home: const LoginScreen(),
      ),
    );
  }
}