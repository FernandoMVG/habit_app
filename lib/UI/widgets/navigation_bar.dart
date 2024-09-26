import 'package:flutter/material.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavigationBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 10),  // Añade espacio superior para aumentar la altura
      child: BottomNavigationBar(
        backgroundColor: const Color(0xFF2C3E50), // Color de fondo
        type: BottomNavigationBarType.fixed,  // Fija los íconos sin animación
        selectedItemColor: Colors.white,  // Íconos seleccionados en blanco
        unselectedItemColor: Colors.grey[400],  // Íconos no seleccionados en gris claro
        currentIndex: currentIndex,  // Índice seleccionado
        onTap: onTap,  // Función de tap
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
