// constants.dart
import 'package:flutter/material.dart';
import 'package:habit_app/models/category_model.dart';

// Colores constantes para la app
const Color primaryColor = Color(0xFF2980B9); // Azul primario
const Color secondaryColor = Color(0xE6E6E6E6); // Fondo claro
const Color errorColor = Color(0xFFC0392B); // Rojo de error
const Color surfaceColor = Color(0xFF34495E); // Color para superficies
const Color onSurfaceColor =
    Colors.grey; // Color para texto/iconos en superficies
const Color onPrimaryColor = Colors.white; // Color del texto sobre el primario

const Color background = Colors.white; // Color del background primario
const kPrimaryLightColor = Color(0xFFF1E6FF);

const double defaultPadding = 16.0;

// Listas de íconos predefinidos para categorías
const List<IconData> iconOptions = [
  Icons.fitness_center,
  Icons.kitchen,
  Icons.book,
  Icons.self_improvement,
  Icons.menu_book,
  Icons.nightlight_round,
  Icons.palette,
  Icons.check_circle_outline,
];

// Lista de colores predefinidos para categorías
const List<Color> colorOptions = [
  Colors.green,
  Colors.orange,
  Colors.purple,
  Colors.teal,
  Colors.blue,
  Colors.indigo,
  Colors.pink,
  Colors.blueGrey,
];

// Lista de categorías predefinidas
List<CategoryModel> defaultCategories = [
  CategoryModel(
      name: 'Deportes', icon: Icons.fitness_center, color: Colors.green),
  CategoryModel(name: 'Cocina', icon: Icons.kitchen, color: Colors.orange),
  CategoryModel(name: 'Estudio', icon: Icons.book, color: Colors.purple),
  CategoryModel(
      name: 'Meditación', icon: Icons.self_improvement, color: Colors.teal),
  CategoryModel(name: 'Lectura', icon: Icons.menu_book, color: Colors.blue),
  CategoryModel(
      name: 'Sueño', icon: Icons.nightlight_round, color: Colors.indigo),
  CategoryModel(name: 'Creatividad', icon: Icons.palette, color: Colors.pink),
  CategoryModel(
      name: 'Organización',
      icon: Icons.check_circle_outline,
      color: Colors.blueGrey),
];
