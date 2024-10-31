import 'package:get/get.dart';
import 'package:habit_app/models/habit_model.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class HabitController extends GetxController {
  // Lista observable de hábitos
  var habits = <Habit>[].obs;

  // Fecha simulada para pruebas de rachas
  var simulatedDate = DateTime.now().obs;

  // Propiedad temporal para almacenar los datos de un hábito en construcción
  Habit? habit;

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
      experience: _generateExperience(),
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
    habits.remove(habit);
  }

  // Actualizar un hábito específico
  void updateHabit(Habit habitToUpdate, String newName, String newDescription) {
    final habitIndex = habits.indexOf(habitToUpdate);
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

  // Obtener los hábitos de hoy
  List<Habit> getTodayHabits() {
    int today = simulatedDate.value.weekday;
    return habits.where((habit) {
      return habit.isDaily || (habit.selectedDays?.contains(today) ?? false);
    }).toList();
  }

  // Método para verificar las rachas al cambiar la fecha
  void _onDateChange() {
    for (var habit in habits) {
      if (!habit.isDaily) {
        verifyStreakForSpecificDays(habit);
      } else {
        // Verificamos si el hábito diario fue completado ayer.
        _updateDailyStreak(habit);
      }
      habit.isCompleted = false; // Reiniciar estado al cambiar de día
      habit.completedCount = 0;   // Reiniciar progreso de hábitos cuantificables
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
      // Si no fue completado ayer o hoy no está completado, reinicia la racha.
      habit.streakCount = 0; 
    }

    // Si el hábito fue completado hoy, actualizamos la última vez completada.
    if (habit.isCompleted) {
      habit.lastCompleted = today;
      //print("Actualizando última vez completado a: $today");
    } else {
      //print("El hábito no fue completado hoy, no se actualiza la última vez completado.");
    }

    // Actualizamos la racha más larga si es necesario.
    habit.longestStreak = habit.streakCount > habit.longestStreak
        ? habit.streakCount
        : habit.longestStreak;

    //print("Racha actual: ${habit.streakCount}");
    //print("Racha más larga: ${habit.longestStreak}");
    //print("--------------------FIN DIA---------------------");
    habits.refresh(); // Refrescamos para que los cambios se reflejen en la UI.
  }

// Verifica la racha para hábitos de días específicos
void verifyStreakForSpecificDays(Habit habit) {
  if (habit.selectedDays == null || habit.selectedDays!.isEmpty) return;
  //print('Dia actual: "${simulatedDate.value}"');

  // Convertir los días programados a enteros (números de días de la semana)
  List<int> scheduledWeekdays = habit.selectedDays!;
  //print('Días programados para el hábito "${habit.name}": $scheduledWeekdays');

  // Crear un conjunto de fechas de completación para búsqueda eficiente
  Set<DateTime> completionDatesSet = habit.completionDates
      .map((date) => DateTime(date.year, date.month, date.day))
      .toSet();
  //print('Fechas de completación ordenadas para el hábito "${habit.name}": ${completionDatesSet.toList()..sort()}');

  int streak = 0;
  DateTime currentDate = DateTime(simulatedDate.value.year, simulatedDate.value.month, simulatedDate.value.day);

  // Iterar hacia atrás desde la fecha actual
  while (true) {
    if (scheduledWeekdays.contains(currentDate.weekday)) {
      // Es un día programado
      if (completionDatesSet.contains(currentDate)) {
        // El hábito fue completado en este día
        streak++;
        //print('Incrementando la racha de "${habit.name}": $streak');
      } else {
        // El hábito no fue completado en este día programado
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

  // Refrescar lista de hábitos
  //print('Racha final para "${habit.name}": ${habit.streakCount}');
  //print('Racha más larga para "${habit.name}": ${habit.longestStreak}');
  //print("--------------------FIN ESPECIFICO DIA---------------------");
  habits.refresh();
}

  String _generateId() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }

  int _generateExperience() {
    return Random().nextInt(11) + 10; // Generar un valor entre 10 y 20
  }

  // Comparar fechas sin considerar la hora
  bool isSameDate(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }
}
