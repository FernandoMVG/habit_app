// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_model.dart';

// ************************************************************************** 
// TypeAdapterGenerator 
// ************************************************************************** 

class CategoryModelAdapter extends TypeAdapter<CategoryModel> { 
  @override 
  final int typeId = 2; 

  @override 
  CategoryModel read(BinaryReader reader) { 
    final numOfFields = reader.readByte(); 
    final fields = <int, dynamic>{ 
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(), 
    }; 
    return CategoryModel( 
      name: fields[0] as String, 
      icon: fields[1] as IconData, 
      color: fields[2] as Color, 
    ); 
  } 

  @override 
  void write(BinaryWriter writer, CategoryModel obj) { 
    writer 
      ..writeByte(3) 
      ..writeByte(0) 
      ..write(obj.name) 
      ..writeByte(1) 
      ..write(obj.icon) 
      ..writeByte(2) 
      ..write(obj.color); 
  } 
}