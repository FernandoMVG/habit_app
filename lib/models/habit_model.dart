import 'package:flutter/material.dart';

class Habit {
  final String name;
  final String? description;
  final Color categoryColor;
  final String categoryName;
  late final bool isQuantifiable;
  final List<String>? selectedDays; // Días seleccionados si es un hábito semanal
  final bool isDaily; // Si es un hábito diario
  
  // Nuevas propiedades para manejar el progreso del hábito
  final int? targetCount;  // Cantidad objetivo, se usa si el hábito es cuantificable y tiene meta
  int completedCount;  // Progreso actual del hábito
  
  // Nuevas propiedades para manejo avanzado de hábitos cuantificables
  final String? frequencyType;  // Al menos, menos de, exactamente, más de, sin especificar
  final String? unit;  // Unidad opcional (ej. "vasos", "repeticiones")
  final IconData categoryIcon;

  //Nuevas propiedades para manejar el estado de completación del hábito
  bool isCompleted;
  bool isMissed; 

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
    this.frequencyType,  // Nueva propiedad para el tipo de frecuencia
    this.unit, String? quantificationType, int? quantity,
    this.isCompleted = false,
    this.isMissed = false, 
  });

  // Método copyWith para copiar el hábito y actualizar solo ciertos atributos
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
        return true;  // Siempre se puede marcar como completado sin meta específica
      default:
        return false;
    }
  }

  // Método que calcula el progreso del hábito en forma de porcentaje
  double get progress {
    if (isQuantifiable && targetCount != null && targetCount! > 0) {
      return completedCount / targetCount!;
    }
    return isCompleted ? 1.0 : 0.0;
  }

  // Método para marcar el hábito como completado y aumentar el contador
  void completeHabit() {
    if (isQuantifiable && targetCount != null) {
      if (isHabitCompleted()) {
        isCompleted = true;  // Marcamos como completado si la meta se alcanza
      } else {
        isCompleted = false; // Si no se ha alcanzado, no está completado
      }
    } else {
      toggleCompleted(); // Para hábitos binarios
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
      completeHabit(); // Revisa si está completado después de cada incremento
    }
  }

}
