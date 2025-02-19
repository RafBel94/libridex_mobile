import 'package:flutter/material.dart';
import 'package:libridex_mobile/domain/models/http_responses/auth_response.dart';
import 'package:libridex_mobile/domain/models/user.dart';
import 'package:libridex_mobile/services/token_service.dart';
import 'package:libridex_mobile/services/user_service.dart';

class UserProvider extends ChangeNotifier{
  final UserService userService;
  final TokenService tokenService;
  User? currentUser;
  String? errorMessage;

  UserProvider(this.tokenService, this.userService);

  // Login user
  Future<void> loginUser(String email, String password) async {
    try {
      AuthResponse loginResponse = await userService.login(email, password);
      if (loginResponse.success) {
        currentUser = User.fromLoginJson(loginResponse.data);
        tokenService.saveToken(currentUser!.token ?? '');

        errorMessage = null;
      } else {
        errorMessage = loginResponse.message[0];
      }
    } catch (error) {
      errorMessage = 'Error: ${error.toString()}';
    } finally {
      notifyListeners();
    }
  }

  // Register user
  Future<void> registerUser(String email, String password, String repeatPassword) async {
    try {
      AuthResponse loginResponse = await userService.register(email, password, repeatPassword);
      
      if (loginResponse.success) {
        currentUser = User.fromLoginJson(loginResponse.data);
        tokenService.saveToken(currentUser!.token ?? '');

        errorMessage = null;
      } else {
        errorMessage = loginResponse.message[0];
      }
    } catch (error) {
      errorMessage = 'Error: ${error.toString()}';
    } finally {
      notifyListeners();
    }
  }
}