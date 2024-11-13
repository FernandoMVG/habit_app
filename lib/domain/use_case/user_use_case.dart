import 'package:habit_app/domain/models/user_model.dart';
import 'package:habit_app/domain/repositories/user_repository.dart';

class UserUseCase {
  final UserRepository _repository;

  UserUseCase(this._repository);

  Future<void> createUser(UserModel user) async {
    await _repository.createUser(user);
  }

  UserModel? getUser(String email) {
    return _repository.getUser(email);
  }

  Future<void> deleteUser(String email) async {
    await _repository.deleteUser(email);
  }

  Future<void> updateUser(UserModel user) async {
    await _repository.updateUser(user);
  }
}
