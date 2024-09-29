// lib/controller/auth_controller.dart
import 'package:flutter/material.dart';
import '/models/user_model.dart';

class AuthController extends ChangeNotifier {
  UserModel? _user; // Usuario en memoria

  UserModel? get user => _user;

  // Método para registrar el usuario
  void signUp(String email, String password) {
    _user = UserModel(email: email, password: password);
    notifyListeners(); // Notifica los cambios
  }

  // Método para iniciar sesión
  bool logIn(String email, String password) {
    if (_user != null && _user!.email == email && _user!.password == password) {
      return true;
    }
    return false;
  }
}
