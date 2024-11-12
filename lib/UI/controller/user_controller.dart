import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class UserController extends GetxController {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  var username = ''.obs;
  var experience = 0.obs;
  var level = 1.obs;

  RxnString userId = RxnString();

  String? get userIdValue => userId.value;

  @override
  void onInit() {
    super.onInit();
    _auth.authStateChanges().listen((user) {
      if (user != null) {
        userId.value = user.uid;
        listenToUserData();
      }
    });
  }

  // Método para escuchar cambios en tiempo real en el documento del usuario en Firestore
  void listenToUserData() {
    final user = _auth.currentUser;
    if (user == null) {
      print("No hay usuario autenticado");
      return;
    }

    String userId = user.uid;

    // Escuchar cambios en el documento del usuario en la colección "users"
    _db.collection("users").doc(userId).snapshots().listen((documentSnapshot) {
      if (documentSnapshot.exists) {
        username.value = documentSnapshot['nombre'] ?? 'Usuario';
        experience.value = documentSnapshot['experience'] ?? 0;
        level.value = documentSnapshot['level'] ?? 1;
      }
    });
  }

  // Método para añadir experiencia y verificar si el usuario sube de nivel
  void addExperience(int points) async {
    experience.value += points;
    await _updateUserExperienceInFirestore(); // Actualizar en Firestore
    _checkLevelUp();
  }

  // Método para restar experiencia
  void subtractExperience(int points) async {
    experience.value -= points;
    if (experience.value < 0) {
      experience.value = 0;
    }
    await _updateUserExperienceInFirestore(); // Actualizar en Firestore
  }

  // Método privado para verificar y manejar el nivel del usuario
  void _checkLevelUp() {
    int requiredExperience = level.value * 100;
    while (experience.value >= requiredExperience) {
      experience.value -= requiredExperience;
      level.value++;
      requiredExperience = level.value * 100;

      // Actualizar el nivel en Firestore si sube de nivel
      _updateUserLevelInFirestore();
    }
  }

  // Método para actualizar el nivel y experiencia del usuario en Firestore
  Future<void> _updateUserExperienceInFirestore() async {
    final user = _auth.currentUser;
    if (user == null) return;

    String userId = user.uid;

    try {
      await _db.collection("users").doc(userId).update({
        'experience': experience.value,
      });
    } catch (e) {
      print("Error al actualizar la experiencia del usuario en Firestore: $e");
    }
  }

  // Método para actualizar el nivel del usuario en Firestore
  Future<void> _updateUserLevelInFirestore() async {
    final user = _auth.currentUser;
    if (user == null) return;

    String userId = user.uid;

    try {
      await _db.collection("users").doc(userId).update({
        'level': level.value,
        'experience': experience.value,
      });
    } catch (e) {
      print("Error al actualizar el nivel del usuario en Firestore: $e");
    }
  }

  // Método para limpiar los datos del usuario al cerrar sesión
  void clearUserData() {
    username.value = '';
    experience.value = 0;
    level.value = 1;
  }
}
