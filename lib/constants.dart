import 'package:flutter/material.dart';
import 'package:habit_app/models/category_model.dart';

// Paleta de colores
const Color primaryColor = Color(0xFF2980B9); // Azul primario
const Color secondaryColor = Color(0xFFF5F5F5); // Fondo claro
const Color errorColor = Color(0xFFC0392B); // Rojo de error
const Color surfaceColor = Color(0xFF34495E); // Superficie oscura
const Color onSurfaceColor = Colors.grey; // Texto/iconos sobre superficies
const Color onPrimaryColor = Colors.white; // Texto sobre el primario
const Color blackColor = Colors.black87; // Nuevo: Texto principal en negro
const kPrimaryLightColor = Color(0xFFF1E6FF);

// Colores para resaltar ítems activos/inactivos en Navigation Bar
const Color navBarBackgroundColor = Color(0xFFF8F9FA); // Fondo de la barra
const Color navBarActiveColor = Color(0xFF2980B9); // Ítems activos
const Color navBarInactiveColor = Colors.grey; // Ítems inactivos
const Color navBarItemColor = Color(0xFF2C3E50); // Texto/icono en navbar

// Fondo claro para las Cards
const Color cardBackgroundColor = Color(0xFFFDFDFD); // Fondo claro para resaltar
const Color cardShadowColor = Color(0xFFE0E0E0); // Sombra ligera

// Colores adicionales
const Color accentColor = Color(0xFF27AE60); // Verde para categorías
const Color recordColor = Colors.orange; // Naranja para la racha actual
const Color trophyColor = Colors.blueAccent; // Azul para la racha más larga

// Padding por defecto
const double defaultPadding = 16.0;
const double defaultRadius = 15.0;

// Estilos de texto parametrizados
const TextStyle titleTextStyle = TextStyle(
  fontSize: 36,
  fontWeight: FontWeight.bold,
  color: blackColor,
);

const TextStyle bodyTextStyle = TextStyle(
  fontSize: 16,
  color: blackColor,
);

const TextStyle subtitleTextStyle = TextStyle(
  fontSize: 18,
  color: Colors.grey,
);

const TextStyle labelTextStyle = TextStyle(
  fontSize: 14,
  fontWeight: FontWeight.bold,
  color: onPrimaryColor,
);

const TextStyle navBarTextStyle = TextStyle(
  fontSize: 14,
  fontWeight: FontWeight.w500,
  color: navBarItemColor,
);
