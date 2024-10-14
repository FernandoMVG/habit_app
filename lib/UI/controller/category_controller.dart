import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:habit_app/models/category_model.dart';
import 'package:habit_app/constants.dart'; // Importamos las categorías por defecto

class CategoryController extends GetxController {
  var categories =
      <CategoryModel>[].obs; // Lista observable de objetos CategoryModel

  @override
  void onInit() {
    super.onInit();
    _loadDefaultCategories(); // Cargar categorías por defecto al iniciar
  }

  // Método para añadir una categoría, con verificación de duplicado
  bool addCategory(
      String name, IconData icon, Color color, BuildContext context) {
    if (!_categoryExists(name)) {
      categories.add(CategoryModel(name: name, icon: icon, color: color));
      return true; // Retornar true si la categoría fue añadida
    } else {
      // Mostrar un mensaje de error si ya existe usando ScaffoldMessenger
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Ya existe una categoría con ese nombre.'),
          backgroundColor: Colors.red,
        ),
      );
      return false; // Retornar false si ya existe una categoría con el mismo nombre
    }
  }

  // Método para actualizar una categoría existente
  bool updateCategory(CategoryModel category, String newName, IconData newIcon,
      Color newColor, BuildContext context) {
    if (!_categoryExists(newName) ||
        category.name.toLowerCase() == newName.toLowerCase()) {
      final updatedCategory = CategoryModel(
        name: newName,
        icon: newIcon,
        color: newColor,
      );

      final index = categories.indexOf(category);
      if (index != -1) {
        categories[index] = updatedCategory;
      }

      categories
          .refresh(); // Refrescar la lista de categorías para reflejar cambios
      return true;
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Ya existe una categoría con ese nombre.'),
          backgroundColor: Colors.red,
        ),
      );
      return false;
    }
  }

  // Método para eliminar una categoría
  void removeCategory(CategoryModel category) {
    categories.remove(category);
  }

  // Función que verifica si ya existe una categoría con el mismo nombre
  bool _categoryExists(String name) {
    return categories
        .any((category) => category.name.toLowerCase() == name.toLowerCase());
  }

  // Método para cargar las categorías por defecto
  void _loadDefaultCategories() {
    categories.addAll(
        defaultCategories); // Cargar las categorías por defecto desde constants.dart
  }
}
