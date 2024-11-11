import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habit_app/UI/controller/category_controller.dart';
import 'package:habit_app/constants.dart';
import 'package:habit_app/UI/pages/Welcome/welcome_screen.dart';
//import 'package:provider/provider.dart';
import 'package:habit_app/UI/controller/auth_controller.dart';
import 'package:habit_app/UI/controller/habit_controller.dart';
import 'package:habit_app/UI/controller/user_controller.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:habit_app/firebase_options.dart';

import 'package:intl/date_symbol_data_local.dart'; // Import para formato regional

void main() async {
  // Asegura que los bindings se inicializan correctamente.
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Inicializa la configuración regional para español.
  await initializeDateFormatting('es');

  // Instancias de los controladores usando Get.
  Get.put(UserController()); // Controlador de usuario
  Get.put(HabitController()); // Controlador de hábitos
  Get.put(CategoryController()); // Controlador de categorías (uso de Get.put)
  Get.put(AuthController()); // Controlador de autenticación

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
