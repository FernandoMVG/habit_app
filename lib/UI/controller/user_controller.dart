import 'package:get/get.dart';

class UserController extends GetxController {
  var experience = 0.obs;
  var level = 1.obs;

  void addExperience(int points) {
    experience.value += points;
    _checkLevelUp();
  }

  void _checkLevelUp() {
    int requiredExperience = level.value * 100;
    while (experience.value >= requiredExperience) {
      experience.value -= requiredExperience;
      level.value++;
      requiredExperience = level.value * 100;
    }
  }
}
