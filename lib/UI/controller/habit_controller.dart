import 'package:get/get.dart';
import 'package:habit_app/models/habit_model.dart';
import 'package:flutter/material.dart';

class HabitController extends GetxController {
  // Lista observable de hábitos
  var habits = <Habit>[].obs;

  // Fecha simulada para pruebas de rachas
  var simulatedDate = DateTime.now().obs;

  // Propiedad temporal para almacenar los datos de un hábito en construcción
  Habit? habit;

  // Inicializa un nuevo hábito antes de que se empiece a construir
  void initHabit({
    required String name,
    required String categoryName,
    required Color categoryColor,
    required IconData categoryIcon,
    bool isQuantifiable = false,
  }) {
    habit = Habit(
      name: name,
      categoryName: categoryName,
      categoryColor: categoryColor,
      categoryIcon: categoryIcon,
      isQuantifiable: isQuantifiable,
      completionDates: [],
    );
  }

  // Setters para configurar atributos del hábito
  void setHabitName(String? name) => habit = habit?.copyWith(name: name);
  void setHabitDescription(String? description) =>
      habit = habit?.copyWith(description: description);
  void setFrequency({bool isDaily = false, List<String>? days}) {
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
    habits.remove(habit);
  }

  // Actualizar un hábito específico
  void updateHabit(Habit habitToUpdate, String newName, String newDescription) {
    final habitIndex = habits.indexOf(habitToUpdate);
    if (habitIndex != -1) {
      habits[habitIndex] = habitToUpdate.copyWith(
        name: newName,
        description: newDescription,
      );
      habits.refresh();
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

  // Obtener hábitos de la rutina diaria
  List<Habit> getTodayHabits() {
    String today = _weekdayToString(simulatedDate.value.weekday);
    return habits.where((habit) {
      if (habit.isDaily) return true;
      return habit.selectedDays?.contains(today) ?? false;
    }).toList();
  }

  // Marcar un hábito como completado, manteniendo lógica para hábitos cuantificables
  void updateHabitCompletion(Habit habitToUpdate) {
    final index = habits.indexWhere((h) => h.name == habitToUpdate.name);
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

  // Método para verificar las rachas al cambiar la fecha
  void _onDateChange() {
    for (var habit in habits) {
      if (!habit.isDaily) {
        verifyStreakForSpecificDays(habit);
      } else if (habit.isDaily && habit.isCompleted) {
        _updateDailyStreak(habit);
      }
      habit.isCompleted = false; // Reiniciar estado
      habit.completedCount = 0;
    }
    habits.refresh();
  }

  // Actualiza la racha de un hábito diario
  void _updateDailyStreak(Habit habit) {
    if (habit.lastCompleted != null &&
        isSameDate(habit.lastCompleted!, simulatedDate.value.subtract(const Duration(days: 1)))) {
      habit.streakCount++;
    } else {
      habit.streakCount = 1;
    }
    habit.longestStreak = habit.streakCount > habit.longestStreak
        ? habit.streakCount
        : habit.longestStreak;
    habit.lastCompleted = DateTime(simulatedDate.value.year, simulatedDate.value.month, simulatedDate.value.day);
  }

  // Verifica la racha para hábitos de días específicos
  void verifyStreakForSpecificDays(Habit habit) {
    if (habit.selectedDays == null || habit.selectedDays!.isEmpty) return;

    // Convertir los días agendados a enteros (números de día de la semana)
    List<int> scheduledWeekdays = habit.selectedDays!
        .map((dayStr) => _weekdayFromString(dayStr))
        .toList();

    // Ordenar las fechas de completación
    List<DateTime> sortedCompletionDates = [
      ...habit.completionDates.map((date) => DateTime(date.year, date.month, date.day))
    ]..sort();

    int streak = 0;

    for (int i = 0; i < sortedCompletionDates.length; i++) {
      DateTime currentDate = sortedCompletionDates[i];
      
      // Si la fecha de completación corresponde a un día agendado, la racha sigue
      if (scheduledWeekdays.contains(currentDate.weekday)) {
        if (i == 0 || currentDate.difference(sortedCompletionDates[i - 1]).inDays <= 7) {
          streak++;
        } else {
          streak = 1; // Reinicia la racha si no son fechas consecutivas
        }
      }
    }

    // Actualiza la racha actual y la racha más larga
    habit.streakCount = streak;
    habit.longestStreak = streak > habit.longestStreak ? streak : habit.longestStreak;
    habits.refresh();
  }

  // Convertir día de la semana de int a String
  String _weekdayToString(int weekday) {
    switch (weekday) {
      case DateTime.monday:
        return 'Lun';
      case DateTime.tuesday:
        return 'Mar';
      case DateTime.wednesday:
        return 'Mie';
      case DateTime.thursday:
        return 'Jue';
      case DateTime.friday:
        return 'Vie';
      case DateTime.saturday:
        return 'Sab';
      case DateTime.sunday:
        return 'Dom';
      default:
        return '';
    }
  }

  // Convertir día de la semana de String a int
  int _weekdayFromString(String weekdayStr) {
    switch (weekdayStr) {
      case 'Lun':
        return DateTime.monday;
      case 'Mar':
        return DateTime.tuesday;
      case 'Mie':
        return DateTime.wednesday;
      case 'Jue':
        return DateTime.thursday;
      case 'Vie':
        return DateTime.friday;
      case 'Sab':
        return DateTime.saturday;
      case 'Dom':
        return DateTime.sunday;
      default:
        throw Exception('Día de la semana no válido');
    }
  }

  // Comparar fechas sin considerar la hora
  bool isSameDate(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }
}
