// lib/models/category_model.dart
import 'package:flutter/material.dart';

class CategoryModel {
  final String? id; // Campo opcional para almacenar el ID de Firestore
  final String name;
  final IconData icon;
  final Color color;

  CategoryModel({
    this.id,
    required this.name,
    required this.icon,
    required this.color,
  });

  // Método para convertir un CategoryModel en un Map (para guardar en Firestore)
  Map<String, dynamic> toMap() {
    return {
      'nombre': name,
      'icono': icon.codePoint,
      'color': color.value.toRadixString(16), // Guardar el color en hexadecimal
    };
  }

  // Método para crear una instancia de CategoryModel desde un documento de Firestore
  factory CategoryModel.fromMap(Map<String, dynamic> map, String documentId) {
    return CategoryModel(
      id: documentId,
      name: map['nombre'] ?? '',
      icon: IconData(map['icono'], fontFamily: 'MaterialIcons'),
      color: Color(int.parse(map['color'], radix: 16)),
    );
  }
}
