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
    // Comprobar si los datos coinciden con el usuario registrado
    if (_user != null && _user!.email == email && _user!.password == password) {
      // Actualizar el usuario autenticado en memoria
      _user = UserModel(email: email, password: password);
      notifyListeners();
      return true;
    }
    return false;
  }

  // Método para cerrar sesión
  void logOut() {
    _user = null; // Limpiar el usuario
    notifyListeners();
  }
}
