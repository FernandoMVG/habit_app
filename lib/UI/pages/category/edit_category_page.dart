// lib/pages/category/edit_category_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habit_app/UI/pages/category/picker_functions.dart';
import 'package:habit_app/constants.dart';
import 'package:habit_app/models/category_model.dart';
import 'package:habit_app/ui/controller/category_controller.dart';
import 'package:habit_app/ui/widgets/buttons.dart';
import 'package:habit_app/ui/widgets/text_field.dart';

class EditCategoryPage extends StatefulWidget {
  final CategoryModel category;

  const EditCategoryPage({required this.category, super.key});

  @override
  State<EditCategoryPage> createState() => _EditCategoryPageState();
}

class _EditCategoryPageState extends State<EditCategoryPage> {
  late TextEditingController _nameController;
  IconData? _selectedIcon;
  Color? _selectedColor;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.category.name);
    _selectedIcon = widget.category.icon;
    _selectedColor = widget.category.color;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edita la categoría"),
        backgroundColor: Theme.of(context).colorScheme.surface,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Edita el nombre",
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
                    _selectedIcon = icon; // Actualizar ícono
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
                    _selectedColor = color; // Actualizar color
                  });
                });
              },
            ),
            const SizedBox(height: 30),

            // Botones de Cancelar y Guardar
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CancelButton(onPressed: () {
                  Get.back();
                }),
                NavigateButton(
                  text: "Guardar",
                  onPressed: () {
                    if (_nameController.text.isNotEmpty &&
                        _selectedIcon != null &&
                        _selectedColor != null) {
                      bool isUpdated =
                          Get.find<CategoryController>().updateCategory(
                        widget.category,
                        _nameController.text,
                        _selectedIcon!,
                        _selectedColor!,
                        context,
                      );

                      if (isUpdated) {
                        Get.back(); // Navegar de vuelta solo si la categoría se actualizó con éxito
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content:
                              Text('Por favor, completa todos los campos.'),
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
