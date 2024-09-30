import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habit_app/ui/widgets/calendar.dart';
import 'package:habit_app/ui/widgets/home_page/progress_bar.dart';
import 'package:habit_app/ui/widgets/shared/app_bar.dart';
import 'package:habit_app/ui/widgets/shared/empty_message.dart';
import 'package:habit_app/ui/widgets/home_page/navigation_bar.dart';
import 'package:habit_app/ui/pages/habits.dart';
//import 'package:habit_app/UI/widgets/habit_list.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;  // Para gestionar el índice seleccionado

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

          // Verificar si hay hábitos
          if (todayHabits.isNotEmpty) ...[
            // Muestra la ProgressBar solo si hay hábitos para ese día
            const ProgressBarWidget(progress: 0.5),
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

      // FAB para agregar hábito
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        onPressed: () {
          setState(() {
            todayHabits.remove('Nuevo hábito');  // Agrega un nuevo hábito a la lista
          });
        },
        child: const Icon(Icons.add, size: 30),
      ),

      // Aquí usas el CustomBottomNavigationBar
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;  // Actualiza el índice cuando cambies de pantalla
          });
          // Lógica de navegación (opcional, dependiendo de cómo manejes las rutas)
          if (index == 1) {
            Get.to(() => HabitPage());  // Navegar a la pantalla de crear hábito
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
