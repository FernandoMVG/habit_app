import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habit_app/UI/controller/habit_controller.dart';
import 'package:habit_app/UI/pages/Welcome/welcome_screen.dart';
import 'package:habit_app/constants.dart'; // Importar las constantes
import 'package:habit_app/services/auth_service.dart';
import 'package:habit_app/UI/controller/user_controller.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final HabitController habitController = Get.find<HabitController>();
  final AuthService authService =
      AuthService(); // Usar AuthService para cerrar sesión
  final UserController userController = Get.find<UserController>();

  CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: surfaceColor,
      automaticallyImplyLeading: false,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          PopupMenuButton<String>(
            icon: const Icon(
              Icons.menu,
              color: onSurfaceColor,
            ),
            onSelected: (String value) async {
              if (value == 'Avanzar día') {
                habitController.advanceDate();
              } else if (value == 'Retroceder día') {
                habitController.goBackDate();
              } else if (value == 'Cerrar sesión') {
                // Llama al método logOut de AuthService y redirige al usuario a la pantalla de bienvenida
                await authService.signOut(context);
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
                      color: errorColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              // Mostrar el nombre del usuario obtenido de Firestore
              Obx(() => Text(
                    '¡Hola, ${userController.username}!',
                    style: subtitle2TextStyle,
                  )),
              const SizedBox(width: 10),

              // Contenedor de Nivel
              Obx(() =>
                  _buildInfoContainer('Lvl. ${userController.level}', context)),
              const SizedBox(width: 10),

              // Contenedor de EXP
              Obx(() => _buildInfoContainer(
                  'EXP ${userController.experience}', context)),
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
