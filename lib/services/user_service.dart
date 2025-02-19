import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:libridex_mobile/domain/models/http_responses/auth_response.dart';

class UserService {
  final String baseString = "https://libridex-api-8ym32.ondigitalocean.app/api/auth";

  // Login endpoint
  Future<AuthResponse> login(String email, String password) async {
    final endpoint = '$baseString/login';
    final response = await http.post(
      Uri.parse(endpoint),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );
    return AuthResponse.fromJson(json.decode(response.body));
  }

  // Register endpoint
  Future<AuthResponse> register(String email, String password, String repeatPassword) async {
    final endpoint = '$baseString/register';
    final response = await http.post(
      Uri.parse(endpoint),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'email': email,
        'password': password,
        'repeatPassword': repeatPassword,
      }),
    );
    return AuthResponse.fromJson(json.decode(response.body));
  }
}