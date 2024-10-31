import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habit_app/UI/widgets/shared/text_field.dart';
import 'package:habit_app/UI/widgets/shared/buttons.dart';
import 'package:habit_app/UI/controller/habit_controller.dart';  
import 'package:habit_app/UI/pages/habits_pages/choose_category.dart';

class CreateHabitPage extends StatelessWidget {
  final HabitController habitController = Get.find<HabitController>();
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
