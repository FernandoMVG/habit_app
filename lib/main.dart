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
        scaffoldBackgroundColor: Colors.white,  // Fondo claro
        primaryColor: const Color(0xFF2980B9),  // Azul primario
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: const Color(0xFF2980B9),  // Azul primario
          secondary: const Color(0xE6E6E6E6),  // Fondo claro
          error: const Color(0xFFC0392B),  // Rojo de error
          surface: const Color(0xFF34495E),  // Color para las superficies (ej. nav bar)
        

          onSurface: Colors.grey,  // Color para texto/iconos en superficies
          onPrimary: Colors.white,  // Color del texto sobre el primario
        ),
        textTheme: const TextTheme(
          titleLarge: TextStyle(color: Color(0xFF2980B9), fontWeight: FontWeight.bold),
          bodyLarge: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          bodyMedium: TextStyle(color: Colors.grey),
          labelLarge: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          labelSmall: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
          
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white, backgroundColor: const Color(0xFF2980B9),  // Texto en blanco
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
      ),
      home: HomePage(),  // Página de inicio
    );
  }
}
