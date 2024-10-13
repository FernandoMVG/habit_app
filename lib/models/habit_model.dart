import 'package:flutter/material.dart';

class Habit {
  final String name;
  final String? description;
  final Color categoryColor;
  final String categoryName;
  final bool isQuantifiable;
  final List<String>? selectedDays; 
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

  Habit({
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
  });

  Habit copyWith({
    String? name,
    String? description,
    Color? categoryColor,
    String? categoryName,
    bool? isQuantifiable,
    List<String>? selectedDays,
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
  }) {
    return Habit(
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
    );
  }

  // Método que calcula si el hábito cuantificable se ha completado en función de `frequencyType`
  bool isHabitCompleted() {
    switch (frequencyType) {
      case 'al menos':
        return completedCount >= targetCount!;
      case 'menos de':
        return completedCount < targetCount!;
      case 'exactamente':
        return completedCount == targetCount!;
      case 'más de':
        return completedCount > targetCount!;
      case 'sin especificar':
        return true;
      default:
        return false;
    }
  }

  // Método para marcar el hábito como completado y aumentar el contador
  void completeHabit() {
    if (isQuantifiable && targetCount != null) {
      isCompleted = isHabitCompleted();
    } else {
      toggleCompleted();
    }
  }

  // Método para reiniciar el progreso del hábito
  void resetProgress() {
    completedCount = 0;
    isCompleted = false;
  }

   // Método para alternar el estado completado en hábitos binarios
  void toggleCompleted() {
    if (!isQuantifiable) {
      isCompleted = !isCompleted;
    }
  }

  // Método que incrementa el progreso y verifica si se ha completado
  void incrementProgress() {
    if (isQuantifiable && completedCount < targetCount!) {
      completedCount++;
      completeHabit();
    }
  }

  // Incrementa la racha si el hábito se completó en el día correspondiente
  void incrementStreak() {
    DateTime now = DateTime.now();
    if (lastCompleted != null &&
        now.difference(lastCompleted!).inDays == 1) {
      streakCount++;
    } else {
      streakCount = 1;
    }
    lastCompleted = now;
    completionDates.add(now);

    if (streakCount > longestStreak) {
      longestStreak = streakCount;
    }
  }

  // Reinicia la racha si el hábito no se completó en los días esperados
  void resetStreak() {
    streakCount = 0;
  }
}
