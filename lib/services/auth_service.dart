import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habit_app/UI/controller/category_controller.dart';
import 'package:habit_app/UI/controller/user_controller.dart';
import 'package:habit_app/UI/pages/home.dart';
import 'package:habit_app/UI/pages/welcome/welcome_screen.dart';
import 'package:habit_app/constants.dart';
import 'package:habit_app/models/category_model.dart';
import 'package:habit_app/services/create_documents.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirestoreService _firestoreService = FirestoreService();
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final UserController userController = Get.put(UserController());

  Future<void> signUp({
    required String email,
    required String password,
    required String nombre,
    required BuildContext context,
  }) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final categoryController = Get.find<CategoryController>();
      categoryController.loadCategories();

      // Crea el documento en Firestore con el nombre de usuario
      await _firestoreService.createUserDocument(
        userId: userCredential.user!.uid,
        email: email,
        nombre: nombre,
      );

      // Crear las categorías por defecto
      await _createDefaultCategories(userCredential.user!.uid);

      // Espera a que los datos del usuario se carguen en UserController
      userController.listenToUserData();

      // Navega a la pantalla de inicio solo después de que los datos estén disponibles
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } on FirebaseAuthException catch (e) {
      String message = '';
      if (e.code == 'weak-password') {
        message = 'La contraseña es demasiado débil.';
      } else if (e.code == 'email-already-in-use') {
        message = 'Ya existe una cuenta con este correo electrónico.';
      } else {
        message = 'Ocurrió un error. Inténtalo de nuevo.';
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          duration: const Duration(seconds: 2),
          backgroundColor: errorColor,
        ),
      );
    }
  }

  // Método para crear categorías por defecto en Firestore para un nuevo usuario
  Future<void> _createDefaultCategories(String userId) async {
    for (CategoryModel category in defaultCategories) {
      await _db
          .collection("users")
          .doc(userId)
          .collection("categorias")
          .add(category.toMap());
    }
  }

  Future<void> signIn({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Reiniciar y cargar datos del CategoryController para el nuevo usuario
      final categoryController = Get.find<CategoryController>();
      categoryController.resetController();

      // Cargar datos del usuario en UserController
      userController.listenToUserData();

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } on FirebaseAuthException catch (e) {
      String message = '';
      if (e.code == 'invalid-credential') {
        message = 'Usuario o contraseña incorrectos';
      } else {
        message = 'Ocurrió un error. Inténtalo de nuevo.';
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          duration: const Duration(seconds: 2),
          backgroundColor: errorColor,
        ),
      );
    }
  }

  Future<void> signOut(BuildContext context) async {
    // Limpiar los datos de los controladores antes de cerrar sesión
    Get.find<UserController>().clearUserData();
    Get.find<CategoryController>().clearCategories();

    await _auth.signOut();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const WelcomeScreen()),
    );
  }
}
