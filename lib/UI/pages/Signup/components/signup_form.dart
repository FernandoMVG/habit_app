// signup_form.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '/constants.dart';
import '/UI/controller/auth_controller.dart';
import '/components/already_have_an_account_acheck.dart';
import '../../Login/login_screen.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({
    super.key,
  });

  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _formKey = GlobalKey<FormState>(); // Clave para el formulario
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // Expresión regular para validar un correo electrónico
  final RegExp emailRegExp = RegExp(
    r'^[a-zA-Z0-9._]+@[a-zA-Z0-9]+\.[a-zA-Z]+',
  );

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey, // Asignar la clave al formulario
      child: Column(
        children: [
          TextFormField(
            key: const Key('email_field'),  // Add this key
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            cursorColor: primaryColor,
            decoration: const InputDecoration(
              hintText: "Your email",
              prefixIcon: Padding(
                padding: EdgeInsets.all(defaultPadding),
                child: Icon(Icons.person),
              ),
            ),
            // Validación del correo
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your email';
              } else if (!emailRegExp.hasMatch(value)) {
                return 'Enter a valid email';
              }
              return null;
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: defaultPadding),
            child: TextFormField(
              key: const Key('password_field'),  // Add this key
              controller: passwordController,
              textInputAction: TextInputAction.done,
              obscureText: true,
              cursorColor: primaryColor,
              decoration: const InputDecoration(
                hintText: "Your password",
                prefixIcon: Padding(
                  padding: EdgeInsets.all(defaultPadding),
                  child: Icon(Icons.lock),
                ),
              ),
              // Validación de contraseña (opcional)
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your password';
                }
                return null;
              },
            ),
          ),
          const SizedBox(height: defaultPadding / 2),
          ElevatedButton(
            key: const Key('signup_button'),  // Add this key
            onPressed: () {
              // Verificar si el formulario es válido antes de registrar al usuario
              if (_formKey.currentState!.validate()) {
                // Registro del usuario si las validaciones pasan
                Get.find<AuthController>().signUp(
                  emailController.text,
                  passwordController.text,
                );
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return const LoginScreen(); // Lleva al login después de registrarse
                    },
                  ),
                );
              }
            },
            child: Text("Sign Up".toUpperCase()),
          ),
          const SizedBox(height: defaultPadding),
          AlreadyHaveAnAccountCheck(
            login: false,
            press: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return const LoginScreen();
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
