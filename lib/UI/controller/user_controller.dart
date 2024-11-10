import 'package:get/get.dart';
import 'package:habit_app/models/user_model.dart';
import 'package:hive/hive.dart';
import 'auth_controller.dart';


class UserController extends GetxController {
  var experience = 0.obs;
  var level = 1.obs;
  late Box<UserModel> userBox;
  var currentUserEmail = ''.obs;
  AuthController? _authController;  // Nueva variable

  @override
  void onInit() {
    super.onInit();
    userBox = Hive.box<UserModel>('userBox');
  }

  void setCurrentUserEmail(String email) {
    currentUserEmail.value = email;
  }

  void setAuthController(AuthController controller) {
    _authController = controller;
  }

  void addExperience(int points) {
    experience.value += points;
    _checkLevelUp();
    _authController?.updateUserProgress();  // Actualizar en Hive
  }

  void subtractExperience(int points) {
    experience.value -= points;
    if (experience.value < 0) {
      experience.value = 0;
    }
    _authController?.updateUserProgress();  // Actualizar en Hive
  }

  void _checkLevelUp() {
    int requiredExperience = level.value * 100;
    while (experience.value >= requiredExperience) {
      experience.value -= requiredExperience;
      level.value++;
      requiredExperience = level.value * 100;
      _authController?.updateUserProgress();  // Actualizar en Hive cuando sube de nivel
    }
  }
}
