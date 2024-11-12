import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:habit_app/models/habit_model.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'user_controller.dart';

class HabitController extends GetxController {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final UserController userController = Get.find<UserController>();

  // Fecha simulada para pruebas de rachas
  var simulatedDate = DateTime.now().obs;
  var lastSimulatedDate = DateTime.now();

  // Propiedad temporal para almacenar los datos de un hábito en construcción
  Habit? habit;

  @override
  void onInit() {
    super.onInit();
    userController.userId.listen((uid) {
      if (uid != null) {
        // Aquí podrías iniciar otras operaciones si es necesario
      }
    });
  }

  // Método para obtener los hábitos de Firestore en tiempo real
  Stream<List<Habit>> getHabitsStream() {
    final String userId = userController.userId.value ?? '';
    if (userId.isEmpty) return const Stream.empty();

    return _db
        .collection('users')
        .doc(userId)
        .collection('habits')
        .snapshots()
        .map((querySnapshot) {
      return querySnapshot.docs.map((doc) {
        return Habit.fromFirestore(doc.data(), doc.id);
      }).toList();
    });
  }

  void setCategory(
      String categoryName, Color categoryColor, IconData categoryIcon) {
    habit = habit?.copyWith(
      categoryName: categoryName,
      categoryColor: categoryColor,
      categoryIcon: categoryIcon,
    );
  }

  // Método para establecer el tipo de cuantificación
  void setQuantificationType(String? quantificationType) {
    habit = habit?.copyWith(frequencyType: quantificationType);
  }

  // Definir en HabitController
  void setHabitName(String name) {
    habit = habit?.copyWith(name: name);
  }

  void setHabitDescription(String? description) {
    habit = habit?.copyWith(description: description);
  }

  // Definición en HabitController
  void setFrequency({required bool isDaily, List<int>? days}) {
    habit =
        habit?.copyWith(isDaily: isDaily, selectedDays: isDaily ? null : days);
  }

  void setQuantity(int? quantity) {
    habit = habit?.copyWith(targetCount: quantity);
  }

  void setUnit(String? unit) {
    habit = habit?.copyWith(unit: unit);
  }

  // Añadir un hábito a Firestore
  Future<void> addHabit() async {
    if (habit != null && habit!.name.isNotEmpty) {
      final String userId = userController.userId.value ?? '';
      if (userId.isEmpty) return;

      final docRef = await _db
          .collection('users')
          .doc(userId)
          .collection('habits')
          .add(habit!.toMap());

      habit = habit!.copyWith(id: docRef.id);
      habit = null; // Limpiar la instancia temporal
    }
  }

  // Eliminar un hábito de Firestore
  Future<void> removeHabit(Habit habit) async {
    final String? userId = userController.userId.value;
    await _db
        .collection('users')
        .doc(userId)
        .collection('habits')
        .doc(habit.id)
        .delete();
  }

  // Actualizar un hábito específico en Firestore
  Future<void> updateHabit(
      Habit habitToUpdate, String newName, String newDescription) async {
    final String? userId = userController.userId.value;
    await _db
        .collection('users')
        .doc(userId)
        .collection('habits')
        .doc(habitToUpdate.id)
        .update({
      'name': newName,
      'description': newDescription.isNotEmpty ? newDescription : '',
    });
  }

  void initHabit({
    required String name,
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
      experience: Random().nextInt(6) + 5, // 5 a 10 puntos de experiencia
    );
  }

  List<Habit> getTodayHabits(List<Habit> habits) {
    DateTime today = DateTime(simulatedDate.value.year,
        simulatedDate.value.month, simulatedDate.value.day);
    String todayKey = "${today.year}-${today.month}-${today.day}";

    return habits.map((habit) {
      int progressForToday = habit.dailyProgress[todayKey] ?? 0;
      habit.completedCount = progressForToday;
      habit.isCompleted = habit.isQuantifiable && habit.targetCount != null
          ? progressForToday >= habit.targetCount!
          : habit.completionDates.contains(today);

      return habit;
    }).toList();
  }

  Stream<List<Habit>> getTodayHabitsStream() {
    final String userId = userController.userId.value ?? '';

    if (userId.isEmpty) return const Stream.empty();

    return _db
        .collection('users')
        .doc(userId)
        .collection('habits')
        .snapshots()
        .map((querySnapshot) {
      int todayWeekday = simulatedDate.value.weekday;
      DateTime todayDate = DateTime(
        simulatedDate.value.year,
        simulatedDate.value.month,
        simulatedDate.value.day,
      );

      return querySnapshot.docs
          .map((doc) {
            final habit = Habit.fromFirestore(doc.data(), doc.id);
            bool isTodayCompleted = habit.completionDates.contains(todayDate);
            habit.isCompleted = isTodayCompleted;
            if (habit.isDaily ||
                (habit.selectedDays?.contains(todayWeekday) ?? false)) {
              return habit;
            }
            return null;
          })
          .whereType<Habit>()
          .toList();
    });
  }

  Future<void> updateQuantifiableHabitProgress(
      Habit habit, int updatedCount) async {
    final String userId = userController.userId.value ?? '';
    if (userId.isEmpty) return;

    DateTime today = DateTime(simulatedDate.value.year,
        simulatedDate.value.month, simulatedDate.value.day);
    String todayKey = "${today.year}-${today.month}-${today.day}";

    // Actualizamos el progreso del día específico
    habit.dailyProgress[todayKey] = updatedCount;

    print(habit.dailyProgress[todayKey]);

    // Verificar si el hábito se debe marcar como completado
    if (habit.frequencyType == 'Sin especificar' && updatedCount > 0) {
      habit.isCompleted = true;
    } else if (habit.targetCount != null &&
        updatedCount >= habit.targetCount!) {
      habit.isCompleted = true;
    } else {
      habit.isCompleted = false;
    }

    // Actualizar en Firestore
    await _db
        .collection('users')
        .doc(userId)
        .collection('habits')
        .doc(habit.id)
        .update({
      'dailyProgress':
          habit.dailyProgress.isNotEmpty ? habit.dailyProgress : null,
      'isCompleted': habit.isCompleted,
    });
  }

  // Método para calcular la experiencia total ganada
  int _calculateTotalGainedExperience(Habit habit) {
    return habit.dailyExperience.values.fold(0, (sum, exp) => sum + exp);
  }

  void _updateGainedExperience(Habit habit) {
    habit.gainedExperience = _calculateTotalGainedExperience(habit);

    // Actualiza Firestore para mantener la ganancia total de experiencia
    _updateHabitExperienceInFirestore(habit);
  }

  Future<void> toggleHabitCompletion(Habit habit) async {
    final String userId = userController.userId.value ?? '';
    if (userId.isEmpty) return;

    DateTime today = DateTime(
      simulatedDate.value.year,
      simulatedDate.value.month,
      simulatedDate.value.day,
    );
    String todayKey = "${today.year}-${today.month}-${today.day}";

    bool isTodayCompleted = habit.dailyProgress[todayKey] != null &&
        habit.dailyProgress[todayKey]! > 0;

    if (isTodayCompleted) {
      // Si ya está marcado como completado, lo desmarcamos para el día actual
      habit.dailyProgress.remove(todayKey);
      habit.isCompleted = false;
      habit.lastCompleted = null; // Restablecer la fecha de último completado
    } else {
      // Si no está completado, lo marcamos como completado
      habit.dailyProgress[todayKey] =
          habit.targetCount != null ? habit.targetCount! : 1;
      habit.isCompleted = true;
      habit.lastCompleted = today; // Actualizamos la fecha de último completado
      _updateDailyStreak(habit); // Llamamos para actualizar la racha
    }

    await _db
        .collection('users')
        .doc(userId)
        .collection('habits')
        .doc(habit.id)
        .update({
      'dailyProgress': habit.dailyProgress,
      'isCompleted': habit.isCompleted,
      'lastCompleted': habit.lastCompleted,
      'streakCount': habit.streakCount,
      'longestStreak': habit.longestStreak,
    });
  }

  // HabitController

  Future<void> updateHabitCompletion(Habit habitToUpdate) async {
    final String userId = userController.userId.value ?? '';
    if (userId.isEmpty) return;

    bool isCompleted = habitToUpdate.isCompleted;
    if (habitToUpdate.isQuantifiable) {
      switch (habitToUpdate.frequencyType) {
        case 'Exactamente':
          isCompleted = (habitToUpdate.targetCount != null &&
              habitToUpdate.completedCount == habitToUpdate.targetCount!);
          break;
        case 'Sin especificar':
          // Marcar como completado si tiene al menos una unidad completada
          isCompleted = habitToUpdate.completedCount >= 1;
          break;
        default:
          isCompleted = false;
      }
    }

    habitToUpdate = habitToUpdate.copyWith(isCompleted: isCompleted);

    await _db
        .collection('users')
        .doc(userId)
        .collection('habits')
        .doc(habitToUpdate.id)
        .update({
      'isCompleted': isCompleted,
      'completedCount': habitToUpdate.completedCount,
      'lastCompleted': habitToUpdate.completedCount > 0 ? DateTime.now() : null,
    });
  }

  // Método para otorgar experiencia diaria con control
  void _addExperienceForHabit(Habit habit) {
    int baseExperience = habit.experience;
    int streakMultiplier = (1 + habit.streakCount * 0.1).toInt();
    int totalExperience = (baseExperience * streakMultiplier).toInt();

    // Obtener la fecha actual en formato "YYYY-MM-DD"
    String todayKey =
        "${simulatedDate.value.year}-${simulatedDate.value.month}-${simulatedDate.value.day}";

    // Evitar sumar experiencia más de una vez por día
    if (habit.dailyExperience[todayKey] != null) return;

    // Actualizar la experiencia diaria
    habit.dailyExperience[todayKey] = totalExperience;

    // Recalcular gainedExperience
    _updateGainedExperience(habit);

    // Añadir experiencia al usuario
    userController.addExperience(totalExperience);
  }

  // Método para restar experiencia diaria
  void _subtractExperienceForHabit(Habit habit) {
    String todayKey =
        "${simulatedDate.value.year}-${simulatedDate.value.month}-${simulatedDate.value.day}";

    if (habit.dailyExperience.containsKey(todayKey)) {
      int experienceToSubtract = habit.dailyExperience[todayKey]!;
      userController.subtractExperience(experienceToSubtract);
      habit.dailyExperience.remove(todayKey);

      // Recalcular gainedExperience
      _updateGainedExperience(habit);
    }
  }

  Future<void> _updateHabitExperienceInFirestore(Habit habit) async {
    final String userId = userController.userId.value ?? '';
    if (userId.isEmpty) return;

    await _db
        .collection('users')
        .doc(userId)
        .collection('habits')
        .doc(habit.id)
        .update({
      'dailyExperience': habit.dailyExperience,
    });
  }

  // Avanzar y retroceder fecha simulada
  void advanceDate() {
    simulatedDate.value = simulatedDate.value.add(const Duration(days: 1));
    _onDateChange();
  }

  void goBackDate() {
    simulatedDate.value = simulatedDate.value.subtract(const Duration(days: 1));
    _onDateChange();
  }

  // Método de cambio de fecha que controla la racha al avanzar los días
  void _onDateChange() {
    final habitsStream = getHabitsStream();
    habitsStream.listen((habits) {
      bool allHabitsCompleted = true;
      for (var habit in habits) {
        if (!habit.isDaily) {
          verifyStreakForSpecificDays(habit);
        } else {
          // Reiniciar racha si no fue completado el día anterior
          DateTime yesterday =
              simulatedDate.value.subtract(const Duration(days: 1));
          if (habit.lastCompleted == null ||
              !isSameDate(habit.lastCompleted!, yesterday)) {
            habit.streakCount = 0;
          }
          _updateDailyStreak(habit);
        }

        if (!habit.isCompleted) {
          allHabitsCompleted = false;
        }
      }
      if (allHabitsCompleted) {
        userController.addExperience(50);
      }
    });
  }

  // Método para verificar y actualizar la racha diaria
  void _updateDailyStreak(Habit habit) {
    DateTime today = DateTime(
      simulatedDate.value.year,
      simulatedDate.value.month,
      simulatedDate.value.day,
    );

    DateTime yesterday = today.subtract(const Duration(days: 1));

    // Verificar si el hábito fue completado ayer para mantener la continuidad de la racha
    if (habit.lastCompleted != null &&
        isSameDate(habit.lastCompleted!, yesterday)) {
      habit.streakCount++;
    } else {
      // Si el hábito no fue completado ayer, reiniciar la racha
      habit.streakCount = 0;
    }

    // Actualizar la racha más larga si la racha actual es mayor
    habit.longestStreak = habit.streakCount > habit.longestStreak
        ? habit.streakCount
        : habit.longestStreak;

    // Registrar la fecha de último completado
    habit.lastCompleted = today;

    _updateHabitCompletionInFirestore(habit);
  }

// Método auxiliar para actualizar el hábito en Firestore
  Future<void> _updateHabitCompletionInFirestore(Habit habit) async {
    final String userId = userController.userId.value ?? '';
    if (userId.isEmpty) return;

    await _db
        .collection('users')
        .doc(userId)
        .collection('habits')
        .doc(habit.id)
        .update({
      'isCompleted': habit.isCompleted,
      'completedCount': habit.completedCount,
      'lastCompleted': habit.lastCompleted,
      'streakCount': habit.streakCount,
      'longestStreak': habit.longestStreak,
    });
  }

  bool isSameDate(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  void verifyStreakForSpecificDays(Habit habit) {
    if (habit.selectedDays == null || habit.selectedDays!.isEmpty) return;

    List<int> scheduledWeekdays = habit.selectedDays!;
    Set<DateTime> completionDatesSet = habit.completionDates
        .map((date) => DateTime(date.year, date.month, date.day))
        .toSet();

    int streak = 0;
    DateTime currentDate = DateTime(
      simulatedDate.value.year,
      simulatedDate.value.month,
      simulatedDate.value.day,
    );

    DateTime? lastCompletedDate;
    DateTime checkDate = currentDate;

    while (true) {
      if (scheduledWeekdays.contains(checkDate.weekday) &&
          completionDatesSet.contains(checkDate)) {
        lastCompletedDate = checkDate;
        break;
      }
      if (checkDate.difference(currentDate).inDays < -30) break;
      checkDate = checkDate.subtract(const Duration(days: 1));
    }

    if (lastCompletedDate == null) {
      habit.streakCount = 0;
      return;
    }

    DateTime countDate = lastCompletedDate;
    while (true) {
      if (scheduledWeekdays.contains(countDate.weekday)) {
        if (completionDatesSet.contains(countDate)) {
          streak++;
        } else {
          break;
        }
      }
      countDate = countDate.subtract(const Duration(days: 1));
    }

    habit.streakCount = streak;
    if (streak > habit.longestStreak) {
      habit.longestStreak = streak;
    }
    _updateHabitCompletionInFirestore(habit);
  }

  String _generateId() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }
}
