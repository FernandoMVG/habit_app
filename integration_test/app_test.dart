import 'package:flutter/material.dart';
import 'package:habit_app/UI/pages/category/create_category_page.dart';
import 'package:habit_app/UI/pages/habits_pages/choose_category.dart';
import 'package:habit_app/UI/pages/habits_pages/choose_frequency.dart';
import 'package:habit_app/UI/pages/habits_pages/create_habits.dart';
import 'package:habit_app/UI/pages/habits_pages/habit_type.dart';
import 'package:habit_app/UI/widgets/shared/text_field.dart';
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
import 'package:habit_app/UI/pages/home.dart';
import 'package:habit_app/UI/pages/habits.dart';
import 'package:habit_app/UI/pages/category/category_page.dart';

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

      // Verify HomePage is displayed
      expect(find.byType(HomePage), findsOneWidget);

      // Navigate to HabitPage using the navigation bar
      await tester.tap(find.text('Hábitos'));
      await tester.pumpAndSettle();
      expect(find.byType(HabitPage), findsOneWidget);

      // Navigate to CategoryPage using the navigation bar
      await tester.tap(find.text('Categorías'));
      await tester.pumpAndSettle();
      expect(find.byType(CategoryPage), findsOneWidget);

      // Navigate back to HomePage using the navigation bar
      await tester.tap(find.text('Rutina'));
      await tester.pumpAndSettle();
      expect(find.byType(HomePage), findsOneWidget);

      // Click on FAB to navigate to HabitTypeSelectionPage
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();
      expect(find.byType(HabitTypeSelectionPage), findsOneWidget);

      // Select "Sí o No" option
      await tester.tap(find.text('Sí o No'));
      await tester.pumpAndSettle();
      expect(find.byType(CreateHabitPage), findsOneWidget);

      // Fill habit name and description
      await tester.enterText(find.byType(TextField).at(0), 'Estudiar Flutter');
      await tester.enterText(find.byType(TextField).at(1), 'Repasar conceptos básicos');
      await tester.tap(find.text('Continuar'));
      await tester.pumpAndSettle();
      expect(find.byType(ChooseCategoryPage), findsOneWidget);

      // Select a category
      await tester.tap(find.byType(GestureDetector).first);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Continuar'));
      await tester.pumpAndSettle();
      expect(find.byType(ChooseFrequencyPage), findsOneWidget);

      // Select "Todos los días" and finalize
      await tester.tap(find.text('Todos los días'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Finalizar'));
      await tester.pumpAndSettle();
      expect(find.byType(HabitPage), findsOneWidget);

    });
  });
}
