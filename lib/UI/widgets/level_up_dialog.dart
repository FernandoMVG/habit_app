import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habit_app/UI/controller/user_controller.dart';
import 'package:habit_app/constants.dart';

class LevelUpDialog extends StatelessWidget {
  final int level;
  
  const LevelUpDialog({
    super.key,
    required this.level,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final userController = Get.find<UserController>();
    final currentExp = userController.experience.value;
    final nextLevelExp = (level) * 100;
    final expNeeded = nextLevelExp - currentExp;
    
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      child: Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: theme.colorScheme.onPrimary,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 10,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  const Icon(
                    Icons.star,
                    size: 80,
                    color: Colors.amber,
                  ),
                  Positioned(
                    right: -10,
                    top: -10,
                    child: Icon(
                      Icons.star,
                      size: 30,
                      color: Colors.amber.withOpacity(0.6),
                    ),
                  ),
                  Positioned(
                    left: -5,
                    bottom: -5,
                    child: Icon(
                      Icons.star,
                      size: 25,
                      color: Colors.amber.withOpacity(0.4),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Text(
                '¡NIVEL COMPLETADO!',
                style: titleTextStyle.copyWith(
                  fontSize: 28,
                  color: blackColor,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Has alcanzado el nivel $level',
                style: subtitle2TextStyle.copyWith(
                  color: blackColor,
                  fontSize: 22,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Siguiente nivel: ${level + 1}',
                style: bodyTextStyle.copyWith(
                  color: blackColor,
                  fontSize: 18,
                ),
              ),
              Text(
                'Experiencia actual: $currentExp XP',
                style: bodyTextStyle.copyWith(
                  color: blackColor,
                  fontSize: 16,
                ),
              ),
              Text(
                'Experiencia para nivel ${level + 1}: $nextLevelExp XP',
                style: bodyTextStyle.copyWith(
                  color: blackColor,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Te faltan: $expNeeded XP',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                style: theme.elevatedButtonTheme.style?.copyWith(
                  padding: WidgetStateProperty.all(
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  ),
                ),
                onPressed: () => Navigator.pop(context),
                child: Text(
                  '¡Seguir mejorando!',
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: theme.colorScheme.onPrimary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
