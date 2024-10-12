import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habit_app/ui/widgets/calendar.dart';
import 'package:habit_app/ui/widgets/home_page/progress_bar.dart';
import 'package:habit_app/ui/widgets/routine/daily_routine.dart';
import 'package:habit_app/ui/widgets/shared/app_bar.dart';
import 'package:habit_app/ui/widgets/shared/empty_message.dart';
import 'package:habit_app/ui/widgets/home_page/navigation_bar.dart';
import 'package:habit_app/ui/pages/habits_pages/habit_type.dart';
import 'package:habit_app/ui/widgets/shared/fab_button.dart';
import 'package:habit_app/ui/controller/habit_controller.dart';
//import 'package:habit_app/UI/widgets/habit_list.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final int _currentIndex = 0;  // Para gestionar el índice seleccionado
  final HabitController habitController = Get.put(HabitController());
// Simulamos una lista de hábitos para el día actual
  final List<String> todayHabits = [];  // Si está vacía, no hay hábitos para hoy
  
  @override
  Widget build(BuildContext context) {
    //final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: const CustomAppBar(), // Usamos el AppBar personalizado
      
      body: Column(
        children: [
          // Usa el widget de calendario
          const CalendarWidget(),

          // Mostrar barra de progreso y rutina diaria
          Obx(() {
            // Verificar si hay hábitos para hoy
            final todayHabits = habitController.getTodayHabits();

            if (todayHabits.isNotEmpty) {
              return Expanded(
                child: Column(
                  children: [
                    DailyProgressBar(),  // Muestra la barra de progreso
                    const SizedBox(height: 20),
                    Expanded(child: DailyRoutineWidget()),  // Muestra la rutina diaria
                  ],
                ),
              );
            } else {
              // Si no hay hábitos, muestra el mensaje vacío
              return const Expanded(
                child: EmptyStateMessageWidget(
                  message: 'No tienes hábitos para hoy',
                  subMessage: 'Prueba agregando uno nuevo :D',
                  icon: Icons.calendar_today,
                ),
              );
            }
          }),
        ],
      ),

      // FAB para agregar hábito
      floatingActionButton: CustomFabButton(
        onPressed: () {
          Get.to(() => HabitTypeSelectionPage()); // Navega a la página correspondiente
        },
      ),

      // Aquí usas el CustomBottomNavigationBar
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _currentIndex,
      ),
    );
  }
}
