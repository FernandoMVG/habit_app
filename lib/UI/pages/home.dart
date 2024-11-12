import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habit_app/UI/widgets/calendar.dart';
import 'package:habit_app/UI/widgets/home_page/progress_bar.dart';
import 'package:habit_app/UI/widgets/routine/daily_routine.dart';
import 'package:habit_app/UI/widgets/shared/app_bar.dart';
import 'package:habit_app/UI/widgets/shared/empty_message.dart';
import 'package:habit_app/UI/widgets/home_page/navigation_bar.dart';
import 'package:habit_app/UI/pages/habits_pages/habit_type.dart';
import 'package:habit_app/UI/widgets/shared/fab_button.dart';
import 'package:habit_app/UI/controller/habit_controller.dart';
import 'package:habit_app/models/habit_model.dart';

class HomePage extends StatelessWidget {
  final habitController = Get.find<HabitController>();
  final int _currentIndex = 0;

  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: CustomAppBar(),
      body: Column(
        children: [
          CalendarWidget(),

          // Observar `simulatedDate` para actualizar automáticamente el contenido de hoy
          Obx(() {
            final simulatedDate = habitController.simulatedDate.value;
            return Expanded(
              child: StreamBuilder<List<Habit>>(
                stream: habitController.getTodayHabitsStream(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    print(snapshot.error);
                    return const Center(
                        child: Text('Error al cargar los hábitos.'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const EmptyStateMessageWidget(
                      message: 'No tienes hábitos para hoy',
                      subMessage: 'Prueba agregando uno nuevo :D',
                      icon: Icons.calendar_today,
                    );
                  } else {
                    final todayHabits = snapshot.data!;
                    if (todayHabits.isNotEmpty) {
                      return Column(
                        children: [
                          DailyProgressBar(), // Muestra la barra de progreso
                          const SizedBox(height: 20),
                          Expanded(
                              child:
                                  DailyRoutineWidget()), // Muestra la rutina diaria
                        ],
                      );
                    } else {
                      return const EmptyStateMessageWidget(
                        message: 'No tienes hábitos para hoy',
                        subMessage: 'Prueba agregando uno nuevo :D',
                        icon: Icons.calendar_today,
                      );
                    }
                  }
                },
              ),
            );
          }),
        ],
      ),
      floatingActionButton: CustomFabButton(
        onPressed: () {
          Get.to(() => HabitTypeSelectionPage());
        },
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _currentIndex,
      ),
    );
  }
}
