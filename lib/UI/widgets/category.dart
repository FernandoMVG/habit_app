import 'package:flutter/material.dart';

class CategoryOption extends StatelessWidget {
  final String categoryName;
  final IconData iconData;
  final Color color; // Este sigue siendo el color personalizado de la categoría
  final bool isSelected;
  final VoidCallback onTap;

  const CategoryOption({
    super.key,
    required this.categoryName,
    required this.iconData,
    required this.color,
    this.isSelected = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0), 
        backgroundColor: isSelected ? Theme.of(context).colorScheme.primary : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        side: isSelected
            ? BorderSide(color: Theme.of(context).colorScheme.primary, width: 2)
            : BorderSide(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.3), width: 2),
      ),
      child: Row(
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: color, // Este sigue siendo el color específico de la categoría
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              iconData,
              color: Colors.white, // Ícono blanco para contraste
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Text(
            categoryName,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isSelected ? Theme.of(context).colorScheme.onPrimary : Theme.of(context).textTheme.bodyLarge?.color,
            ),
          ),
        ],
      ),
    );
  }
}
