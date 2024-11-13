import 'package:flutter/material.dart';
import 'package:integration_test/integration_test.dart';  // Add this import
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:habit_app/UI/controller/auth_controller.dart';
import 'package:habit_app/UI/controller/category_controller.dart';
import 'package:habit_app/UI/controller/habit_controller.dart';
import 'package:habit_app/UI/controller/user_controller.dart';
import 'package:habit_app/UI/pages/Welcome/welcome_screen.dart';
import 'package:habit_app/main.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:habit_app/domain/models/category_model.dart';
import 'package:habit_app/domain/models/habit_model.dart';
import 'package:habit_app/domain/models/user_model.dart';
import 'package:habit_app/domain/repositories/user_repository.dart';
import 'package:habit_app/domain/repositories/habit_repository.dart';
import 'package:habit_app/domain/repositories/category_repository.dart';
import 'package:habit_app/domain/repositories/auth_repository.dart';
import 'package:habit_app/domain/use_case/user_use_case.dart';
import 'package:habit_app/domain/use_case/habit_use_case.dart';
import 'package:habit_app/domain/use_case/category_use_case.dart';
import 'package:habit_app/domain/use_case/auth_use_case.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    await Hive.initFlutter();

    // Register adapters if not already registered
    if (!Hive.isAdapterRegistered(0)) Hive.registerAdapter(HabitAdapter());
    if (!Hive.isAdapterRegistered(1)) Hive.registerAdapter(UserModelAdapter());
    if (!Hive.isAdapterRegistered(2)) Hive.registerAdapter(CategoryModelAdapter());
    if (!Hive.isAdapterRegistered(3)) Hive.registerAdapter(ColorAdapter());
    if (!Hive.isAdapterRegistered(4)) Hive.registerAdapter(IconDataAdapter());

    // Open boxes
    await Hive.openBox<UserModel>('userBox');
    // Don't open habit and category boxes here - they are opened per user

    // Initialize locale
    await initializeDateFormatting('es');

    // Reset GetX
    Get.reset();

    // Initialize dependencies
    final userRepo = UserRepositoryImpl();
    final habitRepo = HabitRepositoryImpl();
    final categoryRepo = HiveCategoryRepository();
    final authRepo = AuthRepositoryImpl();

    // Initialize use cases and controllers
    Get.put(UserController(UserUseCase(userRepo)));
    Get.put(AuthController(AuthUseCase(authRepo)));
    Get.put(HabitController(HabitUseCase(habitRepo)));
    Get.put(CategoryController(CategoryUseCase(categoryRepo)));
  });

  tearDown(() async {
    await Hive.deleteFromDisk();
    Get.reset();
  });

  group('App Integration Tests', () {
    testWidgets('Complete auth flow test', (tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      // Test Welcome Screen
      expect(find.byType(WelcomeScreen), findsOneWidget);

      // Navigate to Sign Up
      await tester.tap(find.text('SIGN UP'));
      await tester.pumpAndSettle();

      // Fill signup form
      await tester.enterText(find.byKey(const Key('email_field')), 'test@test.com');
      await tester.enterText(find.byKey(const Key('password_field')), 'password123');
      await tester.tap(find.byKey(const Key('signup_button')));
      await tester.pumpAndSettle();

      // Should be redirected to login screen after signup
      expect(find.byKey(const Key('login_email_field')), findsOneWidget);

      // Test login with created credentials
      await tester.enterText(find.byKey(const Key('login_email_field')), 'test@test.com');
      await tester.enterText(find.byKey(const Key('login_password_field')), 'password123');
      await tester.tap(find.byKey(const Key('login_button')));
      await tester.pumpAndSettle();
      

    });
  });
}
