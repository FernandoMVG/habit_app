import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:habit_app/domain/models/category_model.dart';
import 'package:habit_app/constants.dart';
import 'package:habit_app/UI/controller/user_controller.dart';
import 'package:habit_app/domain/use_case/category_use_case.dart';

class CategoryController extends GetxController {
  final CategoryUseCase categoryUseCase;
  var categories = <CategoryModel>[].obs;
  final UserController userController = Get.find<UserController>();

  CategoryController(this.categoryUseCase);

  @override
  void onInit() {
    super.onInit();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    try {
      if (userController.currentUserEmail.value.isEmpty) {
        categories.clear();
        return;
      }

      final loadedCategories = await categoryUseCase.getCategories(
        userController.currentUserEmail.value,
      );

      categories.clear();
      if (loadedCategories.isEmpty) {
        await _loadDefaultCategories();
      } else {
        categories.addAll(loadedCategories);
      }
    } catch (e) {
      print('Error al cargar las categorías: $e');
    }
  }

  Future<void> _loadDefaultCategories() async {
    for (var category in defaultCategories) {
      await categoryUseCase.createCategory(
        userController.currentUserEmail.value,
        category,
      );
    }
    final loadedCategories = await categoryUseCase.getCategories(
      userController.currentUserEmail.value,
    );
    categories.addAll(loadedCategories);
  }

  Future<void> reloadCategories() async {
    await _loadCategories();
  }

  Future<bool> addCategory(
      String name, IconData icon, Color color, BuildContext context) async {
    if (!_categoryExists(name)) {
      final newCategory = CategoryModel(name: name, icon: icon, color: color);
      await categoryUseCase.createCategory(
        userController.currentUserEmail.value,
        newCategory,
      );
      categories.add(newCategory);
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

  Future<bool> updateCategory(CategoryModel category, String newName,
      IconData newIcon, Color newColor, BuildContext context) async {
    if (!_categoryExists(newName) ||
        category.name.toLowerCase() == newName.toLowerCase()) {
      // Primero eliminar la categoría antigua
      await categoryUseCase.deleteCategory(
        userController.currentUserEmail.value,
        category.name,
      );

      // Crear la categoría actualizada
      final updatedCategory = CategoryModel(
        name: newName,
        icon: newIcon,
        color: newColor,
      );
      await categoryUseCase.createCategory(
        userController.currentUserEmail.value,
        updatedCategory,
      );

      // Actualizar la lista local
      final index = categories.indexOf(category);
      if (index != -1) {
        categories[index] = updatedCategory;
        categories.refresh();
      }
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

  Future<void> removeCategory(CategoryModel category) async {
    await categoryUseCase.deleteCategory(
      userController.currentUserEmail.value,
      category.name,
    );
    categories.remove(category);
  }

  bool _categoryExists(String name) {
    return categories
        .any((category) => category.name.toLowerCase() == name.toLowerCase());
  }
}
