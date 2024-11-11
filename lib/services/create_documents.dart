import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> createUserDocument({
    required String userId,
    required String email,
    required String nombre,
  }) async {
    try {
      await _db.collection("users").doc(userId).set({
        "email": email,
        "nombre": nombre,
        "fechaRegistro": FieldValue.serverTimestamp(),
        "level": 1,
        "experience": 0,
      });
      print("Documento de usuario creado exitosamente");
    } catch (e) {
      print("Error al crear el documento de usuario: $e");
    }
  }
}
