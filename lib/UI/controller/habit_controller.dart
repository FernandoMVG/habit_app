import 'package:get/get.dart';
import 'package:habit_app/models/habit_model.dart';
import 'package:flutter/material.dart';

class HabitController extends GetxController {
  String? habitName;
  String? habitDescription;
  Color? categoryColor;
  String? categoryName;
  bool isQuantifiable = false;
  List<String>? selectedDays;
  bool isDaily = false;

  // Nuevas propiedades para hábitos cuantificables
  String? quantificationType; // Al menos, menos de, exactamente, más de, sin especificar
  int? quantity;
  String? unit;

  // Lista observable de hábitos
  var habits = <Habit>[].obs;

  // Método para establecer el tipo de hábito (cuantificable o binario)
  void setHabitType(bool quantifiable) {
    isQuantifiable = quantifiable;
  }

  // Método para establecer el nombre del hábito
  void setHabitName(String name) {
    habitName = name;
  }

  // Método para establecer la descripción del hábito (opcional)
  void setHabitDescription(String? description) {
    habitDescription = description;
  }

  // Método para establecer la categoría del hábito
  void setCategory(String name, Color color) {
    categoryName = name;
    categoryColor = color;
  }

  // Método para establecer la frecuencia del hábito (semanal o diario)
  void setFrequency({bool isDaily = false, List<String>? days}) {
    this.isDaily = isDaily;
    selectedDays = days;
  }

  // Método para establecer el tipo de cuantificación
  void setQuantificationType(String type) {
    quantificationType = type;

    // Si es "Sin especificar", deshabilitamos los campos de cantidad y unidad
    if (type == "Sin especificar") {
      quantity = null;
      unit = null;
    }
  }

  // Método para establecer la cantidad del hábito cuantificable
  void setQuantity(int? qty) {
    if (quantificationType != "Sin especificar") {
      quantity = qty;
    }
  }

  // Método para establecer la unidad del hábito cuantificable (opcional)
  void setUnit(String? habitUnit) {
    if (quantificationType != "Sin especificar") {
      unit = habitUnit;
    }
  }

  // Método para crear un hábito y añadirlo a la lista observable
  void addHabit() {
    if (habitName != null && categoryColor != null && categoryName != null) {
      final newHabit = Habit(
        name: habitName!,
        description: habitDescription,
        categoryColor: categoryColor!,
        categoryName: categoryName!,
        isQuantifiable: isQuantifiable,
        selectedDays: isDaily ? null : selectedDays,
        isDaily: isDaily,
        quantificationType: isQuantifiable ? quantificationType : null,
        quantity: isQuantifiable ? quantity : null,
        unit: isQuantifiable ? unit : null,
      );

      // Añadir el nuevo hábito a la lista observable
      habits.add(newHabit);
      clearHabitData(); // Limpiar los datos actuales para la próxima creación
    }
  }

  // Método para limpiar los datos de un hábito después de su creación
  void clearHabitData() {
    habitName = null;
    habitDescription = null;
    categoryColor = null;
    categoryName = null;
    isQuantifiable = false;
    selectedDays = null;
    isDaily = false;
    quantificationType = null;
    quantity = null;
    unit = null;
  }

  // Método para obtener la lista de hábitos
  List<Habit> getHabitList() {
    return habits;
  }

  // Función para verificar si hay hábitos
  bool hasHabits() {
    return habits.isNotEmpty;
  }

  // Método para eliminar un hábito
  void removeHabit(Habit habit) {
    habits.remove(habit);
  }

  // Método para actualizar un hábito específico
  void updateHabit(Habit habit, String newName, String newDescription) {
    final habitIndex = habits.indexOf(habit);

    if (habitIndex != -1) {
      habits[habitIndex] = Habit(
        name: newName,
        description: newDescription,
        categoryColor: habit.categoryColor,
        categoryName: habit.categoryName,
        isQuantifiable: habit.isQuantifiable,
        selectedDays: habit.selectedDays,
        isDaily: habit.isDaily,
        //quantificationType: habit.quantificationType,
        //quantity: habit.quantity,
        unit: habit.unit,
        completedCount: habit.completedCount,
      );
      habits.refresh(); // Refresca la lista para actualizar la UI
    }
  }
}
