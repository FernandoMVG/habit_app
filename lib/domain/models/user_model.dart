import 'package:hive/hive.dart';

part 'user_model.g.dart';

@HiveType(typeId: 1)
class UserModel {
  @HiveField(0)
  final String email;
  @HiveField(1)
  final String password;
  @HiveField(2)
  final int experience;
  @HiveField(3)
  final int level;

  UserModel({
    required this.email,
    required this.password,
    this.experience = 0,
    this.level = 1,
  });
}
