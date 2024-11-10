import '/models/user_model.dart';
import 'package:get/get.dart';
import 'user_controller.dart';
import 'package:hive/hive.dart';
import 'package:habit_app/UI/controller/habit_controller.dart';
import 'package:habit_app/UI/controller/category_controller.dart';

class AuthController extends GetxController {
  late Box<UserModel> userBox;
  UserModel? _user;
  UserModel? get user => _user;

  final UserController userController = Get.find<UserController>();

  @override
  void onInit() {
    super.onInit();
    _openUserBox();
  }

  Future<void> _openUserBox() async {
    try {
      userBox = await Hive.openBox<UserModel>('userBox');
      if (userBox.isNotEmpty) {
        _user = userBox.get('currentUser');
        update();
      }
    } catch (e) {
      print('Error al abrir la caja de usuarios: $e');
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

      await userBox.put(email.trim().toLowerCase(), _user!);

      print('Usuario registrado: ${_user?.email}');
      print('Usuarios en Hive: ${userBox.length}');
      print('¿userBox está vacío?: ${userBox.isEmpty}');
      print('Usuario almacenado: ${userBox.get(email.trim().toLowerCase())?.email}');

      userController.experience.value = 0;
      userController.level.value = 1;
      update();
    } catch (e) {
      print('Error al guardar usuario: $e');
    }
  }

  Future<bool> logIn(String email, String password) async {
    try {
      print('Estado inicial del box:');
      print('Box está vacío: ${userBox.isEmpty}');
      print('Número de usuarios: ${userBox.length}');

      final storedUser = userBox.get(email.trim().toLowerCase());

      if (storedUser == null) {
        print('No hay usuarios registrados con ese email');
        return false;
      }

      print('Datos de login - Email: $email, Password: $password');
      print('Usuario almacenado - Email: ${storedUser.email}, Password: ${storedUser.password}');

      bool emailMatches = storedUser.email.trim().toLowerCase() == email.trim().toLowerCase();
      bool passwordMatches = storedUser.password == password;

      print('Email coincide: $emailMatches');
      print('Password coincide: $passwordMatches');

      if (emailMatches && passwordMatches) {
        _user = storedUser;
        userController.experience.value = storedUser.experience;
        userController.level.value = storedUser.level;
        userController.setCurrentUserEmail(email.trim().toLowerCase());
        userController.setAuthController(this);  // Nuevo: pasar referencia del AuthController

        // Recargar datos específicos del usuario
        await Get.find<HabitController>().reloadHabits();
        await Get.find<CategoryController>().reloadCategories();

        print('Login exitoso - Exp: ${userController.experience.value}, Level: ${userController.level.value}');

        update();
        return true;
      }

      print('Error: Credenciales no coinciden');
      return false;
    } catch (e) {
      print('Error en login: $e');
      return false;
    }
  }

  Future<void> logOut() async {
    try {
      print('Iniciando cierre de sesión...');
      print('Usuario actual: ${_user?.email}');
      print('Experiencia actual: ${userController.experience.value}');
      print('Nivel actual: ${userController.level.value}');

      _user = null;
      userController.experience.value = 0;
      userController.level.value = 1;
      userController.setCurrentUserEmail('');

      // Limpiar datos del usuario actual
      await Get.find<HabitController>().reloadHabits();
      await Get.find<CategoryController>().reloadCategories();

      print('Usuario después de logout: ${_user?.email}');
      print('Experiencia después de logout: ${userController.experience.value}');
      print('Nivel después de logout: ${userController.level.value}');

      update();
      print('Actualización completada, antes de la navegación');

      // Simplificar la navegación para ver si el problema persiste
      try {
        Get.offAllNamed('/welcome');
        print('Cierre de sesión completado y navegación a /welcome');
      } catch (e) {
        print('Error durante el cierre de sesión: $e');
      }
    } catch (e) {
      print('Error durante el cierre de sesión: $e');
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
      userBox.put(_user!.email, _user!);
    }
  }
}
