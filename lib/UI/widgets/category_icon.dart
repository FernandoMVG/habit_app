import 'package:flutter/material.dart';

class CategoryIconWidget extends StatelessWidget {
  final IconData icon;
  final Color color;

  const CategoryIconWidget({
    super.key,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    // Asegúrate de imprimir estos valores para depurar
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Icon(icon, color: Colors.white, size: 25),
    );
  }
}
