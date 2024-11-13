import 'package:habit_app/domain/models/user_model.dart';
import 'package:habit_app/data/datasource/datasource_hive.dart' as hive;

// Interface
abstract class AuthRepository {
  Future<bool> login(String email, String password);
  Future<void> signup(UserModel user);
  Future<void> updateUserProgress(UserModel user);
  Future<void> setCurrentUser(UserModel user);
  UserModel? getCurrentUser();
  Future<void> clearCurrentUser();
}

// Implementation
class AuthRepositoryImpl implements AuthRepository {
  @override
  Future<bool> login(String email, String password) async {
    return await hive.login(email, password);
  }

  @override
  Future<void> signup(UserModel user) async {
    await hive.signup(user);
  }

  @override
  Future<void> updateUserProgress(UserModel user) async {
    await hive.updateUserProgress(user);
  }

  @override
  Future<void> setCurrentUser(UserModel user) async {
    await hive.setCurrentUser(user);
  }

  @override
  UserModel? getCurrentUser() {
    return hive.getCurrentUser();
  }

  @override
  Future<void> clearCurrentUser() async {
    await hive.clearCurrentUser();
  }
}
