// lib/pages/category_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habit_app/UI/pages/category/create_category_page.dart';
import 'package:habit_app/UI/pages/category/edit_category_page.dart';
import 'package:habit_app/ui/controller/category_controller.dart';
import 'package:habit_app/ui/widgets/navigation_bar.dart';

class CategoryPage extends StatelessWidget {
  final CategoryController categoryController = Get.put(CategoryController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Categorías'),
        backgroundColor: Theme.of(context).colorScheme.surface,
      ),
      body: Obx(() {
        // Verificar si hay categorías creadas
        if (categoryController.categories.isEmpty) {
          return const Center(
            child: Text(
              'No tienes ninguna categoría... Prueba agregando una nueva :D',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          );
        } else {
          // Mostrar la lista de categorías
          return ListView.builder(
            itemCount: categoryController.categories.length,
            itemBuilder: (context, index) {
              final category = categoryController.categories[index];
              return ListTile(
                onTap: () {
                  // Al hacer clic en cualquier parte de la categoría, navegar a la edición
                  Get.to(() => EditCategoryPage(category: category));
                },
                leading: Icon(category.icon,
                    color: category.color), // Mostrar ícono y color
                title: Text(
                  category.name,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete,
                      color: Colors.red), // Ícono de eliminar
                  onPressed: () {
                    // Eliminar la categoría
                    categoryController.removeCategory(category);
                  },
                ),
              );
            },
          );
        }
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navegar a la página de creación de nueva categoría
          Get.to(() => const CreateCategoryPage());
        },
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: 2, // Marcar la página de "Categorías"
        onTap: (index) {
          // Aquí puedes manejar la navegación entre las diferentes páginas
          if (index == 0) {
            Get.back(); // Navegar de vuelta a HomePage
          }
        },
      ),
    );
  }
}
