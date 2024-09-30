// lib/widgets/navigation_bar.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habit_app/ui/pages/home.dart'; // Página Home
import 'package:habit_app/ui/pages/habits.dart'; // Página de Hábitos
import '../pages/category/category_page.dart'; // Página de Categorías
// Puedes agregar otras páginas para Logros y Retos si ya las tienes.

class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
          top: 10), // Añade espacio superior para aumentar la altura
      child: BottomNavigationBar(
        backgroundColor:
            Theme.of(context).colorScheme.surface, // Color de fondo
        type: BottomNavigationBarType.fixed, // Fija los íconos sin animación
        selectedItemColor:
            Theme.of(context).colorScheme.onSurface, // Íconos seleccionados
        unselectedItemColor: Colors.grey[400], // Íconos no seleccionados
        currentIndex: currentIndex, // Índice seleccionado
        onTap: (index) {
          if (index == 0) {
            Get.to(() => const HomePage()); // Navegar a la página de Home
          } else if (index == 1) {
            Get.to(() => const HabitPage()); // Navegar a la página de Hábitos
          } else if (index == 2) {
            Get.to(() => CategoryPage()); // Navegar a la página de Categorías
          } else if (index == 3) {
            // Navegar a la página de Logros (debes crear o importar esta página)
            // Get.to(() => const AchievementsPage());
          } else if (index == 4) {
            // Navegar a la página de Retos (debes crear o importar esta página)
            // Get.to(() => const ChallengesPage());
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home, size: 30),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.check_circle, size: 30),
            label: 'Hábitos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.category, size: 30),
            label: 'Categorías',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star, size: 30),
            label: 'Logros',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.flag, size: 30),
            label: 'Retos',
          ),
        ],
        selectedLabelStyle:
            const TextStyle(fontSize: 14), // Tamaño del texto seleccionado
        unselectedLabelStyle:
            const TextStyle(fontSize: 12), // Tamaño del texto no seleccionado
      ),
    );
  }
}
