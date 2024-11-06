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
  // Propiedades para manejar las rachas
  int streakCount; // Racha actual
  int longestStreak; // Racha más larga registrada
  List<DateTime> completionDates; // Fechas en las que se completó el hábito
  DateTime? lastCompleted; // Última vez que se completó el hábito
  final int experience; // Add this line
  int? gainedExperience; // Add this line

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
    required this.experience, // Add this line
    this.gainedExperience, // Add this line
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
    int? experience, // Add this line
    int? gainedExperience, // Add this line
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
      streakCount: streakCount ?? this.streakCount,  // Aseguramos que no sea null
      longestStreak: longestStreak ?? this.longestStreak,  // Aseguramos que no sea null
      completionDates: completionDates ?? this.completionDates,
      lastCompleted: lastCompleted ?? this.lastCompleted,
      experience: experience ?? this.experience, // Add this line
      gainedExperience: gainedExperience ?? this.gainedExperience, // Add this line
    );
  }

  // Método que calcula si el hábito cuantificable se ha completado en función de `frequencyType`
  bool isHabitCompleted() {
    switch (frequencyType) {
      case 'Al menos':
        return completedCount >= targetCount!;
      case 'Menos de':
        return completedCount < targetCount!;
      case 'Exactamente':
        return completedCount == targetCount!;
      case 'Más de':
        return completedCount > targetCount!;
      case 'Sin especificar':
        return true;
      default:
        return false;
    }
  }

  // Eliminar el método toggleCompleted
  // void toggleCompleted() {
  //   if (!isQuantifiable) {
  //     isCompleted = !isCompleted;
  //   }
  // }
}
