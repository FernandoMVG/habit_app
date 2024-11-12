import 'package:flutter/material.dart';
import 'package:habit_app/constants.dart';

class CustomProgressBar extends StatelessWidget {
  final double progress;

  const CustomProgressBar({
    super.key,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    // Asegura que el progreso no supere 1.0 (100%)
    final adjustedProgress = progress > 1.0 ? 1.0 : progress;

    return Row(
      children: [
        Expanded(
          child: Container(
            height: 8, // Altura de la barra
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              color: navBarInactiveColor, // Fondo gris claro
            ),
            child: FractionallySizedBox(
              widthFactor: adjustedProgress,
              alignment: Alignment.centerLeft,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [primaryColor, primaryColor.withOpacity(0.7)],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 8), // Espacio entre la barra y el porcentaje
        Text(
          '${(adjustedProgress * 100).toStringAsFixed(0)}%',
          style: bodyTextStyle.copyWith(
            color: primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
