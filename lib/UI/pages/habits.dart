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

  // Función para mostrar un BottomSheet con detalles del hábito
  void _showBottomSheet(BuildContext context, Habit habit) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (BuildContext context) {
      return CustomBottomSheet(
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            
            // Encabezado del nombre del hábito
            Text(
              habit.name,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
            ),
            const SizedBox(height: 10),
            
            // Categoría del hábito
            RichText(
              text: TextSpan(
                text: 'Categoría: ',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).textTheme.bodyLarge?.color,
                    ),
                children: [
                  TextSpan(
                    text: habit.categoryName,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: habit.categoryColor,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            
            // Días seleccionados
            RichText(
              text: TextSpan(
                text: 'Días seleccionados: ',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).textTheme.bodyLarge?.color,
                    ),
                children: [
                  TextSpan(
                    text: habit.selectedDays?.join(', ') ?? "Ninguno",
                    style: const TextStyle(fontWeight: FontWeight.normal),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            
            // Descripción del hábito
            if (habit.description != null && habit.description!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: RichText(
                  text: TextSpan(
                    text: 'Descripción: ',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).textTheme.bodyLarge?.color,
                        ),
                    children: [
                      TextSpan(
                        text: habit.description,
                        style: const TextStyle(fontWeight: FontWeight.normal),
                      ),
                    ],
                  ),
                ),
              ),
            const SizedBox(height: 20),
          ],
        ),
        // Pasar las funciones de editar y eliminar como parametros para el widget (controladores)
        onEdit: () {
          // Lógica para editar el hábito
          Get.back();  // Cierra el BottomSheet
        },
        onDelete: () {
          // Lógica para eliminar el hábito
          habitController.removeHabit(habit);
          Get.back();  // Cierra el BottomSheet
        },
      );
    },
  );
}
}