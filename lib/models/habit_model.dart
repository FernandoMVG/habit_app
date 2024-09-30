import 'package:flutter/material.dart';

class Habit {
  final String name;
  final String? description;
  final Color categoryColor;
  final String categoryName;
  final bool isQuantifiable;
  final List<String>? selectedDays; // Días seleccionados si es un hábito semanal
  final bool isDaily; // Si es un hábito diario
  
  // Nuevas propiedades para manejar el progreso del hábito
  final int? targetCount;  // Cantidad objetivo, se usa si el hábito es cuantificable y tiene meta
  int completedCount;  // Progreso actual del hábito
  
  // Nuevas propiedades para manejo avanzado de hábitos cuantificables
  final String? frequencyType;  // Al menos, menos de, exactamente, más de, sin especificar
  final String? unit;  // Unidad opcional (ej. "vasos", "repeticiones")
  final Icon iconData;

  Habit({
    required this.name,
    this.description,
    required this.categoryColor,
    required this.categoryName,
    required this.isQuantifiable,
    this.selectedDays,
    this.isDaily = false,
    this.targetCount,
    this.completedCount = 0,
    this.frequencyType,  // Nueva propiedad para el tipo de frecuencia
    this.unit, String? quantificationType, int? quantity,  // Nueva propiedad para la unidad
    this.iconData = const Icon(Icons.check_circle_outline),
  });

  // Método que calcula si el hábito se ha completado en función del `frequencyType`
  bool isHabitCompleted() {
    if (frequencyType == 'al menos') {
      return completedCount >= targetCount!;
    } else if (frequencyType == 'menos de') {
      return completedCount < targetCount!;
    } else if (frequencyType == 'exactamente') {
      return completedCount == targetCount!;
    } else if (frequencyType == 'más de') {
      return completedCount > targetCount!;
    } else if (frequencyType == 'sin especificar') {
      return true;  // Siempre se puede marcar como completado sin meta específica
    }
    return false;
  }

  // Método que calcula el progreso del hábito en forma de porcentaje
  double get progress {
    if (isQuantifiable && targetCount != null && targetCount! > 0) {
      return completedCount / targetCount!;
    }
    return 0.0;
  }

  // Método para marcar el hábito como completado y aumentar el contador
  void completeHabit() {
    if (isQuantifiable && frequencyType != 'sin especificar') {
      completedCount++;
    }
  }

  // Método para reiniciar el progreso del hábito
  void resetProgress() {
    completedCount = 0;
  }
}
