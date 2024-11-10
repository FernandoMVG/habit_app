import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:habit_app/models/category_model.dart';
import 'package:habit_app/constants.dart'; // Importamos las categorías por defecto
import 'package:hive/hive.dart';
import 'package:habit_app/UI/controller/user_controller.dart';

class CategoryController extends GetxController {
  late Box<CategoryModel> categoryBox;
  var categories =
      <CategoryModel>[].obs; // Lista observable de objetos CategoryModel
  final UserController userController = Get.find<UserController>();

  @override
  void onInit() {
    super.onInit();
    _openCategoryBox();
  }

  Future<void> _openCategoryBox() async {
    try {
      if (userController.currentUserEmail.isEmpty) {
        categories.clear();
        return;
      }

      // Cerrar la caja anterior si existe
      if (Hive.isBoxOpen('categoryBox_${userController.currentUserEmail}')) {
        await Hive.box<CategoryModel>('categoryBox_${userController.currentUserEmail}').close();
      }

      categoryBox = await Hive.openBox<CategoryModel>('categoryBox_${userController.currentUserEmail}');
      categories.clear(); // Limpiar categorías existentes
      _loadCategories();
    } catch (e) {
      print('Error al abrir la caja de categorías: $e');
    }
  }

  Future<void> reloadCategories() async {
    await _openCategoryBox();
  }

  void _loadCategories() {
    categories.addAll(categoryBox.values);
  }

  // Método para añadir una categoría, con verificación de duplicado
  bool addCategory(
      String name, IconData icon, Color color, BuildContext context) {
    if (!_categoryExists(name)) {
      final newCategory = CategoryModel(name: name, icon: icon, color: color);
      categories.add(newCategory);
      categoryBox.put(name, newCategory); // Guardar categoría en Hive
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
        categoryBox.put(newName, updatedCategory); // Actualizar categoría en Hive
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
    categoryBox.delete(category.name); // Eliminar categoría de Hive
  }

  // Función que verifica si ya existe una categoría con el mismo nombre
  bool _categoryExists(String name) {
    return categories
        .any((category) => category.name.toLowerCase() == name.toLowerCase());
  }
}
