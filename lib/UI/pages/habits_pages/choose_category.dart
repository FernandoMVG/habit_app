import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habit_app/ui/widgets/category.dart';
import 'package:habit_app/ui/widgets/buttons.dart';
import 'package:habit_app/ui/pages/habits_pages/choose_frequency.dart';

class ChooseCategoryPage extends StatefulWidget {
  const ChooseCategoryPage({super.key});

  @override
  _ChooseCategoryPageState createState() => _ChooseCategoryPageState();
}

class _ChooseCategoryPageState extends State<ChooseCategoryPage> {
  String? selectedCategory;

  final List<Map<String, dynamic>> categories = [
    {'name': 'Salud', 'icon': Icons.health_and_safety, 'color': Colors.green},
    {'name': 'Educación', 'icon': Icons.school, 'color': Colors.blue},
    {'name': 'Trabajo', 'icon': Icons.work, 'color': Colors.orange},
    {'name': 'Deporte', 'icon': Icons.fitness_center, 'color': Colors.red},
    {'name': 'Hogar', 'icon': Icons.home, 'color': Colors.purple},
    {'name': 'Ocio', 'icon': Icons.sports_esports, 'color': Colors.pink},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor:  Theme.of(context).scaffoldBackgroundColor,  // Color de la barra de navegación
        automaticallyImplyLeading: false,  // Oculta el botón de atrás
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [

            // Título centrado
            Center(
              child: Text(
                'Elige una categoría',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 50),

            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,  // Muestra 2 categorías por fila
                  childAspectRatio: 3 / 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final category = categories[index];
                  return CategoryOption(
                    categoryName: category['name'],
                    iconData: category['icon'],
                    color: category['color'],
                    isSelected: selectedCategory == category['name'],
                    onTap: () {
                      setState(() {
                        selectedCategory = category['name'];
                      });
                    },
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const BackButtonWidget(),

                NavigateButton(
                  text: 'Continuar',
                  onPressed: () {
                    if (selectedCategory != null) {
                      // Lógica para continuar
                      Get.to(() => ChooseFrequencyPage(
                            categoryColor: categories.firstWhere((category) => category['name'] == selectedCategory)['color'],
                          ));
                      //print('Categoría seleccionada: $selectedCategory');
                    }
                  },
                  isEnabled: selectedCategory != null,  // El botón solo está habilitado si hay una categoría seleccionada
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
