import 'package:get/get.dart';
import 'package:habit_app/models/habit_model.dart';
import 'package:flutter/material.dart';

class HabitController extends GetxController {
  // Lista observable de hábitos
  var habits = <Habit>[].obs;

  // Propiedad temporal para almacenar los datos de un hábito en construcción
  Habit? habit;

  // Inicializa un nuevo hábito antes de que se empiece a construir
  void initHabit({required String name, required String categoryName, required Color categoryColor, required IconData categoryIcon, bool isQuantifiable = false}) {
    habit = Habit(
      name: name,
      categoryName: categoryName,
      categoryColor: categoryColor,
      categoryIcon: categoryIcon,
      isQuantifiable: isQuantifiable,
    );
  }

  // Método para establecer el nombre del hábito
  void setHabitName(String? name) {
    habit = habit?.copyWith(name: name);
  }

  // Método para establecer la descripción del hábito
  void setHabitDescription(String? description) {
    habit = habit?.copyWith(description: description);
  }

  // Método para establecer la frecuencia del hábito (semanal o diario)
  void setFrequency({bool isDaily = false, List<String>? days}) {
    habit = habit?.copyWith(
      isDaily: isDaily,
      selectedDays: isDaily ? null : days,
    );
  }

  // Método para añadir un hábito a la lista observable
  void addHabit() {
    if (habit != null && habit!.name.isNotEmpty) {
      habits.add(habit!);
      habit = null; // Limpiar la instancia temporal
    }
  }

  // Método para eliminar un hábito
  void removeHabit(Habit habit) {
    habits.remove(habit);
  }

  // Método para actualizar un hábito
  void updateHabit(Habit habitToUpdate, String newName, String newDescription) {
    final habitIndex = habits.indexOf(habitToUpdate);
    if (habitIndex != -1) {
      habits[habitIndex] = habitToUpdate.copyWith(
        name: newName,
        description: newDescription,
      );
      habits.refresh(); // Refresca la lista para actualizar la UI
    }
  }

  // Método para reiniciar el progreso de un hábito
  void resetProgress(Habit habitToReset) {
    habitToReset.resetProgress();
    habits.refresh(); // Refresca la lista para actualizar la UI
  }

  // Método para verificar si hay hábitos
  bool hasHabits() {
    return habits.isNotEmpty;
  }

  // Método para obtener la unidad del hábito
  void setUnit(String? unit) {
    habit = habit?.copyWith(unit: unit);
  }

  void setQuantificationType(String? quantificationType) {
    habit = habit?.copyWith(frequencyType: quantificationType);
  }

  void setQuantity(int? quantity) {
    habit = habit?.copyWith(targetCount: quantity);
  }

  // Método para establecer la categoría del hábito
  void setCategory(String name, Color color, IconData icon) {
    habit = habit?.copyWith(
      categoryName: name,
      categoryColor: color,
      categoryIcon: icon,
    );
  }

  // Método para reiniciar los hábitos al final del día
  void resetDailyHabits() {
    for (var habit in habits) {
      if (habit.isCompleted == false && habit.completedCount == 0) {
        habit.isMissed = true; // Marcar como incompleto
      } else {
        habit.isMissed = false;
      }
      habit.isCompleted = false;
      habit.completedCount = 0;
    }
    habits.refresh();
  }

  // Método para obtener los hábitos de la rutina diaria
  List<Habit> getTodayHabits() {
    DateTime now = DateTime.now();
    String today = _weekdayToString(now.weekday);

    return habits.where((habit) {
      if (habit.isDaily) {
        return true;
      } else if (habit.selectedDays != null) {
        return habit.selectedDays!.contains(today);
      }
      return false;
    }).toList();
  }

  String _weekdayToString(int weekday) {
    switch (weekday) {
      case DateTime.monday:
        return 'Lun';
      case DateTime.tuesday:
        return 'Mar';
      case DateTime.wednesday:
        return 'Mié';
      case DateTime.thursday:
        return 'Jue';
      case DateTime.friday:
        return 'Vie';
      case DateTime.saturday:
        return 'Sáb';
      case DateTime.sunday:
        return 'Dom';
      default:
        return '';
    }
  }

// Método para actualizar el estado de completado de un hábito
void updateHabitCompletion(Habit habitToUpdate) {
  final index = habits.indexWhere((h) => h.name == habitToUpdate.name);
  if (index != -1) {
    habits[index] = habitToUpdate;
    if (!habitToUpdate.isQuantifiable) {
      habits[index].isCompleted = habitToUpdate.isCompleted;
    } else {
      switch (habitToUpdate.frequencyType) {
        case 'Exactamente':
          habits[index].isCompleted = (habitToUpdate.targetCount != null && habitToUpdate.completedCount == habitToUpdate.targetCount!);
          break;
        case 'Al menos':
          habits[index].isCompleted = (habitToUpdate.targetCount != null && habitToUpdate.completedCount >= habitToUpdate.targetCount!);
          break;
        case 'Menos de':
          habits[index].isCompleted = (habitToUpdate.targetCount != null && habitToUpdate.completedCount < habitToUpdate.targetCount!);
          break;
        case 'Más de':
          habits[index].isCompleted = (habitToUpdate.targetCount != null && habitToUpdate.completedCount > habitToUpdate.targetCount!);
          break;
        case 'Sin especificar':
          habits[index].isCompleted = true;
          break;
        case null:
          habits[index].isCompleted = false;
          break;
        default:
          habits[index].isCompleted = false;
      }
    }
    habits.refresh();
  }
}


  // Método para incrementar el progreso de un hábito y verificar si está completado
  void incrementHabitProgress(Habit habit) {
    habit.completedCount++;
    updateHabitCompletion(habit);
  }
}


