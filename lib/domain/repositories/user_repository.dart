import 'package:habit_app/domain/models/user_model.dart';
import 'package:habit_app/data/datasource/datasource_hive.dart' as datasource;

abstract class UserRepository {
  Future<void> createUser(UserModel user);
  UserModel? getUser(String email);
  Future<void> deleteUser(String email);
  Future<void> updateUser(UserModel user);
}

class UserRepositoryImpl implements UserRepository {
  @override
  Future<void> createUser(UserModel user) async {
    await datasource.putUser(user);
  }

  @override
  UserModel? getUser(String email) {
    return datasource.getUser(email);
  }

  @override
  Future<void> deleteUser(String email) async {
    await datasource.deleteUser(email);
  }

  @override
  Future<void> updateUser(UserModel user) async {
    await datasource.putUser(user);
  }
}
