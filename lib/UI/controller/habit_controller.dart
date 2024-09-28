import 'package:get/get.dart';

class HabitController extends GetxController {
  // Lista para manejar los hábitos creados
  var habits = <String>[].obs;
  var isQuantifiable = false.obs;  // Inicialmente asumimos que no es cuantificable

  // Función para agregar un hábito
  void addHabit(String habit) {
    habits.add(habit);
  }

  // Función para eliminar un hábito
  void removeHabit(String habit) {
    habits.remove(habit);
  }

  // Función para verificar si hay hábitos
  bool hasHabits() {
    return habits.isNotEmpty;
  }

  // Función para actualizar el tipo de hábito
  void setHabitType(bool quantifiable) {
    isQuantifiable.value = quantifiable;
  }
}

