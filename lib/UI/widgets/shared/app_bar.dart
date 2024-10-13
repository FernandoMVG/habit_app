import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habit_app/ui/controller/habit_controller.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final HabitController habitController = Get.find<HabitController>();

  // Quitamos el `const` del constructor
  CustomAppBar({super.key});
  
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.surface,
      automaticallyImplyLeading: false,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          PopupMenuButton<String>(
            icon: Icon(
              Icons.menu,
              color: Theme.of(context).colorScheme.onSurface,
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
                child: Text('Avanzar día'),
              ),
              const PopupMenuItem<String>(
                value: 'Retroceder día',
                child: Text('Retroceder día'),
              ),
            ],
          ),
          Row(
            children: [
              const Text('Usuario', style: TextStyle(color: Colors.white)),
              const SizedBox(width: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  'Lvl. 0',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(width: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  'EXP 0',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

