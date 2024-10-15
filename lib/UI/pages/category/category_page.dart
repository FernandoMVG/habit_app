// lib/pages/category_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habit_app/UI/controller/category_controller.dart';
import 'package:habit_app/UI/pages/category/create_category_page.dart';
import 'package:habit_app/UI/pages/category/edit_category_page.dart';
import 'package:habit_app/UI/widgets/home_page/navigation_bar.dart';
import 'package:habit_app/UI/widgets/shared/app_bar.dart';
import '/responsive.dart'; // Importar el widget Responsive

class CategoryPage extends StatelessWidget {
  final CategoryController categoryController = Get.find<CategoryController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: Obx(() {
        if (categoryController.categories.isEmpty) {
          return const Center(
            child: Text(
              'No tienes ninguna categoría... Prueba agregando una nueva :D',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          );
        } else {
          return Responsive(
            mobile: _buildCategoryGrid(context,
                crossAxisCount: 3), // 3 columnas en móvil
            tablet: _buildCategoryGrid(context,
                crossAxisCount: 4), // 4 columnas en tablet
            desktop: _buildCategoryGrid(context,
                crossAxisCount: 5), // 5 columnas en escritorio
          );
        }
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(() => const CreateCategoryPage());
        },
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: 2,
      ),
    );
  }

  // Método para construir la cuadrícula de categorías
  Widget _buildCategoryGrid(BuildContext context,
      {required int crossAxisCount}) {
    return GridView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: categoryController.categories.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount, // Número de columnas
        crossAxisSpacing: 16.0, // Espacio entre columnas
        mainAxisSpacing: 16.0, // Espacio entre filas
        childAspectRatio: 1, // Relación de aspecto de las celdas
      ),
      itemBuilder: (context, index) {
        final category = categoryController.categories[index];
        return GestureDetector(
          onTap: () {
            Get.to(() => EditCategoryPage(category: category));
          },
          child: Container(
            decoration: BoxDecoration(
              color: category.color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: category.color, width: 2),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(category.icon, color: category.color, size: 40),
                const SizedBox(height: 8),
                Text(
                  category.name,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
