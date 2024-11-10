import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'habit_model.g.dart';

@HiveType(typeId: 0)
class Habit {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String name;
  final String? description;
  @HiveField(2)
  final Color categoryColor;
  @HiveField(3)
  final String categoryName;
  @HiveField(4)
  final bool isQuantifiable;
  @HiveField(5)
  final List<int>? selectedDays; 
  @HiveField(6)
  final bool isDaily;
  @HiveField(7)
  final int? targetCount; 
  @HiveField(8)
  int completedCount;
  @HiveField(9)
  final String? frequencyType; 
  @HiveField(10)
  final String? unit; 
  @HiveField(11)
  final IconData categoryIcon;
  @HiveField(12)
  bool isCompleted;
  @HiveField(13)
  bool isMissed;
  // Propiedades para manejar las rachas
  @HiveField(14)
  int streakCount; // Racha actual
  @HiveField(15)
  int longestStreak; // Racha más larga registrada
  @HiveField(16)
  List<DateTime> completionDates; // Fechas en las que se completó el hábito
  DateTime? lastCompleted; // Última vez que se completó el hábito
  @HiveField(17)
  final int experience; // Add this line
  @HiveField(18)
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

}
