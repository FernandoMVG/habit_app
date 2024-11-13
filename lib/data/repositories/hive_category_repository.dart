
import 'package:hive/hive.dart';
import 'package:habit_app/domain/models/category_model.dart';
import 'package:habit_app/domain/repositories/category_repository.dart';

class HiveCategoryRepository implements CategoryRepository {
  @override
  Future<void> createCategory(String email, CategoryModel category) async {
    var categoryBox = await Hive.openBox<CategoryModel>('categoryBox_$email');
    await categoryBox.put(category.name, category);
  }

  @override
  Future<List<CategoryModel>> getCategories(String email) async {
    var categoryBox = await Hive.openBox<CategoryModel>('categoryBox_$email');
    return categoryBox.values.toList();
  }

  @override
  Future<void> deleteCategory(String email, String categoryName) async {
    var categoryBox = await Hive.openBox<CategoryModel>('categoryBox_$email');
    await categoryBox.delete(categoryName);
  }
}