import 'package:get/get.dart';

class UserController extends GetxController {
  var experience = 0.obs;
  var level = 1.obs;

  void addExperience(int points) {
    experience.value += points;
    _checkLevelUp();
  }

  void subtractExperience(int points) {
    experience.value -= points;
    if (experience.value < 0) {
      experience.value = 0;
    }
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
