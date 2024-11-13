import 'package:hive/hive.dart';
import '../models/habit_model.dart';
import '../repositories/habit_repository.dart';

class HabitUseCase {
  final HabitRepository _repository;

  HabitUseCase(this._repository);

  Future<Box<Habit>> openHabitBox(String email) async {
    return await _repository.openHabitBox(email);
  }

  Future<void> createHabit(String email, Habit habit) async {
    await _repository.createHabit(email, habit);
  }

  List<Habit> getHabits(String email) {
    return _repository.getHabits(email);
  }

  Future<void> updateHabit(String email, Habit habit) async {
    await _repository.updateHabit(email, habit);
  }

  Future<void> deleteHabit(String email, String habitId) async {
    await _repository.deleteHabit(email, habitId);
  }
}
