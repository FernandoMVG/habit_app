import 'package:get/get.dart';
import 'package:habit_app/models/habit_model.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'user_controller.dart';
import 'package:hive/hive.dart';

class HabitController extends GetxController {
  // Lista observable de hábitos
  var habits = <Habit>[].obs;

  // Fecha simulada para pruebas de rachas
  var simulatedDate = DateTime.now().obs;

  // Propiedad temporal para almacenar los datos de un hábito en construcción
  Habit? habit;

  final UserController userController = Get.find<UserController>();

  late Box<Habit> habitBox;

  @override
  void onInit() {
    super.onInit();
    _openHabitBox();
  }

  Future<void> _openHabitBox() async {
    try {
      if (userController.currentUserEmail.isEmpty) {
        habits.clear();
        return;
      }
      
      // Cerrar la caja anterior si existe
      if (Hive.isBoxOpen('habitBox_${userController.currentUserEmail}')) {
        await Hive.box<Habit>('habitBox_${userController.currentUserEmail}').close();
      }
      
      habitBox = await Hive.openBox<Habit>('habitBox_${userController.currentUserEmail}');
      habits.clear(); // Limpiar hábitos existentes
      _loadHabits();
    } catch (e) {
      print('Error al abrir la caja de hábitos: $e');
    }
  }

  Future<void> reloadHabits() async {
    await _openHabitBox();
  }

  void _loadHabits() {
    habits.addAll(habitBox.values);
  }

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
      habitBox.put(habit!.id, habit!); // Guardar hábito en Hive
      habit = null; // Limpiar la instancia temporal
    }
  }

  // Eliminar un hábito
  void removeHabit(Habit habit) {
    habits.removeWhere((h) => h.id == habit.id); // Usar id para encontrar y eliminar el hábito
    habitBox.delete(habit.id); // Eliminar hábito de Hive
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
      habitBox.put(habitToUpdate.id, habits[habitIndex]); // Actualizar hábito en Hive
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
        //add experience to quantifiable habits
        if (habitToUpdate.isCompleted) {
          _addExperienceForHabit(habitToUpdate);
        } else {
          _subtractExperienceForHabit(habitToUpdate);
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
    if (habit.isQuantifiable) {
      if(habit.isCompleted){
        _subtractExperienceForHabit(habit);
      } else {
        _addExperienceForHabit(habit);
      }
      habit.isCompleted = !habit.isCompleted;
      updateHabitCompletion(habit);
    }
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

  List<int> scheduledWeekdays = habit.selectedDays!;
  print('Días programados para "${habit.name}": $scheduledWeekdays');

  Set<DateTime> completionDatesSet = habit.completionDates
      .map((date) => DateTime(date.year, date.month, date.day))
      .toSet();
  print('Fechas de completación para "${habit.name}": $completionDatesSet');

  int streak = 0;
  DateTime currentDate = DateTime(
    simulatedDate.value.year,
    simulatedDate.value.month,
    simulatedDate.value.day,
  );
  print('Fecha actual: $currentDate');

  // Encontrar el último día completado
  DateTime? lastCompletedDate;
  DateTime checkDate = currentDate;
  
  // Buscar el último día completado
  while (true) {
    if (scheduledWeekdays.contains(checkDate.weekday) && 
        completionDatesSet.contains(checkDate)) {
      lastCompletedDate = checkDate;
      break;
    }
    if (checkDate.difference(currentDate).inDays < -30) break; // Límite de búsqueda
    checkDate = checkDate.subtract(const Duration(days: 1));
  }

  // Si no hay días completados, la racha es 0
  if (lastCompletedDate == null) {
    habit.streakCount = 0;
    return;
  }

  // Contar la racha desde el último día completado
  DateTime countDate = lastCompletedDate;
  while (true) {
    if (scheduledWeekdays.contains(countDate.weekday)) {
      if (completionDatesSet.contains(countDate)) {
        streak++;
        print('Hábito completado en $countDate. Racha actual: $streak');
      } else {
        print('Racha interrumpida. No se completó el hábito en $countDate');
        break;
      }
    }
    countDate = countDate.subtract(const Duration(days: 1));
  }

  print('Racha final para "${habit.name}": $streak');
  habit.streakCount = streak;
  if (streak > habit.longestStreak) {
    habit.longestStreak = streak;
    print('Nueva racha más larga para "${habit.name}": ${habit.longestStreak}');
  }
  print('Racha final para "${habit.name}": ${habit.streakCount}');
  print('Racha más larga para "${habit.name}": ${habit.longestStreak}');
  print("--------------------FIN ESPECIFICO DIA---------------------");
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
