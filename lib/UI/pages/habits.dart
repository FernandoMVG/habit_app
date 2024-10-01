import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habit_app/models/habit_model.dart';
import 'package:habit_app/ui/controller/habit_controller.dart';
import 'package:habit_app/ui/widgets/home_page/navigation_bar.dart';
import 'package:habit_app/ui/widgets/shared/empty_message.dart';
import 'package:habit_app/ui/widgets/shared/app_bar.dart';
import 'package:habit_app/ui/widgets/habit_page/habit.dart'; // Nuevo HabitCardWidget
import 'package:habit_app/ui/pages/home.dart';
import 'package:habit_app/ui/pages/habits_pages/habit_type.dart';
import 'package:habit_app/ui/widgets/shared/bottom_sheet.dart';
import 'package:habit_app/ui/widgets/habit_page/habit_details.dart';
import 'package:habit_app/ui/widgets/habit_page/habit_edit.dart';

class HabitPage extends StatefulWidget {
  const HabitPage({super.key});

  @override
  State<HabitPage> createState() => _HabitPageState();
}

class _HabitPageState extends State<HabitPage> {
  final HabitController habitController = Get.put(HabitController()); // Instanciamos el controlador
  int _currentIndex = 1;  // Para gestionar el índice seleccionado

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: const CustomAppBar(),

      body: Obx(() {
        // Verificar si hay hábitos
        if (habitController.habits.isEmpty) {
          // Mostrar el mensaje de que no hay hábitos creados
          return const EmptyStateMessageWidget(
            message: 'No tienes ningún hábito...',
            subMessage: 'Prueba agregando uno nuevo :D',
            icon: Icons.check_circle_outline,
          );
        } else {
          // Mostrar la lista de hábitos creados utilizando el nuevo HabitCardWidget
          return ListView.builder(
            itemCount: habitController.habits.length,
            itemBuilder: (context, index) {
              final habit = habitController.habits[index];

              return GestureDetector(
                onTap: () {
                  _showBottomSheet(context, habit); // Muestra el BottomSheet al hacer tap en la tarjeta
                },
                child: HabitCardWidget(
                  habitName: habit.name,
                  categoryName: habit.categoryName,
                  categoryIcon: Icons.category,  // Podrías cambiar este ícono según la categoría si tienes un icono específico
                  categoryColor: habit.categoryColor,
                  isQuantifiable: habit.isQuantifiable,
                  currentProgress: habit.isQuantifiable ? habit.completedCount : null,
                  totalProgress: habit.isQuantifiable ? habit.targetCount : null,
                  isDaily: habit.isDaily,
                  selectedDays: habit.selectedDays,
                  onEdit: () {
                    // Lógica para editar el hábito desde el botón de editar dentro del BottomSheet
                    _showBottomSheet(context, habit);
                  },
                  onDelete: () {
                    habitController.removeHabit(habit);
                  },
                ),
              );
            },
          );
        }
      }),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        onPressed: () {
          // Navegar a la página de selección de tipo de hábito
          Get.to(() => HabitTypeSelectionPage());
        },
        child: const Icon(Icons.add, size: 30),
      ),

      // Barra de navegación reutilizada
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _currentIndex,  // Marcamos que estamos en la sección de "Hábitos"
        onTap: (index) {
          setState(() {
            _currentIndex = index;  // Actualiza el índice cuando cambies de pantalla
          });
          // Lógica de navegación
          if (index == 0) {
            Get.to(() => const HomePage());  // Navegar a la pantalla de Home
          } else if (index == 2) {
            // Navegar a la pantalla de categorías
          } else if (index == 3) {
            // Navegar a la pantalla de logros
          } else if (index == 4) {
            // Navegar a la pantalla de retos
          }
        },
      ),
    );
  }

  void _showBottomSheet(BuildContext context, Habit habit) {
  final TextEditingController nameController = TextEditingController(text: habit.name);
  final TextEditingController descriptionController = TextEditingController(text: habit.description ?? '');

  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    isScrollControlled: true,
    builder: (BuildContext context) {
      return CustomBottomSheet(
        content: HabitDetailsWidget(habit: habit),
        editContent: HabitEditWidget(
          nameController: nameController,
          descriptionController: descriptionController,
        ),
        onEdit: () {
          // Activar modo edición
        },
        onDelete: () {
          habitController.removeHabit(habit);
          Get.back();
        },
        onSave: () {
          habitController.updateHabit(
            habit,
            nameController.text.isNotEmpty ? nameController.text : habit.name,
            descriptionController.text.isNotEmpty ? descriptionController.text : habit.description ?? "",
          );
          Get.back();  // Cierra el BottomSheet después de guardar
        },
      );
    },
  );
}
}
