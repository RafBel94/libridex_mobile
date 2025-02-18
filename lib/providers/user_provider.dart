import 'package:flutter/material.dart';
import 'package:libridex_mobile/domain/models/http_responses/api_response.dart';
import 'package:libridex_mobile/domain/models/user.dart';
import 'package:libridex_mobile/services/token_service.dart';
import 'package:libridex_mobile/services/user_service.dart';

class UserProvider extends ChangeNotifier{
  final UserService userService;
  final TokenService tokenService;
  User? currentUser;
  String? errorMessage;

  UserProvider(this.tokenService, this.userService);

  Future<void> loginUser(String email, String password) async {
    try {
      ApiResponse loginResponse = await userService.login(email, password);

      if (!loginResponse.data['error']) {
        currentUser = User.fromLoginJson(loginResponse.data);
        tokenService.saveToken(currentUser!.token ?? '');

        errorMessage = null;
      } else {
        errorMessage = loginResponse.data['errors'] ?? 'Login Failed';
      }
    } catch (error) {
      errorMessage = 'Error: ${error.toString()}';
    } finally {
      notifyListeners();
    }
  }
}