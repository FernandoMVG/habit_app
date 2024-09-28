import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habit_app/ui/pages/home.dart';  // Importa la página de home

void main() {
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
      title: 'Habit App',

      // Definir tema claro
      theme: ThemeData(
        primaryColor: const Color(0xFF2980B9),  // Color principal
        hintColor: const Color(0xFF2C3E50),  // Color de acento (barra de navegación y botones)
        scaffoldBackgroundColor: Colors.white,  // Fondo de la pantalla
        buttonTheme: const ButtonThemeData(
          buttonColor: Color(0xFF2980B9),  // Color de los botones (Continuar, FAB)
          textTheme: ButtonTextTheme.primary,  // Texto del botón en blanco
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Color(0xFF2980B9),  // FAB
          foregroundColor: Colors.white,
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.black),  // Texto principal
          bodyMedium: TextStyle(color: Colors.grey),  // Subtexto (descripciones)
        ),
      ),

      // Definir tema oscuro
      darkTheme: ThemeData(
        primaryColor: const Color(0xFF1A237E),
        hintColor: const Color(0xFF3949AB),
        scaffoldBackgroundColor: Colors.black,
        buttonTheme: const ButtonThemeData(
          buttonColor: Color(0xFF3949AB),
          textTheme: ButtonTextTheme.primary,
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Color(0xFF3949AB),
          foregroundColor: Colors.white,
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.white),
          bodyMedium: TextStyle(color: Colors.grey),
        ),
      ),

      themeMode: ThemeMode.system,  // Modo de tema automático
      home: const HomePage(),  // Página de inicio
    );
  }
}
