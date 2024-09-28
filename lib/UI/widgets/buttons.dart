import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CancelButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;

  const CancelButton({
    super.key,
    this.label = 'Cancelar',  // Texto por defecto es "Cancelar"
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomLeft,
      child: ElevatedButton(
        onPressed: onPressed ?? () {
          Get.back();  // Si no se pasa una función, vuelve a la página anterior
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red[100],  // Fondo rojo claro
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),  // Esquinas redondeadas
          ),
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.red,  // Texto en rojo fuerte
          ),
        ),
      ),
    );
  }
}

class BackButtonWidget extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;

  const BackButtonWidget({
    super.key,
    this.label = 'Atrás',  // Texto por defecto es "Atrás"
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed ?? () {
        Get.back();  // Vuelve a la página anterior
      },
      style: ElevatedButton.styleFrom(          
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),  // Esquinas redondeadas
          ),
        ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: Theme.of(context).colorScheme.primary,  // Color primario
            ),
      ),
    );
  }
}