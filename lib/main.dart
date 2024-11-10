import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habit_app/UI/controller/category_controller.dart';
import 'package:habit_app/UI/pages/home.dart';
import 'package:habit_app/constants.dart';
import 'package:habit_app/UI/pages/Welcome/welcome_screen.dart';
import 'package:habit_app/UI/controller/auth_controller.dart';
import 'package:habit_app/UI/controller/habit_controller.dart';
import 'package:habit_app/UI/controller/user_controller.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:habit_app/models/habit_model.dart';
import 'package:habit_app/models/user_model.dart';
import 'package:habit_app/models/category_model.dart';
import 'package:intl/date_symbol_data_local.dart'; // Import para formato regional

void main() async {
  // Asegura que los bindings se inicializan correctamente.
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializa Hive.
  await Hive.initFlutter();

  // Register custom adapters for Color and IconData
  Hive.registerAdapter(ColorAdapter());
  Hive.registerAdapter(IconDataAdapter());
  // Register adapters here
  Hive.registerAdapter(HabitAdapter());
  Hive.registerAdapter(UserModelAdapter());
  Hive.registerAdapter(CategoryModelAdapter());

  // Abre las cajas de Hive.
  await Hive.openBox<UserModel>('userBox');

  // Inicializa la configuración regional para español.
  await initializeDateFormatting('es');

  // Instancias de los controladores usando Get.
  Get.put(UserController());
  Get.put(AuthController()); // Controlador de autenticación
  Get.put(HabitController()); // Controlador de hábitos
  Get.put(CategoryController()); // Controlador de categorías

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Habit App',

      // Definición del tema
      theme: ThemeData(
        scaffoldBackgroundColor: secondaryColor, // Fondo claro general
        primaryColor: primaryColor, // Color primario

        // Esquema de colores
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: primaryColor,
          secondary: secondaryColor,
          error: errorColor,
          surface: surfaceColor,
          onSurface: onSurfaceColor,
          onPrimary: onPrimaryColor,
        ),

        // Estilo de texto
        textTheme: const TextTheme(
          titleLarge: titleTextStyle,
          bodyLarge: bodyTextStyle,
          bodyMedium: subtitleTextStyle,
          labelLarge: labelTextStyle,
        ),

        // Tema de botones elevados
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: onPrimaryColor, // Texto en blanco
            backgroundColor: primaryColor, // Fondo del botón primario
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(defaultRadius),
            ),
          ),
        ),

        // Estilo de campos de texto
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: kPrimaryLightColor,
          iconColor: primaryColor,
          prefixIconColor: primaryColor,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: defaultPadding,
            vertical: defaultPadding,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(defaultRadius),
            borderSide: BorderSide.none,
          ),
        ),

        // Navigation Bar Theme
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: navBarBackgroundColor,
          selectedItemColor: navBarActiveColor,
          unselectedItemColor: navBarInactiveColor,
          selectedLabelStyle: navBarTextStyle,
          unselectedLabelStyle: navBarTextStyle.copyWith(
            color: navBarInactiveColor,
          ),
        ),
      ),

      // Pantalla inicial
      home: const WelcomeScreen(), // Página de inicio
    );
  }
}

class ColorAdapter extends TypeAdapter<Color> {
  @override
  final int typeId = 3;

  @override
  Color read(BinaryReader reader) {
    return Color(reader.readInt());
  }

  @override
  void write(BinaryWriter writer, Color obj) {
    writer.writeInt(obj.value);
  }
}

class IconDataAdapter extends TypeAdapter<IconData> {
  @override
  final int typeId = 4;

  @override
  IconData read(BinaryReader reader) {
    return IconData(reader.readInt(), fontFamily: 'MaterialIcons');
  }

  @override
  void write(BinaryWriter writer, IconData obj) {
    writer.writeInt(obj.codePoint);
  }
}
