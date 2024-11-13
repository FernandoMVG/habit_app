import '../models/category_model.dart';
import '../repositories/category_repository.dart';

class CategoryUseCase {
  final CategoryRepository _repository;

  CategoryUseCase(this._repository);

  Future<void> createCategory(String email, CategoryModel category) async {
    await _repository.createCategory(email, category);
  }

  Future<List<CategoryModel>> getCategories(String email) async {
    return await _repository.getCategories(email);
  }

  Future<void> deleteCategory(String email, String categoryName) async {
    await _repository.deleteCategory(email, categoryName);
  }
}
