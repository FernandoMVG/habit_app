import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final bool isObscureText;  // Útil si quieres usarlo para contraseñas o texto normal
  final TextInputType keyboardType;
  final bool enabled;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.labelText,
    this.isObscureText = false,  // False por defecto
    this.keyboardType = TextInputType.text,  // Texto por defecto
    this.enabled = true,  // True por defecto
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      enabled: enabled,
      controller: controller,
      obscureText: isObscureText,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.black,  // Texto en negrita y color negro
        ),
        fillColor: Colors.white, //color del fondo del textfield
        filled: true,
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          borderSide: BorderSide(
            color: Colors.black,  // Borde en color negro y grueso
            width: 2.0,
          ),
        ),
        enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          borderSide: BorderSide(
            color: Colors.black,  // Borde en color negro y grueso
            width: 2.0,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.primary,  // Borde de color primario del esquema de colores cuando esté en foco
            width: 2.0,
          ),
        ),
      ),
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        color: Colors.black,  // Texto dentro del campo en negrita y negro
      ),
    );
  }
}
