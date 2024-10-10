import 'package:flutter/material.dart';

class CustomFabButton extends StatelessWidget {
  final VoidCallback onPressed;
  
  const CustomFabButton({
    super.key, 
    required this.onPressed
    });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: Theme.of(context).colorScheme.primary,
      foregroundColor: Colors.white,
      onPressed: onPressed,
      child: const Icon(Icons.add, size: 30),
    );
  }
}
