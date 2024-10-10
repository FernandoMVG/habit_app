import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habit_app/ui/pages/home.dart';

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
          Get.off(const HomePage()); // Elimina el 
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

class NavigateButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isEnabled;  // Esto permitirá habilitar o deshabilitar el botón
  
  const NavigateButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isEnabled = true, // Por defecto el botón está habilitado
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isEnabled ? onPressed : null,  // Ejecuta la función pasada o desactiva el botón
      style: ElevatedButton.styleFrom(
        foregroundColor: Theme.of(context).colorScheme.onPrimary, 
        backgroundColor: Theme.of(context).colorScheme.primary,  // Color del texto en el botón
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }
}