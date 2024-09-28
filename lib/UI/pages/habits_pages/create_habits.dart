import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habit_app/ui/controller/habit_controller.dart';  // Controlador de hábitos
//import 'next_habit_creation_step_page.dart';  // La página a la que navegará cuando presione continuar

class CreateHabitPage extends StatelessWidget {
  final HabitController habitController = Get.find<HabitController>();  // Controlador de hábitos
  final TextEditingController nameController = TextEditingController();  // Controlador para el nombre del hábito
  final TextEditingController descriptionController = TextEditingController();  // Controlador para la descripción del hábito

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:  const Color(0xFF2C3E50),
        automaticallyImplyLeading: false,  // Cambiamos el color del AppBar a azul (#2980B9)
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
            
            // Campo para ingresar el nombre del hábito con estilo personalizado
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Ingresa un nombre',
                labelStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,  // Texto en negrita y color negro
                ),
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  borderSide: BorderSide(
                    color: Colors.black,  // Borde en color negro y grueso
                    width: 2.0,
                  ),
                ),
                enabledBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  borderSide: BorderSide(
                    color: Colors.black,  // Borde en color negro y grueso
                    width: 2.0,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.primary,  // Borde de color primario del esquema de colores cuando esté en foco
                    width: 2.0,
                  ),
                ),
              ),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,  // Texto dentro del campo en negrita y negro
              ),
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
            
            // Campo para ingresar la descripción del hábito (opcional) con el mismo estilo
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(
                labelText: 'Agrega una descripción (opcional)',
                labelStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,  // Texto en negrita y color negro
                ),
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  borderSide: BorderSide(
                    color: Colors.black,  // Borde en color negro y grueso
                    width: 2.0,
                  ),
                ),
                enabledBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  borderSide: BorderSide(
                    color: Colors.black,  // Borde en color negro y grueso
                    width: 2.0,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.primary,  // Borde de color primario cuando esté en foco
                    width: 2.0,
                  ),
                ),
              ),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,  // Texto dentro del campo en negrita y negro
              ),
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
            
            // Botones de Cancelar y Continuar
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Botón de Atrás
                TextButton(
                  onPressed: () {
                    Get.back();  // Vuelve a la página anterior
                  },
                  child: const Text(
                    'Atrás',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2980B9),  // Como boton sin fondo (averiguar nombre)
                    ),
                  ),
                ),
                
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
