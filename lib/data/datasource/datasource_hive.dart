import 'package:hive/hive.dart';
import 'package:habit_app/domain/models/user_model.dart';
import 'package:habit_app/domain/models/habit_model.dart';
import 'package:habit_app/domain/models/category_model.dart';
import 'package:habit_app/domain/repositories/category_repository.dart';

// User CRUD operations
Future<void> openUserBox() async {
  await Hive.openBox<UserModel>('userBox');
}

Future<void> putUser(UserModel user) async {
  var userBox = Hive.box<UserModel>('userBox');
  await userBox.put(user.email, user);
}

UserModel? getUser(String email) {
  var userBox = Hive.box<UserModel>('userBox');
  return userBox.get(email);
}

Future<void> deleteUser(String email) async {
  var userBox = Hive.box<UserModel>('userBox');
  await userBox.delete(email);
}

// Authentication operations
Future<bool> login(String email, String password) async {
  print('Hive: Intentando login para ${email}');
  var userBox = Hive.box<UserModel>('userBox');
  final storedUser = userBox.get(email.trim().toLowerCase());
  
  if (storedUser == null) {
    print('Hive: Usuario no encontrado');
    return false;
  }
  
  if (storedUser.email.trim().toLowerCase() == email.trim().toLowerCase() &&
      storedUser.password == password) {
    print('Hive: Credenciales correctas, estableciendo sesión actual');
    await setCurrentUser(storedUser);
    return true;
  }
  
  print('Hive: Credenciales incorrectas');
  return false;
}

Future<void> signup(UserModel user) async {
  var userBox = Hive.box<UserModel>('userBox');
  await userBox.put(user.email.trim().toLowerCase(), user);
}

Future<void> updateUserProgress(UserModel user) async {
  print('Hive: Actualizando progreso para ${user.email}');
  var userBox = Hive.box<UserModel>('userBox');
  
  // Actualizar tanto el usuario almacenado como la sesión actual
  await userBox.put(user.email.trim().toLowerCase(), user);
  await userBox.put('currentUser', user);
  
  print('Hive: Progreso actualizado para usuario y sesión actual');
}

Future<void> setCurrentUser(UserModel user) async {
  var userBox = Hive.box<UserModel>('userBox');
  await userBox.put('currentUser', user);
}

UserModel? getCurrentUser() {
  var userBox = Hive.box<UserModel>('userBox');
  return userBox.get('currentUser');
}

Future<void> clearCurrentUser() async {
  print('Hive: Limpiando solo la sesión actual');
  var userBox = Hive.box<UserModel>('userBox');
  await userBox.delete('currentUser');
  print('Hive: Sesión actual limpiada, usuario permanece en la base de datos');
}

// Habit CRUD operations
Future<Box<Habit>> openHabitBox(String email) async {
  return await Hive.openBox<Habit>('habitBox_$email');
}

Future<void> putHabit(String email, Habit habit) async {
  var habitBox = await openHabitBox(email);
  await habitBox.put(habit.id, habit);
}

List<Habit> getHabits(String email) {
  var habitBox = Hive.box<Habit>('habitBox_$email');
  return habitBox.values.toList();
}

Future<void> deleteHabit(String email, String habitId) async {
  var habitBox = await openHabitBox(email);
  await habitBox.delete(habitId);
}

// Category CRUD operations
Future<Box<CategoryModel>> openCategoryBox(String email) async {
  return await Hive.openBox<CategoryModel>('categoryBox_$email');
}

Future<void> putCategory(String email, CategoryModel category) async {
  var categoryBox = await openCategoryBox(email);
  await categoryBox.put(category.name, category);
}

List<CategoryModel> getCategories(String email) {
  var categoryBox = Hive.box<CategoryModel>('categoryBox_$email');
  return categoryBox.values.toList();
}

Future<void> deleteCategory(String email, String categoryName) async {
  var categoryBox = await openCategoryBox(email);
  await categoryBox.delete(categoryName);
}
