// lib/pages/category/edit_category_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habit_app/UI/controller/category_controller.dart';
import 'package:habit_app/UI/pages/category/picker_functions.dart';
import 'package:habit_app/UI/widgets/shared/buttons.dart';
import 'package:habit_app/UI/widgets/shared/text_field.dart';
import 'package:habit_app/constants.dart';
import 'package:habit_app/domain/models/category_model.dart';

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
            const SizedBox(height: 10),
            CustomTextField(
              controller: _nameController,
              labelText: "Nombre de la categoría",
            ),
            const SizedBox(height: 20),

            // Sección para seleccionar un ícono
            const Text("Escoge un ícono",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            GestureDetector(
              onTap: () {
                showIconPicker(context, _selectedIcon, (icon) {
                  setState(() {
                    _selectedIcon = icon; // Actualizar ícono
                  });
                });
              },
              child: Container(
                height: 50,
                width: 100,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Theme.of(context).primaryColor,
                    width: 2,
                  ),
                ),
                child: Icon(
                  _selectedIcon ?? Icons.add,
                  color: Theme.of(context).primaryColor,
                  size: 25,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Sección para seleccionar un color
            const Text("Elige un color",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            GestureDetector(
              onTap: () {
                showColorPicker(context, _selectedColor, (color) {
                  setState(() {
                    _selectedColor = color; // Actualizar color
                  });
                });
              },
              child: Container(
                height: 50,
                width: 100,
                decoration: BoxDecoration(
                  color: _selectedColor ?? Theme.of(context).primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: _selectedColor ?? Theme.of(context).primaryColor,
                    width: 2,
                  ),
                ),
                child: Icon(
                  Icons.color_lens,
                  color: _selectedColor != null ? Colors.white : Theme.of(context).primaryColor,
                  size: 25,
                ),
              ),
            ),
            const Spacer(),

            // Botones de Cancelar y Guardar
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CancelButton(onPressed: () {
                  Get.back();
                }),
                NavigateButton(
                  text: "Guardar",
                  onPressed: () async {
                    if (_nameController.text.isNotEmpty &&
                        _selectedIcon != null &&
                        _selectedColor != null) {
                      bool isUpdated = await Get.find<CategoryController>().updateCategory(
                        widget.category,
                        _nameController.text,
                        _selectedIcon!,
                        _selectedColor!,
                        context,
                      );

                      if (isUpdated) {
                        Get.back();
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Por favor, completa todos los campos.'),
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
