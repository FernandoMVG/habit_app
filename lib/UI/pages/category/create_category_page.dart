// lib/pages/category/create_category_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habit_app/UI/pages/category/picker_functions.dart';
import 'package:habit_app/UI/widgets/shared/buttons.dart';
import 'package:habit_app/UI/widgets/shared/text_field.dart';
import 'package:habit_app/constants.dart';
import 'package:habit_app/ui/controller/category_controller.dart';

class CreateCategoryPage extends StatefulWidget {
  const CreateCategoryPage({super.key});

  @override
  State<CreateCategoryPage> createState() => _CreateCategoryPageState();
}

class _CreateCategoryPageState extends State<CreateCategoryPage> {
  final TextEditingController _nameController = TextEditingController();
  IconData? _selectedIcon;
  Color? _selectedColor;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Crea una categoría"),
        backgroundColor: Theme.of(context).colorScheme.surface,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Ingresa un nombre",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            CustomTextField(
              controller: _nameController,
              labelText: "Nombre de la categoría",
            ),
            const SizedBox(height: 20),

            // Sección para seleccionar un ícono
            const Text("Escoge un ícono",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            IconButton(
              icon: Icon(_selectedIcon ?? Icons.add, color: primaryColor),
              onPressed: () {
                showIconPicker(context, _selectedIcon, (icon) {
                  setState(() {
                    _selectedIcon = icon; // Actualizar el ícono seleccionado
                  });
                });
              },
            ),
            const SizedBox(height: 20),

            // Sección para seleccionar un color
            const Text("Elige un color",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            IconButton(
              icon:
                  Icon(Icons.color_lens, color: _selectedColor ?? primaryColor),
              onPressed: () {
                showColorPicker(context, _selectedColor, (color) {
                  setState(() {
                    _selectedColor = color; // Actualizar el color seleccionado
                  });
                });
              },
            ),
            const SizedBox(height: 30),

            // Botones de Cancelar y Continuar
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CancelButton(onPressed: () {
                  Get.back();
                }),
                NavigateButton(
                  text: "Continuar",
                  onPressed: () {
                    if (_nameController.text.isNotEmpty &&
                        _selectedIcon != null &&
                        _selectedColor != null) {
                      // Intentar agregar la categoría
                      bool isAdded = Get.find<CategoryController>().addCategory(
                        _nameController.text,
                        _selectedIcon!,
                        _selectedColor!,
                        context,
                      );

                      if (isAdded) {
                        Get.back(); // Solo navegar hacia atrás si la categoría fue creada exitosamente
                      }
                    } else {
                      // Mostrar mensaje si faltan campos
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content:
                              Text('Por favor, completa todos los campos.'),
                        ),
                      );
                    }
                  },
                  isEnabled: _nameController.text.isNotEmpty &&
                      _selectedIcon != null &&
                      _selectedColor != null,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
