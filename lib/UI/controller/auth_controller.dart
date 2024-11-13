import '../../domain/models/user_model.dart';
import '../../domain/use_case/auth_use_case.dart';
import 'package:get/get.dart';
import 'user_controller.dart';
import 'package:habit_app/UI/controller/habit_controller.dart';
import 'package:habit_app/UI/controller/category_controller.dart';

class AuthController extends GetxController {
  final AuthUseCase _authUseCase;
  UserModel? _user;
  UserModel? get user => _user;

  final UserController userController = Get.find<UserController>();

  AuthController(this._authUseCase);

  @override
  void onInit() {
    super.onInit();
    _loadCurrentUser();
  }

  void _loadCurrentUser() {
    _user = _authUseCase.getCurrentUser();
    if (_user != null) {
      update();
    }
  }

  Future<void> signUp(String email, String password) async {
    try {
      _user = UserModel(
        email: email.trim().toLowerCase(),
        password: password,
        experience: 0,
        level: 1,
      );

      await _authUseCase.signup(_user!);
      await _authUseCase.setCurrentUser(_user!);

      userController.experience.value = 0;
      userController.level.value = 1;
      update();
    } catch (e) {
      print('Error al guardar usuario: $e');
    }
  }

  Future<bool> logIn(String email, String password) async {
    try {
      print('=== INICIANDO LOGIN ===');
      final success = await _authUseCase.login(email, password);
      
      if (success) {
        _user = _authUseCase.getCurrentUser();
        if (_user != null) {
          print('Login exitoso para: ${_user!.email}');
          print('Experiencia: ${_user!.experience}, Nivel: ${_user!.level}');
          
          userController.experience.value = _user!.experience;
          userController.level.value = _user!.level;
          userController.setCurrentUserEmail(email.trim().toLowerCase());
          userController.setAuthController(this);

          await Get.find<HabitController>().reloadHabits();
          await Get.find<CategoryController>().reloadCategories();

          update();
          return true;
        }
      }
      print('Login fallido');
      return false;
    } catch (e) {
      print('Error en login: $e');
      return false;
    }
  }

  Future<void> logOut() async {
    try {
      print('=== INICIANDO LOGOUT ===');
      
      // Actualizar progreso antes de cerrar sesión
      if (_user != null) {
        print('Guardando progreso final para: ${_user!.email}');
        updateUserProgress();
      }

      // Solo limpiar la sesión actual
      await _authUseCase.clearCurrentUser();
      
      // Limpiar estado local
      _user = null;
      userController.experience.value = 0;
      userController.level.value = 1;
      userController.setCurrentUserEmail('');

      // Limpiar datos en memoria
      await Get.find<HabitController>().reloadHabits();
      await Get.find<CategoryController>().reloadCategories();

      update();
      print('=== LOGOUT COMPLETADO ===');

      Get.offAllNamed('/welcome');
    } catch (e) {
      print('ERROR durante el cierre de sesión: $e');
    }
  }

  void updateUserProgress() {
    if (_user != null) {
      _user = UserModel(
        email: _user!.email,
        password: _user!.password,
        experience: userController.experience.value,
        level: userController.level.value,
      );
      _authUseCase.updateUserProgress(_user!);
    }
  }
}
