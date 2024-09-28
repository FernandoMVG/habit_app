import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habit_app/ui/controller/habit_controller.dart';
import 'package:habit_app/ui/pages/habits_pages/create_habits.dart';
import 'package:habit_app/ui/widgets/buttons.dart';

class HabitTypeSelectionPage extends StatelessWidget {
  final HabitController habitTypeController = Get.put(HabitController());

  HabitTypeSelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        automaticallyImplyLeading: false,  // Cambiamos el color del AppBar a azul (#2980B9)
        elevation: 0,  // Sin sombra
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Título centrado
            Center(
              child: Text(
                '¿Cómo quieres completar tu hábito?',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                textAlign: TextAlign.center,  // Centrar el texto
              ),
            ),
            const SizedBox(height: 50),  // Espacio entre título y los botones

            // Opción "Sí o No" (botón ancho con esquinas redondeadas)
            ElevatedButton(
              onPressed: () {
                habitTypeController.setHabitType(false);  // No cuantificable
                Get.to(() => CreateHabitPage());  // Navegar a la página de creación del hábito
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE6E6E6),  // Color del botón (#E6E6E6)
                minimumSize: const Size(double.infinity, 60),  // Ocupa todo el ancho de la pantalla
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),  // Esquinas redondeadas
                ),
              ),
              child: Text(
                'Sí o No',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,  // Color de las letras (#2980B9)
                ),
              ),
            ),
            const SizedBox(height: 10),
            // Texto explicativo de "Sí o No"
            Text(
              'Bastará con tocar la actividad para marcarla como completada. Toca otra vez para desmarcarla.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 40),  // Espacio entre los botones

            // Opción "Con una cantidad" (botón ancho con esquinas redondeadas)
            ElevatedButton(
              onPressed: () {
                habitTypeController.setHabitType(true);  // Cuantificable
                Get.to(() => CreateHabitPage());  // Navegar a la página de creación del hábito
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE6E6E6),  // Color del botón (#E6E6E6)
                minimumSize: const Size(double.infinity, 60),  // Ocupa todo el ancho de la pantalla
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),  // Esquinas redondeadas
                ),
              ),
              child: Text(
                'Con una cantidad',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,  // Color de las letras parametrizado
                ),
              ),
            ),
            const SizedBox(height: 10),
            // Texto explicativo de "Con una cantidad"
            Text(
              'Elige la cantidad de veces que vas a realizar la actividad para considerarla completada. Podrás asignar la unidad acorde a la actividad.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const Spacer(),  // Empuja el botón "Cancelar" hacia abajo

            // Botón "Cancelar" cuadrado con esquinas redondeadas en rojo
            const CancelButton()
          ],
        ),
      ),
    );
  }
}