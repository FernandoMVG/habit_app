import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final int experience; // Recibir experiencia como parámetro

  const CustomAppBar({super.key, required this.experience});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.surface,
      automaticallyImplyLeading: false,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: Icon(Icons.menu, 
            color: Theme.of(context).colorScheme.onSurface
            ),
            onPressed: () {}, // Funcionalidad del menú
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
                child: const Text('Lvl. 0', // Aquí actualizas el nivel más adelante
                style: TextStyle(color: Colors.white)
                ), 
              ),
              const SizedBox(width: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                // Mostrar la experiencia dinámica
                child: Text('EXP $experience', // Mostrar la experiencia pasada
                style: const TextStyle(color: Colors.white)
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
