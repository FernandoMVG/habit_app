import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habit_app/ui/widgets/text_field.dart';
import 'package:habit_app/ui/widgets/buttons.dart';
import 'package:habit_app/ui/controller/habit_controller.dart';  // Controlador de hábitos
import 'package:habit_app/ui/pages/habits_pages/choose_category.dart';  // La página a la que navegará cuando presione continuar

class CreateHabitPage extends StatelessWidget {
  final HabitController habitController = Get.find<HabitController>(); // Accedemos al controlador de hábitos
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  CreateHabitPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor, 
        automaticallyImplyLeading: false, 
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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

            // Ejemplo de cómo llenar el campo
            Text(
              'Ejemplo: Estudiar compiladores',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).textTheme.labelSmall?.color,
              ),
            ),
            const SizedBox(height: 40),
            CustomTextField(
              controller: descriptionController,
              labelText: 'Descripción del hábito',
            ),
            const SizedBox(height: 10),

            // Ejemplo de cómo llenar el campo
            Text(
              'Ejemplo: Repasar formas de obtener un automata finito.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).textTheme.labelSmall?.color,
              ),
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const BackButtonWidget(),
                NavigateButton(
                  text: 'Continuar',
                  onPressed: () {
                    if (nameController.text.isNotEmpty) {
                      habitController.setHabitName(nameController.text);
                      habitController.setHabitDescription(descriptionController.text.isNotEmpty ? descriptionController.text : null);
                      Get.to(() => const ChooseCategoryPage());
                    } else {
                      Get.snackbar(
                        'Error',
                        'El nombre del hábito es obligatorio',
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: Theme.of(context).colorScheme.error,
                        colorText: Theme.of(context).textTheme.labelLarge?.color,
                      );
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
