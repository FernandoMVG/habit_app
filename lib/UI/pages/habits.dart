import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habit_app/ui/pages/habits_pages/habit_type.dart';  // Importamos la página para escoger el tipo de hábito
import 'package:habit_app/ui/controller/habit_controller.dart';  // Controlador de hábitos
import 'package:habit_app/ui/widgets/navigation_bar.dart';  // Barra de navegación personalizada
import 'package:habit_app/ui/widgets/Empty_message.dart';  // Widget reutilizable para estados vacíos
import 'package:habit_app/ui/widgets/app_bar.dart';

class HabitPage extends StatefulWidget {

  const HabitPage({super.key});  
  @override
  State<HabitPage> createState() => _HabitPageState();
}

class _HabitPageState extends State<HabitPage> {
  final HabitController habitController = Get.put(HabitController());

  // Instanciamos el controlador
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: CustomAppBar(experience: 0),
      
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
          // Mostrar la lista de hábitos creados
          return ListView.builder(
            itemCount: habitController.habits.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(habitController.habits[index]),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    habitController.removeHabit(habitController.habits[index]);
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
        currentIndex: 1,  // Marcamos que estamos en la sección de "Hábitos"
        onTap: (index) {
          if (index == 0) {
            Get.back();  // Navegar de vuelta a la página de Home
          }
        },
      ),
    );
  }
}
