import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Add this import

/// CustomTextField: Un campo de texto reutilizable y personalizable.
class CustomTextField extends StatelessWidget {
  final TextEditingController controller; // Controlador del campo de texto.
  final String labelText; // Texto del label.
  final bool isObscureText; // Define si el texto es oculto (ej. contraseñas).
  final TextInputType keyboardType; // Tipo de entrada de teclado.
  final bool enabled; // Define si el campo está habilitado.
  final double borderRadius; // Radio de los bordes.
  final List<TextInputFormatter>? inputFormatters; // Add this parameter

  /// Constructor del `CustomTextField`.
  const CustomTextField({
    super.key,
    required this.controller,
    required this.labelText,
    this.isObscureText = false, // False por defecto (texto visible).
    this.keyboardType = TextInputType.text, // Tipo de texto por defecto.
    this.enabled = true, // Habilitado por defecto.
    this.borderRadius = 15.0, // Radio de los bordes por defecto.
    this.inputFormatters, // Add this to constructor
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      enabled: enabled, // Habilita o deshabilita el campo.
      controller: controller, // Controlador del campo de texto.
      obscureText: isObscureText, // Define si el texto es oculto.
      keyboardType: keyboardType, // Define el tipo de entrada del teclado.
      inputFormatters: inputFormatters, // Add this to TextField
      decoration: InputDecoration(
        labelText: labelText, // Texto del label.
        labelStyle: const TextStyle(
          fontWeight: FontWeight.bold, // Texto del label en negrita.
          color: Colors.black, // Color negro para el label.
        ),
        fillColor: Colors.white, // Fondo blanco del campo de texto.
        filled: true, // Define que el campo tiene fondo.
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
          borderSide: const BorderSide(
            color: Colors.black, // Borde en color negro.
            width: 2.0, // Ancho del borde.
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
          borderSide: const BorderSide(
            color: Colors.black, // Borde en color negro.
            width: 2.0, // Ancho del borde.
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.primary, // Color primario en foco.
            width: 2.0, // Ancho del borde en foco.
          ),
        ),
      ),
      style: const TextStyle(
        fontWeight: FontWeight.bold, // Texto del campo en negrita.
        color: Colors.black, // Texto en color negro.
      ),
    );
  }
}
