import 'package:flutter/material.dart';

//Widget para envolver texto en cajita de color
class BoxDays extends StatelessWidget {
  final Color categoryColor;
  final String text;
  final double fontSize;
  
  const BoxDays({
    super.key,
    required this.categoryColor,
    required this.text,
    this.fontSize = 14,
  });
  
  @override
  Widget build(BuildContext context) {
    return Container(
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
            decoration: BoxDecoration(
              color: categoryColor.withOpacity(0.1),  // Fondo suave basado en el color de la categoría
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Text(
              text,
              style: TextStyle(
                fontSize: fontSize,
                fontWeight: Theme.of(context).textTheme.bodyLarge?.fontWeight,
                color: categoryColor,
              ),
            ),
          );
  }
}