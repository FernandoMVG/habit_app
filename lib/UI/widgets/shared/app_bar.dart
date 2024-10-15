import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habit_app/ui/controller/habit_controller.dart';
import 'package:habit_app/constants.dart'; // Importa las constantes

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final HabitController habitController = Get.find<HabitController>();
  final int experience;

  CustomAppBar({super.key, required this.experience});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: surfaceColor, // Fondo de la AppBar
      automaticallyImplyLeading: false,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Menú de opciones para avanzar o retroceder día
          PopupMenuButton<String>(
            icon: Icon(
              Icons.menu,
              color: onSurfaceColor, // Icono en la superficie
            ),
            onSelected: (String value) {
              if (value == 'Avanzar día') {
                habitController.advanceDate();
              } else if (value == 'Retroceder día') {
                habitController.goBackDate();
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'Avanzar día',
                child: Text(
                  'Avanzar día',
                  style: bodyTextStyle, // Usa el estilo parametrizado
                ),
              ),
              const PopupMenuItem<String>(
                value: 'Retroceder día',
                child: Text(
                  'Retroceder día',
                  style: bodyTextStyle,
                ),
              ),
            ],
          ),
          Row(
            children: [
              // Texto de Usuario
              const Text(
                'Usuario',
                style: TextStyle(color: onPrimaryColor),
              ),
              const SizedBox(width: 10),
              
              // Contenedor de Nivel
              _buildInfoContainer('Lvl. 0', context),
              const SizedBox(width: 10),

              // Contenedor de EXP
              _buildInfoContainer('EXP $experience', context),
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
        color: navBarBackgroundColor.withOpacity(0.4), // Fondo semitransparente
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        text,
        style: bodyTextStyle.copyWith(
          color: onPrimaryColor, // Color del texto
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
