import 'package:get/get.dart';
import 'package:habit_app/domain/models/user_model.dart';
import 'package:habit_app/domain/use_case/user_use_case.dart';
import 'auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:habit_app/UI/widgets/level_up_dialog.dart';

class UserController extends GetxController {
  var experience = 0.obs;
  var level = 1.obs;
  var currentUserEmail = ''.obs;
  AuthController? _authController;
  final UserUseCase _userUseCase;

  UserController(this._userUseCase);

  @override
  void onInit() {
    super.onInit();
    _loadUserData();
  }

  void _loadUserData() {
    if (currentUserEmail.value.isNotEmpty) {
      final user = _userUseCase.getUser(currentUserEmail.value);
      if (user != null) {
        experience.value = user.experience;
        level.value = user.level;
      }
    }
  }

  void setCurrentUserEmail(String email) {
    currentUserEmail.value = email;
    _loadUserData();
  }

  void setAuthController(AuthController controller) {
    _authController = controller;
  }

  void addExperience(int points) {
    experience.value += points;
    _checkLevelUp();
    _updateUserData();
  }

  void subtractExperience(int points) {
    experience.value -= points;
    if (experience.value < 0) {
      experience.value = 0;
    }
    _updateUserData();
  }

  void _checkLevelUp() {
    int requiredExperience = level.value * 100;
    while (experience.value >= requiredExperience) {
      experience.value -= requiredExperience;
      level.value++;
      requiredExperience = level.value * 100;
      _authController?.updateUserProgress();
      
      // Mostrar el diálogo de nivel usando Get.dialog
      Get.dialog(
        LevelUpDialog(level: level.value),
        barrierDismissible: false,
      );
    }
  }

  void _updateUserData() {
    if (currentUserEmail.value.isNotEmpty) {
      final currentUser = _userUseCase.getUser(currentUserEmail.value);
      if (currentUser != null) {
        final user = UserModel(
          email: currentUserEmail.value,
          password: currentUser.password, // Mantener la contraseña existente
          experience: experience.value,
          level: level.value,
        );
        _userUseCase.updateUser(user);
      }
    }
  }
}
