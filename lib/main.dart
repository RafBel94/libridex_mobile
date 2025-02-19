import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:libridex_mobile/providers/user_provider.dart';
import 'package:libridex_mobile/screens/admin_screen.dart';
import 'package:libridex_mobile/screens/presentation_screen.dart';
import 'package:libridex_mobile/services/token_service.dart';
import 'package:libridex_mobile/services/user_service.dart';
import 'package:provider/provider.dart';
import 'package:libridex_mobile/providers/book_provider.dart';
import 'package:libridex_mobile/services/book_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserProvider(TokenService(), UserService()),
        ),
        ChangeNotifierProvider(
          create: (_) => BookProvider(BookService(TokenService())),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Libridex',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.brown),
          useMaterial3: true,
        ),
        home: const AdminScreen(),
      ),
    );
  }
}