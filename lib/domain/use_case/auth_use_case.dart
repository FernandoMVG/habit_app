import 'package:habit_app/domain/models/user_model.dart';
import 'package:habit_app/domain/repositories/auth_repository.dart';

class AuthUseCase {
  final AuthRepository _authRepository;

  AuthUseCase(this._authRepository);

  Future<bool> login(String email, String password) async {
    return await _authRepository.login(email, password);
  }

  Future<void> signup(UserModel user) async {
    await _authRepository.signup(user);
  }

  Future<void> updateUserProgress(UserModel user) async {
    print('AuthUseCase: Actualizando progreso del usuario ${user.email}');
    await _authRepository.updateUserProgress(user);
    print('AuthUseCase: Progreso actualizado');
  }

  Future<void> setCurrentUser(UserModel user) async {
    await _authRepository.setCurrentUser(user);
  }

  UserModel? getCurrentUser() {
    return _authRepository.getCurrentUser();
  }

  Future<void> clearCurrentUser() async {
    print('AuthUseCase: Limpiando usuario actual');
    await _authRepository.clearCurrentUser();
    print('AuthUseCase: Usuario actual limpiado');
  }
}
