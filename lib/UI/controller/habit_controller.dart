import 'package:get/get.dart';
import 'package:habit_app/models/habit_model.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'user_controller.dart';

class HabitController extends GetxController {
  // Lista observable de hábitos
  var habits = <Habit>[].obs;

  // Fecha simulada para pruebas de rachas
  var simulatedDate = DateTime.now().obs;

  // Propiedad temporal para almacenar los datos de un hábito en construcción
  Habit? habit;

  final UserController userController = Get.find<UserController>();

  // Inicializa un nuevo hábito antes de que se empiece a construir
  void initHabit({
    required String name, //
    required String categoryName,
    required Color categoryColor,
    required IconData categoryIcon,
    bool isQuantifiable = false,
  }) {
    habit = Habit(
      id: _generateId(),
      name: name,
      categoryName: categoryName,
      categoryColor: categoryColor,
      categoryIcon: categoryIcon,
      isQuantifiable: isQuantifiable,
      completionDates: [],
      experience: Random().nextInt(6) + 5, // 5 to 10 points
    );
  }

  // Setters para configurar atributos del hábito
  void setHabitName(String? name) => habit = habit?.copyWith(name: name);
  
  void setHabitDescription(String? description) =>
      habit = habit?.copyWith(description: description);

  void setFrequency({bool isDaily = false, List<int>? days}) {
    habit = habit?.copyWith(isDaily: isDaily, selectedDays: isDaily ? null : days);
  }

  // Añadir un hábito a la lista observable
  void addHabit() {
    if (habit != null && habit!.name.isNotEmpty) {
      habits.add(habit!);
      habit = null; // Limpiar la instancia temporal
    }
  }

  // Eliminar un hábito
  void removeHabit(Habit habit) {
    habits.removeWhere((h) => h.id == habit.id); // Usar id para encontrar y eliminar el hábito
  }

  // Actualizar un hábito específico
  void updateHabit(Habit habitToUpdate, String newName, String newDescription) {
    final habitIndex = habits.indexWhere((h) => h.id == habitToUpdate.id); // Usar id para encontrar el hábito
    if (habitIndex != -1) {
      // Actualiza el hábito permitiendo que la descripción esté vacía
      habits[habitIndex] = habitToUpdate.copyWith(
        name: newName,
        description: newDescription.isNotEmpty ? newDescription : '',
      );
      habits.refresh(); // Refrescar la lista de hábitos
    }
  }

// Comprobar si hay hábitos
  bool hasHabits() => habits.isNotEmpty;

  // Setters adicionales
  void setUnit(String? unit) => habit = habit?.copyWith(unit: unit);
  void setQuantificationType(String? quantificationType) => habit = habit?.copyWith(frequencyType: quantificationType);
  void setQuantity(int? quantity) => habit = habit?.copyWith(targetCount: quantity);
  void setCategory(String name, Color color, IconData icon) {
    habit = habit?.copyWith(categoryName: name, categoryColor: color, categoryIcon: icon);
  }

  // Reiniciar hábitos al final del día
  void resetDailyHabits() {
    for (var habit in habits) {
      habit.isCompleted = false;
      habit.completedCount = 0;
    }
    habits.refresh();
  }

  // Marcar un hábito como completado, manteniendo lógica para hábitos cuantificables
  void updateHabitCompletion(Habit habitToUpdate) {
    final index = habits.indexWhere((h) => h.id == habitToUpdate.id);
    if (index != -1) {
      habits[index] = habitToUpdate;

      if (!habitToUpdate.isQuantifiable) {
        habits[index].isCompleted = habitToUpdate.isCompleted;
      } else {
        switch (habitToUpdate.frequencyType) {
          case 'Exactamente':
            habits[index].isCompleted = (habitToUpdate.targetCount != null &&
                habitToUpdate.completedCount == habitToUpdate.targetCount!);
            break;
          case 'Al menos':
            habits[index].isCompleted = (habitToUpdate.targetCount != null &&
                habitToUpdate.completedCount >= habitToUpdate.targetCount!);
            break;
          case 'Menos de':
            habits[index].isCompleted = (habitToUpdate.targetCount != null &&
                habitToUpdate.completedCount < habitToUpdate.targetCount!);
            break;
          case 'Más de':
            habits[index].isCompleted = (habitToUpdate.targetCount != null &&
                habitToUpdate.completedCount > habitToUpdate.targetCount!);
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

      if (habits[index].isCompleted) {
        int baseExperience = habits[index].experience;
        int streakMultiplier = (1 + habits[index].streakCount * 0.1).toInt();
        int totalExperience = (baseExperience * streakMultiplier).toInt();
        userController.addExperience(totalExperience);

        habits[index] = habits[index].copyWith(
          lastCompleted: DateTime(simulatedDate.value.year, simulatedDate.value.month, simulatedDate.value.day),
          completionDates: [
            ...habits[index].completionDates,
            DateTime(simulatedDate.value.year, simulatedDate.value.month, simulatedDate.value.day),
          ],
        );
      }

      habits.refresh();
    }
  }

  // Método para alternar el estado completado en hábitos binarios
  void toggleHabitCompletion(Habit habit) {
    if (!habit.isQuantifiable) {
      if (habit.isCompleted) {
        _subtractExperienceForHabit(habit);
      } else {
        _addExperienceForHabit(habit);
      }
      habit.isCompleted = !habit.isCompleted;
      updateHabitCompletion(habit);
    }
  }

  // Método para actualizar el progreso de un hábito cuantificable
  void updateQuantifiableHabitProgress(Habit habit, int updatedCount) {
    habit.completedCount = updatedCount;
    bool wasCompleted = habit.isCompleted;
    habit.isCompleted = habit.isHabitCompleted();
    if (habit.isCompleted && !wasCompleted) {
      _addExperienceForHabit(habit);
    } else if (!habit.isCompleted && wasCompleted) {
      _subtractExperienceForHabit(habit);
    }
    updateHabitCompletion(habit);
  }

  void _addExperienceForHabit(Habit habit) {
    int baseExperience = habit.experience;
    int streakMultiplier = (1 + habit.streakCount * 0.1).toInt();
    int totalExperience = (baseExperience * streakMultiplier).toInt();
    habit.gainedExperience = totalExperience; // Store the gained experience
    userController.addExperience(totalExperience);
  }

  void _subtractExperienceForHabit(Habit habit) {
    if (habit.gainedExperience != null) {
      userController.subtractExperience(habit.gainedExperience!);
      habit.gainedExperience = null; // Reset the gained experience
    }
  }

  // Avanzar la fecha simulada
  void advanceDate() {
    simulatedDate.value = simulatedDate.value.add(const Duration(days: 1));
    _onDateChange();
  }

  // Retroceder la fecha simulada
  void goBackDate() {
    simulatedDate.value = simulatedDate.value.subtract(const Duration(days: 1));
    _onDateChange();
  }

  // Obtener los hábitos de hoy
  List<Habit> getTodayHabits() {
    int today = simulatedDate.value.weekday;
    return habits.where((habit) {
      return habit.isDaily || (habit.selectedDays?.contains(today) ?? false);
    }).toList();
  }

  // Método para verificar las rachas al cambiar la fecha
  void _onDateChange() {
    bool allHabitsCompleted = true;
    for (var habit in habits) {
      if (!habit.isDaily) {
        verifyStreakForSpecificDays(habit);
      } else {
        // Verificamos si el hábito diario fue completado ayer.
        _updateDailyStreak(habit);
      }
      if (!habit.isCompleted) {
        allHabitsCompleted = false;
      }
      habit.isCompleted = false; // Reiniciar estado al cambiar de día
      habit.completedCount = 0;   // Reiniciar progreso de hábitos cuantificables
    }
    if (allHabitsCompleted) {
      userController.addExperience(50); // Daily routine bonus
    }
    habits.refresh();
  }

  //Método para actualizar la racha diaria
  void _updateDailyStreak(Habit habit) {
    DateTime today = DateTime(
      simulatedDate.value.year,
      simulatedDate.value.month,
      simulatedDate.value.day,
    );

    DateTime yesterday = today.subtract(const Duration(days: 1));
    // Verificar si fue completado ayer y si está marcado como completado hoy
    if (habit.lastCompleted != null &&
        isSameDate(habit.lastCompleted!, yesterday) &&
        habit.isCompleted) {
      habit.streakCount++; // Incrementa la racha.
    } else {
      habit.streakCount = 0; 
    }

    // Si el hábito fue completado hoy, actualizamos la última vez completada.
    if (habit.isCompleted) {
      habit.lastCompleted = today;
    } else {
      //print("El hábito no fue completado hoy, no se actualiza la última vez completado.");
    }

    // Actualizamos la racha más larga si es necesario.
    habit.longestStreak = habit.streakCount > habit.longestStreak
        ? habit.streakCount
        : habit.longestStreak;

    habits.refresh();
  }

// Verifica la racha para hábitos de días específicos
void verifyStreakForSpecificDays(Habit habit) {
  if (habit.selectedDays == null || habit.selectedDays!.isEmpty) return;

  // Convertir los días programados a enteros (números de días de la semana)
  List<int> scheduledWeekdays = habit.selectedDays!;

  // Crear un conjunto de fechas de completación para búsqueda eficiente
  Set<DateTime> completionDatesSet = habit.completionDates
      .map((date) => DateTime(date.year, date.month, date.day))
      .toSet();

  int streak = 0;
  DateTime currentDate = DateTime(simulatedDate.value.year, simulatedDate.value.month, simulatedDate.value.day);

  // Iterar hacia atrás desde la fecha actual
  while (true) {
    if (scheduledWeekdays.contains(currentDate.weekday)) {
      // Es un día programado
      if (completionDatesSet.contains(currentDate)) {
        streak++;
      } else {
        //print('Racha reiniciada para "${habit.name}" porque no se completó ${currentDate}');
        break;
      }
    }
    // Retroceder un día
    currentDate = currentDate.subtract(const Duration(days: 1));

  }

  // Actualizar la racha actual y la racha más larga
  habit.streakCount = streak;
  if (streak > habit.longestStreak) {
    habit.longestStreak = streak;
  }

  habits.refresh();
}

  String _generateId() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }

  // Comparar fechas sin considerar la hora
  bool isSameDate(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }
}
