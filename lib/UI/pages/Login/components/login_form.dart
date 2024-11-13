// login_form.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '/constants.dart';
import '/UI/controller/auth_controller.dart';
import '../../Signup/signup_screen.dart';
import '../../home.dart';
import '/components/already_have_an_account_acheck.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    return Form(
      child: Column(
        children: [
          TextFormField(
            key: const Key('login_email_field'),  // Add this key
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              hintText: "Your email",
              prefixIcon: Icon(Icons.person),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: defaultPadding),
            child: TextFormField(
              key: const Key('login_password_field'),  // Add this key
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                hintText: "Your password",
                prefixIcon: Icon(Icons.lock),
              ),
            ),
          ),
          const SizedBox(height: defaultPadding),
          ElevatedButton(
            key: const Key('login_button'),  // Add this key
            onPressed: () async {
              // Verificar las credenciales
              bool isLoggedIn = await Get.find<AuthController>().logIn(
                emailController.text,
                passwordController.text,
              );
              if (isLoggedIn) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return const HomePage(); // Lleva a la página de inicio si el login es exitoso
                    },
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Invalid credentials"),
                  ),
                );
              }
            },
            child: Text("Login".toUpperCase()),
          ),
          const SizedBox(height: defaultPadding),
          AlreadyHaveAnAccountCheck(
            press: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return const SignUpScreen();
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
