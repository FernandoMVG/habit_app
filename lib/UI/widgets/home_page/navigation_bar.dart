import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habit_app/ui/pages/home.dart';
import 'package:habit_app/ui/pages/habits.dart';


class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;

  const CustomBottomNavigationBar({
    super.key,
    required this.currentIndex,
  });

  void _navigateToPage(int index) {
    switch (index) {
      case 0:
        Get.to(() => const HomePage());
        break;
      case 1:
        Get.to(() => const HabitPage());
        break;
      case 2:
        //Get.to(() => const CategoriesPage());
        break;
      case 3:
        //Get.to(() => const AchievementsPage());
        break;
      case 4:
        //Get.to(() => const ChallengesPage());
        break;
      default:
        Get.to(() => const HomePage());
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Obtén la altura del dispositivo
    final double deviceHeight = MediaQuery.of(context).size.height;

    // Calcula la altura del BottomNavigationBar en función de la altura del dispositivo
    final double navBarHeight = deviceHeight * 0.10; // Por ejemplo, 10% de la altura del dispositivo

    return Container(
      height: navBarHeight,
      padding: const EdgeInsets.only(top: 10),  // Añade espacio superior para aumentar la altura
      child: BottomNavigationBar(
        backgroundColor: Theme.of(context).colorScheme.surface, // Color de fondo
        type: BottomNavigationBarType.fixed,  // Fija los íconos sin animación
        selectedItemColor: Theme.of(context).colorScheme.onSurface,  // Íconos seleccionados en blanco
        unselectedItemColor: Colors.grey[400],  // Íconos no seleccionados en gris claro
        currentIndex: currentIndex,  // Índice seleccionado
        onTap: (index) {
          if (index != currentIndex) {
            _navigateToPage(index);
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home, size: 30),  // Tamaño del ícono
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
        selectedLabelStyle: const TextStyle(fontSize: 14),  // Tamaño del texto seleccionado
        unselectedLabelStyle: const TextStyle(fontSize: 12),  // Tamaño del texto no seleccionado
      ),
    );
  }
}
