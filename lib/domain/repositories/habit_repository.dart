import 'package:hive/hive.dart';
import 'package:habit_app/data/datasource/datasource_hive.dart' as datasource;
import '../models/habit_model.dart';

abstract class HabitRepository {
  Future<Box<Habit>> openHabitBox(String email);
  
  Future<void> createHabit(String email, Habit habit);
  
  List<Habit> getHabits(String email);
  
  Future<void> updateHabit(String email, Habit habit);
  
  Future<void> deleteHabit(String email, String habitId);
}

class HabitRepositoryImpl implements HabitRepository {
  @override
  Future<Box<Habit>> openHabitBox(String email) async {
    return await datasource.openHabitBox(email);
  }

  @override
  Future<void> createHabit(String email, Habit habit) async {
    await datasource.putHabit(email, habit);
  }

  @override
  List<Habit> getHabits(String email) {
    return datasource.getHabits(email);
  }

  @override
  Future<void> updateHabit(String email, Habit habit) async {
    await datasource.putHabit(email, habit);
  }

  @override
  Future<void> deleteHabit(String email, String habitId) async {
    await datasource.deleteHabit(email, habitId);
  }
}