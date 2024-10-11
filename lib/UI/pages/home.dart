import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habit_app/UI/widgets/progress_bar2.dart';
import 'package:habit_app/ui/widgets/calendar.dart';
import 'package:habit_app/ui/widgets/app_bar.dart';
import 'package:habit_app/ui/widgets/Empty_message.dart';
import 'package:habit_app/ui/widgets/navigation_bar.dart';
import 'package:habit_app/ui/pages/habits.dart';

class Habit {
  final String name;
  final String category;
  final Color color;
  bool isCompleted;

  Habit({
    required this.name,
    required this.category,
    required this.color,
    this.isCompleted = false,
  });
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0; // Para gestionar el índice seleccionado
  DateTime selectedDate = DateTime.now(); // Día seleccionado para las pruebas

  // Mapa para guardar el estado de completado de los días en el calendario
  final Map<DateTime, bool> completedDays = {};

  // ** Nueva variable para la experiencia del usuario **
  int experience = 0;

  // Lista de hábitos predefinidos
  final List<Habit> todayHabits = [
    Habit(name: 'Leer 30 minutos', category: 'Educación', color: Colors.yellow),
    Habit(name: 'Correr 5 km', category: 'Salud', color: Colors.red),
    Habit(name: 'Beber 2L de agua', category: 'Salud', color: Colors.blue),
    Habit(name: 'Meditar 10 minutos', category: 'Bienestar', color: Colors.green),
  ];

  // Método para calcular el progreso
  double calculateProgress() {
    int completedHabits = todayHabits.where((habit) => habit.isCompleted).length;
    return completedHabits / todayHabits.length;
  }

  // Método para avanzar al día siguiente y guardar el estado del día anterior
  void goToNextDay() {
    bool allHabitsCompleted = calculateProgress() == 1.0;

    // Si todos los hábitos del día actual están completados, aumentar la experiencia
    if (allHabitsCompleted) {
      setState(() {
        experience += 20; // Añadir 20 puntos de experiencia
      });
    }

    // Guardar el estado de completado del día actual en el mapa
    setState(() {
      completedDays[selectedDate] = allHabitsCompleted;
      selectedDate = selectedDate.add(const Duration(days: 1)); // Avanzar al siguiente día
    });

    // Resetear los hábitos para el nuevo día
    for (var habit in todayHabits) {
      habit.isCompleted = false; // Reiniciar los hábitos
    }
  }

  @override
  Widget build(BuildContext context) {
    double progress = calculateProgress(); // Calcular el progreso actual
    bool allHabitsCompleted = progress == 1.0; // Verificar si todos los hábitos están completados

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,

      // Pasamos la experiencia actual al CustomAppBar
      appBar: CustomAppBar(experience: experience),

      body: Column(
        children: [
          // Usa el widget de calendario con los colores según el estado de completado
          CalendarWidget(
            allHabitsCompleted: allHabitsCompleted,
            selectedDate: selectedDate,
            completedDays: completedDays,
          ),

          // Verificar si hay hábitos
          if (todayHabits.isNotEmpty) ...[
            // Muestra la ProgressBar solo si hay hábitos para ese día
            ProgressBarWidget2(progress: progress),
            const SizedBox(height: 10),
            const Text(
              'Tu progreso',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: todayHabits.length,
                itemBuilder: (context, index) {
                  final habit = todayHabits[index];
                  return ListTile(
                    leading: Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: habit.color,
                      ),
                    ),
                    title: Text(habit.name),
                    subtitle: Text(habit.category),
                    trailing: GestureDetector(
                      onTap: () {
                        setState(() {
                          habit.isCompleted = !habit.isCompleted; // Marcar o desmarcar el hábito
                        });
                      },
                      child: Icon(
                        habit.isCompleted ? Icons.check_circle : Icons.radio_button_unchecked,
                        color: habit.isCompleted ? Colors.green : Colors.grey,
                      ),
                    ),
                  );
                },
              ),
            ),
          ] else ...[
            // Si no hay hábitos, muestra el mensaje vacío
            const Expanded(
              child: EmptyStateMessageWidget(
                message: 'No tienes hábitos',
                subMessage: 'Prueba agregando uno nuevo :D',
                icon: Icons.calendar_today,
              ),
            ),
          ],
        ],
      ),

      // Botón flotante para avanzar al día siguiente
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        onPressed: goToNextDay, // Función para avanzar al día siguiente
        child: const Icon(Icons.arrow_forward, size: 30),
      ),

      // Aquí usas el CustomBottomNavigationBar
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index; // Actualiza el índice cuando cambies de pantalla
          });
          // Lógica de navegación (opcional, dependiendo de cómo manejes las rutas)
          if (index == 1) {
            Get.to(() => HabitPage()); // Navegar a la pantalla de crear hábito
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
}
