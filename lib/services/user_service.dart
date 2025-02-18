import 'dart:convert';
import 'package:libridex_mobile/domain/models/http_responses/api_response.dart';
import 'package:http/http.dart' as http;

class UserService {
  final String baseString = "https://libridex-api-8ym32.ondigitalocean.app/api";
  Future<ApiResponse> login(String email, String password) async {
    final endpoint = '$baseString/login';
    final response = await http.post(
      Uri.parse(endpoint),
      body: {
        'email': email,
        'password': password,
      },
    );
    return ApiResponse.fromJson(json.decode(response.body));
  }
}