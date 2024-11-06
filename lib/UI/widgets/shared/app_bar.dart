import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habit_app/UI/controller/habit_controller.dart';
import 'package:habit_app/UI/pages/Welcome/welcome_screen.dart';
import 'package:habit_app/constants.dart'; // Importar las constantes
import 'package:habit_app/UI/controller/auth_controller.dart';
import 'package:habit_app/UI/controller/user_controller.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final HabitController habitController = Get.find<HabitController>();
  final AuthController authController = Get.find<AuthController>(); // Usar GetX para AuthController
  final UserController userController = Get.find<UserController>();

  CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    // Obtener el email del usuario autenticado desde AuthController
    // final authController = Provider.of<AuthController>(context); // Eliminar uso de Provider

    // Obtener solo la parte del email antes del '@'
    final String userEmail = authController.user?.email ?? 'Usuario';
    final String userName = userEmail.split('@').first;

    return AppBar(
      backgroundColor: surfaceColor,
      automaticallyImplyLeading: false,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Menú de opciones para avanzar o retroceder día y cerrar sesión
          PopupMenuButton<String>(
            icon: const Icon(
              Icons.menu,
              color: onSurfaceColor, // Usamos onSurfaceColor para el icono
            ),
            onSelected: (String value) {
              if (value == 'Avanzar día') {
                habitController.advanceDate();
              } else if (value == 'Retroceder día') {
                habitController.goBackDate();
              } else if (value == 'Cerrar sesión') {
                authController.logOut(); // Cerrar sesión
                Get.offAll(() => const WelcomeScreen());
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'Avanzar día',
                child: ListTile(
                  leading: Icon(Icons.arrow_forward, color: onSurfaceColor),
                  title: Text('Avanzar día', style: bodyTextStyle),
                ),
              ),
              const PopupMenuItem<String>(
                value: 'Retroceder día',
                child: ListTile(
                  leading: Icon(Icons.arrow_back, color: onSurfaceColor),
                  title: Text('Retroceder día', style: bodyTextStyle),
                ),
              ),
              PopupMenuItem<String>(
                value: 'Cerrar sesión',
                child: ListTile(
                  leading: const Icon(Icons.logout, color: errorColor),
                  title: Text(
                    'Cerrar sesión',
                    style: bodyTextStyle.copyWith(
                      color:
                          errorColor, // Usamos errorColor para "Cerrar sesión"
                    ),
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              // Mostrar el nombre del usuario antes del '@'
              Text(
                '¡Hola, $userName!', // Mostrar solo la parte antes del @
                style:
                    subtitle2TextStyle, // Usar subtitleTextStyle de constants.dart
              ),
              const SizedBox(width: 10),

              // Contenedor de Nivel
              Obx(() => _buildInfoContainer('Lvl. ${userController.level}', context)),
              const SizedBox(width: 10),

              // Contenedor de EXP
              Obx(() => _buildInfoContainer('EXP ${userController.experience}', context)),
            ],
          ),
        ],
      ),
    );
  }

  // Widget para los contenedores de Nivel y EXP
  Widget _buildInfoContainer(String text, BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      decoration: BoxDecoration(
        color: navBarBackgroundColor.withOpacity(0.4),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        text,
        style: bodyTextStyle.copyWith(
          color: onPrimaryColor,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
