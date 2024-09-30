// main.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habit_app/ui/pages/home.dart'; // Importa la página de home
import 'package:habit_app/constants.dart'; // Importa las constantes de colores
import 'package:habit_app/ui/pages/Welcome/welcome_screen.dart';
import 'package:provider/provider.dart';
import 'package:habit_app/UI/controller/auth_controller.dart'; // Importa el controlador

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (_) => AuthController()), // Inicializa AuthController
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

        // Definir tema claro
        theme: ThemeData(
            scaffoldBackgroundColor: Colors.white, // Fondo claro
            primaryColor: primaryColor, // Azul primario
            colorScheme: ColorScheme.fromSwatch().copyWith(
              primary: primaryColor, // Azul primario
              secondary: secondaryColor, // Fondo claro
              error: errorColor, // Rojo de error
              surface: surfaceColor, // Color para superficies
              onSurface:
                  onSurfaceColor, // Color para texto/iconos en superficies
              onPrimary: onPrimaryColor, // Color del texto sobre el primario
            ),
            textTheme: const TextTheme(
              titleLarge: TextStyle(
                  color: Color(0xFF2980B9), fontWeight: FontWeight.bold),
              bodyLarge:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              bodyMedium: TextStyle(color: Colors.grey),
              labelLarge:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              labelSmall:
                  TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
            ),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: primaryColor, // Texto en blanco
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            inputDecorationTheme: const InputDecorationTheme(
              filled: true,
              fillColor: kPrimaryLightColor,
              iconColor: primaryColor,
              prefixIconColor: primaryColor,
              contentPadding: EdgeInsets.symmetric(
                  horizontal: defaultPadding, vertical: defaultPadding),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(30)),
                borderSide: BorderSide.none,
              ),
            )),
        home: //const WelcomeScreen() 
        const HomePage(), // Página de inicio
        );
  }
}
