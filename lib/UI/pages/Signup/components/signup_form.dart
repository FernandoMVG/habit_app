// signup_form.dart
import 'package:flutter/material.dart';
import 'package:habit_app/services/auth_service.dart';
import '/constants.dart';
import '/components/already_have_an_account_acheck.dart';
import '../../Login/login_screen.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key});

  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _formKey = GlobalKey<FormState>(); // Clave para el formulario
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nombreController =
      TextEditingController(); // Controlador para el nombre de usuario

  // Expresión regular para validar un correo electrónico
  final RegExp emailRegExp = RegExp(
    r'^[a-zA-Z0-9._]+@[a-zA-Z0-9]+\.[a-zA-Z]+',
  );

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: nombreController,
            keyboardType: TextInputType.name,
            textInputAction: TextInputAction.next,
            cursorColor: primaryColor,
            decoration: const InputDecoration(
              hintText: "Tu nombre",
              prefixIcon: Padding(
                padding: EdgeInsets.all(defaultPadding),
                child: Icon(Icons.person),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor, ingresa tu nombre';
              } else if (value.length > 10) {
                return 'Usa un nombre corto, máximo 10 caracteres';
              }
              return null;
            },
          ),
          const SizedBox(height: defaultPadding), // Espacio entre campos
          TextFormField(
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            cursorColor: primaryColor,
            decoration: const InputDecoration(
              hintText: "Tu correo electrónico",
              prefixIcon: Padding(
                padding: EdgeInsets.all(defaultPadding),
                child: Icon(Icons.email),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor, ingresa tu correo electrónico';
              } else if (!emailRegExp.hasMatch(value)) {
                return 'Ingresa un correo electrónico válido';
              }
              return null;
            },
          ),
          const SizedBox(height: defaultPadding), // Espacio entre campos
          TextFormField(
            controller: passwordController,
            textInputAction: TextInputAction.done,
            obscureText: true,
            cursorColor: primaryColor,
            decoration: const InputDecoration(
              hintText: "Tu contraseña",
              prefixIcon: Padding(
                padding: EdgeInsets.all(defaultPadding),
                child: Icon(Icons.lock),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor, ingresa tu contraseña';
              } else if (value.length < 6) {
                return 'La contraseña debe tener al menos 6 caracteres';
              }
              return null;
            },
          ),
          const SizedBox(height: defaultPadding), // Espacio antes del botón
          ElevatedButton(
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                await AuthService().signUp(
                  email: emailController.text,
                  password: passwordController.text,
                  nombre: nombreController.text, // Pasa el nombre a AuthService
                  context: context,
                );
              }
            },
            child: Text("Registrarse".toUpperCase()),
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
