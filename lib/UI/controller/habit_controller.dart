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
    );
  }

  // Métodos setters para configurar atributos del hábito
  void setHabitName(String? name) => habit = habit?.copyWith(name: name);
  void setHabitDescription(String? description) => habit = habit?.copyWith(description: description);
  void setFrequency({bool isDaily = false, List<String>? days}) {
    habit = habit?.copyWith(isDaily: isDaily, selectedDays: isDaily ? null : days);
  }

  // Añadir un hábito a la lista observable
  void addHabit() {
    if (habit != null && habit!.name.isNotEmpty) {
      habits.add(habit!);
      habit = null; // Limpiar instancia temporal
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
      habits[habitIndex] = habitToUpdate.copyWith(name: newName, description: newDescription);
      habits.refresh();
    }
  }

  // Reiniciar el progreso de un hábito
  void resetProgress(Habit habitToReset) {
    habitToReset.resetProgress();
    habits.refresh();
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

  String _weekdayToString(int weekday) {
  switch (weekday) {
    case DateTime.monday:
      return 'Lun';
    case DateTime.tuesday:
      return 'Mar';
    case DateTime.wednesday:
      return 'Mie'; // Sin acento si así está en selectedDays
    case DateTime.thursday:
      return 'Jue';
    case DateTime.friday:
      return 'Vie';
    case DateTime.saturday:
      return 'Sab'; // Sin acento
    case DateTime.sunday:
      return 'Dom';
    default:
      return '';
  }
}

int _weekdayFromString(String weekdayStr) {
  switch (weekdayStr) {
    case 'Lun':
      return DateTime.monday;
    case 'Mar':
      return DateTime.tuesday;
    case 'Mie': // Sin acento
      return DateTime.wednesday;
    case 'Jue':
      return DateTime.thursday;
    case 'Vie':
      return DateTime.friday;
    case 'Sab': // Sin acento
      return DateTime.saturday;
    case 'Dom':
      return DateTime.sunday;
    default:
      return 0; // O lanza una excepción
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

        if (habits[index].isCompleted) {
          habits[index].lastCompleted = DateTime(
            simulatedDate.value.year,
            simulatedDate.value.month,
            simulatedDate.value.day,
          );
        }
      }
      habits.refresh();
    }
  }

  // Avanzar la fecha simulada
  void advanceDate() {
    simulatedDate.value = simulatedDate.value.add(const Duration(days: 1));
    print('THISSSS ISSSS SPARTAAAAA ${simulatedDate.value}');
    _onDateChange();
  }

  // Retroceder la fecha simulada
  void goBackDate() {
    simulatedDate.value = simulatedDate.value.subtract(const Duration(days: 1));
    _onDateChange();
  }


// Añade este método para comparar solo las fechas sin tener en cuenta el tiempo
bool isSameDate(DateTime date1, DateTime date2) {
  return date1.year == date2.year && date1.month == date2.month && date1.day == date2.day;
}

// Añade este método para obtener la fecha programada anterior
DateTime? getPreviousScheduledDate(Habit habit, DateTime date) { 
  if (habit.selectedDays == null || habit.selectedDays!.isEmpty) {
    return null;
  }

  // Convierte selectedDays (List<String>) a List<int> de números de días de la semana
  List<int> scheduledWeekdays = habit.selectedDays!.map((dayStr) => _weekdayFromString(dayStr)).toList();
  
  // Agrega un print para mostrar scheduledWeekdays
  print('Scheduled weekdays: $scheduledWeekdays');

  // Busca hacia atrás hasta 7 días
  for (int i = 1; i <= 7; i++) {
    DateTime previousDate = date.subtract(Duration(days: i));
    int previousWeekday = previousDate.weekday;

    if (scheduledWeekdays.contains(previousWeekday)) {
      return previousDate;
    }
  }

  return null; // No se encontró una fecha programada anterior en los últimos 7 días
}

  // Modifica el método _onDateChange()
  void _onDateChange() {
    for (var habit in habits) {
      if (habit.isDaily) {
        if (habit.isCompleted) {
          if (habit.lastCompleted != null &&
              isSameDate(
                habit.lastCompleted!,
                simulatedDate.value.subtract(Duration(days: 1)),
              )) {
            habit.streakCount++;
          } else {
            habit.streakCount = 1;
          }
          habit.longestStreak = habit.streakCount > habit.longestStreak
              ? habit.streakCount
              : habit.longestStreak;
          habit.lastCompleted = DateTime(
            simulatedDate.value.year,
            simulatedDate.value.month,
            simulatedDate.value.day,
          );
        } else {
          habit.streakCount = 0;
        }
      } else if (habit.selectedDays != null &&
          habit.selectedDays!
              .contains(_weekdayToString(simulatedDate.value.weekday))) {
        if (habit.isCompleted) {
          DateTime? previousScheduledDate =
              getPreviousScheduledDate(habit, simulatedDate.value);

          if (previousScheduledDate != null &&
              habit.lastCompleted != null &&
              isSameDate(habit.lastCompleted!, previousScheduledDate)) {
            habit.streakCount++;
          } else {
            habit.streakCount = 1;
          }

          habit.longestStreak = habit.streakCount > habit.longestStreak
              ? habit.streakCount
              : habit.longestStreak;
          habit.lastCompleted = DateTime(
            simulatedDate.value.year,
            simulatedDate.value.month,
            simulatedDate.value.day,
          );
        } else {
          habit.streakCount = 0;
        }
      }

      // Reinicia el estado para el nuevo día
      habit.isCompleted = false;
      habit.completedCount = 0;
    }

    habits.refresh(); // Refresca la interfaz
  }
}