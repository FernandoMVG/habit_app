import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habit_app/ui/controller/habit_controller.dart';
import 'package:habit_app/ui/pages/habits_pages/create_habits.dart';
import 'package:habit_app/ui/widgets/buttons.dart';
import 'package:habit_app/ui/pages/habits_pages/create_habits_quantity.dart';

class HabitTypeSelectionPage extends StatelessWidget {
  final HabitController habitController = Get.find<HabitController>(); // Accedemos al controlador ya inicializado

  HabitTypeSelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        automaticallyImplyLeading: false,  // Oculta el botón de back
        elevation: 0,  // Sin sombra
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Text(
                '¿Cómo quieres completar tu hábito?',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 50),

            ElevatedButton(
              onPressed: () {
                habitController.setHabitType(false); // Hábito no cuantificable
                Get.to(() => CreateHabitPage()); // Navega a la siguiente página
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.onPrimary,
                minimumSize: const Size(double.infinity, 60),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                side: BorderSide(
                  color: Theme.of(context).colorScheme.primary,
                  width: 2,
                ),
              ),
              child: Text(
                'Sí o No',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Bastará con tocar la actividad para marcarla como completada. Toca otra vez para desmarcarla.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 40),

            ElevatedButton(
              onPressed: () {
                habitController.setHabitType(true); // Hábito cuantificable
                Get.to(() => const QuantityHabitPage());
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.onPrimary,
                minimumSize: const Size(double.infinity, 60),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                side: BorderSide(
                  color: Theme.of(context).colorScheme.primary,
                  width: 2,
                ),
              ),
              child: Text(
                'Con una cantidad',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Elige la cantidad de veces que vas a realizar la actividad para considerarla completada.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const Spacer(),
            const CancelButton(),
          ],
        ),
      ),
    );
  }
}
