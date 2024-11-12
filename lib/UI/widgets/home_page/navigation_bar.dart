// lib/UI/widgets/home_page/navigation_bar.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habit_app/UI/pages/category/category_page.dart';
import 'package:habit_app/UI/pages/home.dart';
import 'package:habit_app/UI/pages/habits.dart';
import 'package:habit_app/constants.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;

  const CustomBottomNavigationBar({
    super.key,
    required this.currentIndex,
  });

  void _navigateToPage(int index) {
    if (index == currentIndex) return;

    switch (index) {
      case 0:
        Get.offAll(() => HomePage()); // Navegar a la página de Home
        break;
      case 1:
        Get.offAll(() => HabitPage()); // Navegar a la página de Hábitos
        break;
      case 2:
        Get.offAll(() => CategoryPage()); // Navegar a la página de Categorías
        break;
      case 3:
        //Get.offAll(() => const AchievementsPage());
        break;
      case 4:
        //Get.offAll(() => const ChallengesPage());
        break;
      default:
        Get.offAll(() => HomePage());
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
        color: navBarBackgroundColor,
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
        onTap: _navigateToPage,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.schedule, size: 28),
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
        ],
        selectedLabelStyle: navBarTextStyle.copyWith(
          fontSize: 13,
          color: navBarActiveColor,
        ),
        unselectedLabelStyle: navBarTextStyle.copyWith(
          fontSize: 12,
          color: navBarInactiveColor,
        ),
        showUnselectedLabels: true,
      ),
    );
  }
}
