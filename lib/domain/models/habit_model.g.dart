// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'habit_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HabitAdapter extends TypeAdapter<Habit> {
  @override
  final int typeId = 0;

  @override
  Habit read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Habit(
      id: fields[0] as String,
      name: fields[1] as String,
      categoryColor: fields[2] as Color,
      categoryName: fields[3] as String,
      isQuantifiable: fields[4] as bool,
      selectedDays: (fields[5] as List?)?.cast<int>(),
      isDaily: fields[6] as bool,
      targetCount: fields[7] as int?,
      completedCount: fields[8] as int,
      frequencyType: fields[9] as String?,
      unit: fields[10] as String?,
      categoryIcon: fields[11] as IconData,
      isCompleted: fields[12] as bool,
      isMissed: fields[13] as bool,
      streakCount: fields[14] as int,
      longestStreak: fields[15] as int,
      completionDates: (fields[16] as List).cast<DateTime>(),
      experience: fields[17] as int,
      gainedExperience: fields[18] as int?,
      lastCompleted: fields[19] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, Habit obj) {
    writer
      ..writeByte(20)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.categoryColor)
      ..writeByte(3)
      ..write(obj.categoryName)
      ..writeByte(4)
      ..write(obj.isQuantifiable)
      ..writeByte(5)
      ..write(obj.selectedDays)
      ..writeByte(6)
      ..write(obj.isDaily)
      ..writeByte(7)
      ..write(obj.targetCount)
      ..writeByte(8)
      ..write(obj.completedCount)
      ..writeByte(9)
      ..write(obj.frequencyType)
      ..writeByte(10)
      ..write(obj.unit)
      ..writeByte(11)
      ..write(obj.categoryIcon)
      ..writeByte(12)
      ..write(obj.isCompleted)
      ..writeByte(13)
      ..write(obj.isMissed)
      ..writeByte(14)
      ..write(obj.streakCount)
      ..writeByte(15)
      ..write(obj.longestStreak)
      ..writeByte(16)
      ..write(obj.completionDates)
      ..writeByte(17)
      ..write(obj.experience)
      ..writeByte(18)
      ..write(obj.gainedExperience)
      ..writeByte(19)
      ..write(obj.lastCompleted);
  }
}