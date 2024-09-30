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
    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: Colors.white, size: 16),
    );
  }
}
