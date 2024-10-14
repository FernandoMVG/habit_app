// picker_functions.dart
import 'package:flutter/material.dart';
import 'package:habit_app/constants.dart'; // Importar las constantes para colores e íconos

// Función para mostrar el diálogo de selección de íconos
Future<void> showIconPicker(BuildContext context, IconData? selectedIcon,
    ValueChanged<IconData> onIconSelected) async {
  await showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Center(child: Text('Selecciona un ícono')),
        content: SizedBox(
          width: 300,
          height: 200,
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: iconOptions.length,
            itemBuilder: (context, index) {
              return IconButton(
                icon: Icon(iconOptions[index],
                    color: selectedIcon == iconOptions[index]
                        ? Colors.blue
                        : Colors.grey),
                onPressed: () {
                  onIconSelected(iconOptions[index]);
                  Navigator.pop(context);
                },
              );
            },
          ),
        ),
      );
    },
  );
}

// Función para mostrar el diálogo de selección de colores
Future<void> showColorPicker(BuildContext context, Color? selectedColor,
    ValueChanged<Color> onColorSelected) async {
  await showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Center(child: Text('Selecciona un color')),
        content: SizedBox(
          width: 300,
          height: 200,
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: colorOptions.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  onColorSelected(colorOptions[index]);
                  Navigator.pop(context);
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: colorOptions[index],
                    shape: BoxShape.circle,
                    border: selectedColor == colorOptions[index]
                        ? Border.all(color: Colors.blue, width: 3)
                        : null,
                  ),
                  width: 40,
                  height: 40,
                ),
              );
            },
          ),
        ),
      );
    },
  );
}
