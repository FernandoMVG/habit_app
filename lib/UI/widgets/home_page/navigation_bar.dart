import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habit_app/UI/pages/category/category_page.dart';
import 'package:habit_app/ui/pages/home.dart';
import 'package:habit_app/ui/pages/habits.dart';
import 'package:habit_app/constants.dart'; // Importa las constantes

class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;

  const CustomBottomNavigationBar({
    super.key,
    required this.currentIndex,
  });

  void _navigateToPage(int index) {
    switch (index) {
      case 0:
        Get.to(() => const HomePage()); // Navegar a la página de Home
        break;
      case 1:
        Get.to(() => const HabitPage()); // Navegar a la página de Hábitos
        break;
      case 2:
        Get.to(() => CategoryPage()); // Navegar a la página de Categorías
        break;
      case 3:
        //Get.offAll(() => const AchievementsPage());
        break;
      case 4:
        //Get.offAll(() => const ChallengesPage());
        break;
      default:
        Get.offAll(() => const HomePage());
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final double deviceHeight = MediaQuery.of(context).size.height;

    // Calcula la altura de la barra de navegación
    final double navBarHeight =
        deviceHeight * 0.10; // 10% de la altura del dispositivo

    return Container(
      height: navBarHeight,
      decoration: const BoxDecoration(
        color: navBarBackgroundColor, // Color de fondo de la navbar
        border: Border(
          top: BorderSide(color: cardShadowColor, width: 1.0), // Borde superior
        ),
      ),
      child: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: navBarBackgroundColor,
        selectedItemColor: navBarActiveColor, // Íconos activos
        unselectedItemColor: navBarInactiveColor, // Íconos inactivos
        currentIndex: currentIndex,
        onTap: (index) {
          if (index != currentIndex) {
            _navigateToPage(index);
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.schedule,
                size: 28), // Ajusta el tamaño de los íconos
            label: 'Rutina',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.check_circle, size: 28),
            label: 'Hábitos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.category, size: 28),
            label: 'Categorías',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.flag, size: 28),
            label: 'Retos',
          ),
        ],
        selectedLabelStyle: navBarTextStyle.copyWith(
          fontSize: 13,
          color: navBarActiveColor,
        ), // Estilo para el ítem seleccionado
        unselectedLabelStyle: navBarTextStyle.copyWith(
          fontSize: 12,
          color: navBarInactiveColor,
        ), // Estilo para los ítems no seleccionados
        showUnselectedLabels: true, // Mostrar los ítems no seleccionados
      ),
    );
  }
}
