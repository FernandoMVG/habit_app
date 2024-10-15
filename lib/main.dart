import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habit_app/UI/controller/category_controller.dart';
import 'package:habit_app/ui/pages/home.dart';
import 'package:habit_app/constants.dart';
import 'package:habit_app/ui/pages/Welcome/welcome_screen.dart';
import 'package:provider/provider.dart';
import 'package:habit_app/UI/controller/auth_controller.dart';
import 'package:habit_app/ui/controller/habit_controller.dart';

import 'package:intl/date_symbol_data_local.dart'; // Import para formato regional

void main() async {
  // Asegura que los bindings se inicializan correctamente.
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializa la configuración regional para español.
  await initializeDateFormatting('es');

  // Instancias de los controladores usando Get.
  Get.put(HabitController()); // Controlador de hábitos
  Get.lazyPut(() => CategoryController()); // Controlador de categorías

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthController(), // Inicializa AuthController
        ),
      ],
      child: const MyApp(),
    ),
  );
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
      home: const HomePage(), // Página de inicio
    );
  }
}

