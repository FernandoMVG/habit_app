import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Habit {
  final String id;
  final String name;
  final String? description;
  final Color categoryColor;
  final String categoryName;
  final bool isQuantifiable;
  final List<int>? selectedDays;
  final bool isDaily;
  final int? targetCount;
  int completedCount;
  final String? frequencyType;
  final String? unit;
  final IconData categoryIcon;
  bool isCompleted;
  bool isMissed;
  int streakCount;
  int longestStreak;
  List<DateTime> completionDates;
  DateTime? lastCompleted;
  final int experience;
  int? gainedExperience;

  // Agregar un campo para registrar el progreso diario
  Map<String, int>
      dailyProgress; // clave: fecha en formato "yyyy-MM-dd", valor: cantidad completada

  Map<String, int> dailyExperience;

  Habit({
    required this.id,
    required this.name,
    this.description,
    required this.categoryColor,
    required this.categoryName,
    required this.categoryIcon,
    required this.isQuantifiable,
    this.selectedDays,
    this.isDaily = false,
    this.targetCount,
    this.completedCount = 0,
    this.frequencyType,
    this.unit,
    this.isCompleted = false,
    this.isMissed = false,
    this.streakCount = 0,
    this.longestStreak = 0,
    this.completionDates = const [],
    this.lastCompleted,
    required this.experience,
    this.gainedExperience,
    this.dailyProgress = const {}, // Inicializar el progreso diario vacío
    this.dailyExperience = const {}, // Inicializar el progreso diario vacío
  });

  Habit copyWith({
    String? id,
    String? name,
    String? description,
    Color? categoryColor,
    String? categoryName,
    bool? isQuantifiable,
    List<int>? selectedDays,
    bool? isDaily,
    int? targetCount,
    int? completedCount,
    String? frequencyType,
    String? unit,
    IconData? categoryIcon,
    bool? isCompleted,
    bool? isMissed,
    int? streakCount,
    int? longestStreak,
    List<DateTime>? completionDates,
    DateTime? lastCompleted,
    int? experience,
    int? gainedExperience,
    Map<String, int>? dailyProgress,
    Map<String, int>? dailyExperience,
  }) {
    return Habit(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      categoryColor: categoryColor ?? this.categoryColor,
      categoryName: categoryName ?? this.categoryName,
      categoryIcon: categoryIcon ?? this.categoryIcon,
      isQuantifiable: isQuantifiable ?? this.isQuantifiable,
      selectedDays: selectedDays ?? this.selectedDays,
      isDaily: isDaily ?? this.isDaily,
      targetCount: targetCount ?? this.targetCount,
      completedCount: completedCount ?? this.completedCount,
      frequencyType: frequencyType ?? this.frequencyType,
      unit: unit ?? this.unit,
      isCompleted: isCompleted ?? this.isCompleted,
      isMissed: isMissed ?? this.isMissed,
      streakCount: streakCount ?? this.streakCount,
      longestStreak: longestStreak ?? this.longestStreak,
      completionDates: completionDates ?? this.completionDates,
      lastCompleted: lastCompleted ?? this.lastCompleted,
      experience: experience ?? this.experience,
      gainedExperience: gainedExperience ?? this.gainedExperience,
      dailyProgress: dailyProgress ?? this.dailyProgress,
      dailyExperience: dailyExperience ?? this.dailyExperience,
    );
  }

  // Método fromFirestore para crear un Habit desde un documento Firestore
  factory Habit.fromFirestore(Map<String, dynamic> data, String id) {
    return Habit(
      id: id,
      name: data['name'] ?? '',
      description: data['description'],
      categoryColor: _colorFromHex(
          data['categoryColor'] ?? '#FFFFFF'), // Convierte String a Color
      categoryName: data['categoryName'] ?? '',
      categoryIcon: IconData(int.parse(data['categoryIcon'] ?? '0xE0C9'),
          fontFamily: 'MaterialIcons'),
      isQuantifiable: data['isQuantifiable'] ?? false,
      selectedDays: data['selectedDays'] != null
          ? List<int>.from(data['selectedDays'])
          : null,
      isDaily: data['isDaily'] ?? false,
      targetCount: data['targetCount'],
      completedCount: data['completedCount'] ?? 0,
      frequencyType: data['frequencyType'],
      unit: data['unit'],
      isCompleted: data['isCompleted'] ?? false,
      isMissed: data['isMissed'] ?? false,
      streakCount: data['streakCount'] ?? 0,
      longestStreak: data['longestStreak'] ?? 0,
      completionDates: data['completionDates'] != null
          ? (data['completionDates'] as List)
              .map((timestamp) => (timestamp as Timestamp).toDate())
              .toList()
          : [],
      lastCompleted: data['lastCompleted'] != null
          ? (data['lastCompleted'] as Timestamp).toDate()
          : null,
      experience: data['experience'] ?? 0,
      gainedExperience: data['gainedExperience'],
      dailyProgress: data['dailyProgress'] != null
          ? Map<String, int>.from(data['dailyProgress'])
          : {},
      dailyExperience: data['dailyExperience'] != null
          ? Map<String, int>.from(data['dailyExperience'])
          : {},
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'categoryColor': _colorToHex(categoryColor), // Convierte Color a String
      'categoryName': categoryName,
      'categoryIcon':
          categoryIcon.codePoint.toString(), // Usa el codePoint del IconData
      'isQuantifiable': isQuantifiable,
      'selectedDays': selectedDays,
      'isDaily': isDaily,
      'targetCount': targetCount,
      'completedCount': completedCount,
      'frequencyType': frequencyType,
      'unit': unit,
      'isCompleted': isCompleted,
      'isMissed': isMissed,
      'streakCount': streakCount,
      'longestStreak': longestStreak,
      'completionDates':
          completionDates.map((date) => Timestamp.fromDate(date)).toList(),
      'lastCompleted':
          lastCompleted != null ? Timestamp.fromDate(lastCompleted!) : null,
      'experience': experience,
      'gainedExperience': gainedExperience,
      'dailyProgress': dailyProgress, // Agregar el progreso diario al mapa
      'dailyExperience': dailyExperience,
    };
  }

  // Convierte un valor de color hexadecimal a Color
  static Color _colorFromHex(String hexColor) {
    hexColor = hexColor.replaceFirst('#', '');
    return Color(int.parse('FF$hexColor', radix: 16));
  }

  // Convierte un Color a un valor hexadecimal en String
  static String _colorToHex(Color color) {
    return '#${color.value.toRadixString(16).substring(2).toUpperCase()}';
  }
}
