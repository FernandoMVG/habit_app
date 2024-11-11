import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:habit_app/models/category_model.dart';
import 'package:habit_app/constants.dart';

class CategoryController extends GetxController {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  var categories = <CategoryModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadCategories(); // Cargar categorías desde Firestore al iniciar
  }

  // Método para cargar categorías en tiempo real desde Firestore
  void loadCategories() {
    String userId = _auth.currentUser?.uid ?? '';
    if (userId.isNotEmpty) {
      _db
          .collection("users")
          .doc(userId)
          .collection("categorias")
          .snapshots()
          .listen((querySnapshot) {
        categories.clear();
        for (var doc in querySnapshot.docs) {
          categories.add(CategoryModel.fromMap(
              doc.data() as Map<String, dynamic>, doc.id));
        }
      });
    }
  }

  // Método para limpiar las categorías
  void clearCategories() {
    categories.clear();
  }

  // Método para recargar las categorías después de iniciar sesión
  void resetController() {
    clearCategories();
    loadCategories();
  }

  // Método para añadir una categoría a Firestore
  Future<bool> addCategory(
      String name, IconData icon, Color color, BuildContext context) async {
    String userId = _auth.currentUser!.uid;

    // Verificar si la categoría ya existe
    QuerySnapshot existingCategory = await _db
        .collection("users")
        .doc(userId)
        .collection("categorias")
        .where("nombre", isEqualTo: name)
        .get();

    if (existingCategory.docs.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Ya existe una categoría con ese nombre.'),
          backgroundColor: Colors.red,
        ),
      );
      return false;
    }

    // Agregar la categoría a Firestore si el nombre es único
    await _db.collection("users").doc(userId).collection("categorias").add({
      "nombre": name,
      "color": color.value
          .toRadixString(16), // Guardar el color como String hexadecimal
      "icono": icon.codePoint, // Guardar el código del icono
    });
    return true;
  }

  // Método para actualizar una categoría en Firestore
  Future<bool> updateCategory(CategoryModel category, String newName,
      IconData newIcon, Color newColor, BuildContext context) async {
    String userId = _auth.currentUser!.uid;

    // Verificar si el nuevo nombre de la categoría es único
    QuerySnapshot existingCategory = await _db
        .collection("users")
        .doc(userId)
        .collection("categorias")
        .where("nombre", isEqualTo: newName)
        .get();

    if (existingCategory.docs.isNotEmpty &&
        existingCategory.docs.first.id != category.id) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Ya existe una categoría con ese nombre.'),
          backgroundColor: Colors.red,
        ),
      );
      return false;
    }

    // Actualizar la categoría en Firestore
    await _db
        .collection("users")
        .doc(userId)
        .collection("categorias")
        .doc(category.id)
        .update({
      "nombre": newName,
      "color": newColor.value.toRadixString(16),
      "icono": newIcon.codePoint,
    });
    return true;
  }

  // Método para eliminar una categoría de Firestore
  Future<void> removeCategory(CategoryModel category) async {
    String userId = _auth.currentUser!.uid;

    // Eliminar la categoría de Firestore
    await _db
        .collection("users")
        .doc(userId)
        .collection("categorias")
        .doc(category.id)
        .delete();
  }
}
