// lib/pages/habits_pages/choose_category_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habit_app/UI/controller/category_controller.dart';
import 'package:habit_app/UI/controller/habit_controller.dart';
import 'package:habit_app/UI/pages/habits_pages/choose_frequency.dart';
import '/responsive.dart'; // Importar el widget Responsive
import '/UI/widgets/shared/buttons.dart';

class ChooseCategoryPage extends StatefulWidget {
  const ChooseCategoryPage({super.key});

  @override
  State<ChooseCategoryPage> createState() => _ChooseCategoryPageState();
}

class _ChooseCategoryPageState extends State<ChooseCategoryPage> {
  String? selectedCategory;
  final HabitController habitController = Get.find<HabitController>();
  final CategoryController categoryController =
      Get.find<CategoryController>(); // Accedemos al controlador de categorías

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      // Quitamos el AppBar y mantenemos solo el cuerpo
      body: Obx(() {
        // Verificar si hay categorías disponibles
        if (categoryController.categories.isEmpty) {
          return const Center(
            child: Text(
              'No hay categorías disponibles... Prueba agregando una nueva :D',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          );
        } else {
          return Column(
            children: [
              // Cuadrícula de categorías
              Expanded(
                child: Responsive(
                  mobile: _buildCategoryGrid(context,
                      crossAxisCount: 3), // 3 columnas en móvil
                  tablet: _buildCategoryGrid(context,
                      crossAxisCount: 4), // 4 columnas en tablet
                  desktop: _buildCategoryGrid(context,
                      crossAxisCount: 5), // 5 columnas en escritorio
                ),
              ),
              // Botón de "Continuar" en la parte inferior
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16.0, vertical: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Botón "Atrás"
                    const BackButtonWidget(),
                    // Botón "Continuar"
                    NavigateButton(
                      text: 'Continuar',
                      onPressed: () {
                        if (selectedCategory != null) {
                          // Obtener la categoría seleccionada
                          final selectedCategoryData = categoryController
                              .categories
                              .firstWhere((category) =>
                                  category.name == selectedCategory);

                          // Establecer la categoría seleccionada en el controlador de hábitos
                          habitController.setCategory(
                            selectedCategoryData.name,
                            selectedCategoryData.color,
                            selectedCategoryData.icon,
                          );

                          // Navegar a la página de selección de frecuencia
                          Get.to(() => ChooseFrequencyPage(
                                categoryColor: selectedCategoryData.color,
                              ));
                        }
                      },
                      isEnabled: selectedCategory !=
                          null, // Habilitar solo si hay una categoría seleccionada
                    ),
                  ],
                ),
              ),
            ],
          );
        }
      }),
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
            setState(() {
              selectedCategory =
                  category.name; // Guardar la categoría seleccionada
            });
          },
          child: Container(
            decoration: BoxDecoration(
              color: category.color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: selectedCategory == category.name
                    ? category.color
                    : category.color.withOpacity(0.5),
                width: selectedCategory == category.name ? 3 : 2,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(category.icon, color: category.color, size: 40),
                const SizedBox(height: 8),
                Text(
                  category.name,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: selectedCategory == category.name
                        ? category.color
                        : Colors.grey[700],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
