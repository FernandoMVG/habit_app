import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habit_app/ui/widgets/text_field.dart';
import 'package:habit_app/ui/widgets/buttons.dart';
import 'package:habit_app/ui/controller/habit_controller.dart';  // Controlador de hábitos
//import 'next_habit_creation_step_page.dart';  // La página a la que navegará cuando presione continuar

class CreateHabitPage extends StatelessWidget {
  final HabitController habitController = Get.find<HabitController>();  // Controlador de hábitos
  final TextEditingController nameController = TextEditingController();  // Controlador para el nombre del hábito
  final TextEditingController descriptionController = TextEditingController();

  CreateHabitPage({super.key});  // Controlador para la descripción del hábito

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor:  Theme.of(context).scaffoldBackgroundColor,  // Color de la barra de navegación
        automaticallyImplyLeading: false,  // Oculta el botón de atrás
        elevation: 0,  // Color del AppBar para mayor contraste
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // Título centrado
            Center(
              child: Text(
                'Crea tu hábito',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 50),
            
            CustomTextField(
              controller: nameController,
              labelText: 'Nombre del hábito',              
            ),
            const SizedBox(height: 10),

            const Text(
              'Ejemplo: Estudiar compiladores',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black
              )
            ),
            const SizedBox(height: 40),
            
            CustomTextField(
              controller: descriptionController,
              labelText: 'Descripción del hábito',
            ),
            const SizedBox(height: 10),

            const Text(
              'Ejemplo: Repasar las formas de obtener un automata finito a partir de una e.r',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black
              )
            ),
            const Spacer(),
            
            // Botones de Atrás y Continuar
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Botón de Atrás
                BackButtonWidget(),
                
                // Botón de Continuar
                ElevatedButton(
                  onPressed: () {
                    if (nameController.text.isNotEmpty) {
                      // Añadir lógica para continuar solo si el nombre no está vacío
                      habitController.addHabit(nameController.text);  // Añadir el hábito al controlador
                      //Get.to(() => NextHabitCreationStepPage());  // Navegar a la siguiente página del proceso
                    } else {
                      // Mostrar un mensaje de error si el nombre está vacío
                      Get.snackbar(
                        'Error',
                        'El nombre del hábito es obligatorio',
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: Colors.red,
                        colorText: Colors.white,
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2980B9),  // Fondo azul claro
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Continuar',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,  // Texto en blanco
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
