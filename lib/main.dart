import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habit_app/UI/pages/home.dart';  // Asegúrate de usar el nombre correcto del proyecto y ruta

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter GetX App',

      // Define la página inicial como Home
      initialRoute: '/home',

      // Define las rutas de la aplicación usando GetX
      getPages: [
        GetPage(
          name: '/home',
          page: () => const HomePage(), // Tu pantalla Home
        ),
        // Aquí puedes agregar más rutas cuando estén listas
        // GetPage(
        //   name: '/login',
        //   page: () => LoginPage(), // Pantalla de login que tu compañero trabajará
        // ),
      ],
    );
  }
}
