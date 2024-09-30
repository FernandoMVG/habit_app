import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habit_app/ui/widgets/shared/buttons.dart';
import 'package:habit_app/ui/pages/habits.dart';
import 'package:habit_app/ui/controller/habit_controller.dart';

class ChooseFrequencyPage extends StatefulWidget {
  final Color categoryColor;

  const ChooseFrequencyPage({super.key, required this.categoryColor});

  @override
  _ChooseFrequencyPageState createState() => _ChooseFrequencyPageState();
}

class _ChooseFrequencyPageState extends State<ChooseFrequencyPage> {
  bool isDailySelected = false; // Para el botón de "Todos los días"
  List<String> selectedDays = []; // Para los días seleccionados de la semana
  final List<String> weekDays = ['Lun', 'Mar', 'Mié', 'Jue', 'Vie', 'Sáb', 'Dom'];

  final HabitController habitController = Get.find<HabitController>(); // Accedemos al controlador

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
          children: [

            // Título centrado
            Center(
              child: Text(
                'Escoge tu frecuencia',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 50),

            // Botón para seleccionar "Todos los días"
            ElevatedButton(
              onPressed: () {
                setState(() {
                  isDailySelected = true;
                  selectedDays.clear(); // Limpiamos los días de la semana seleccionados
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: isDailySelected ? widget.categoryColor : Theme.of(context).colorScheme.primary,
                minimumSize: const Size(double.infinity, 60),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Todos los días',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Icon(Icons.check_circle, color: Theme.of(context).colorScheme.onPrimary),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Botón para seleccionar "Días de la semana"
            ElevatedButton(
              onPressed: () {
                setState(() {
                  isDailySelected = false;
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: !isDailySelected ? widget.categoryColor : Theme.of(context).colorScheme.primary,
                minimumSize: const Size(double.infinity, 60),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Días de la semana',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Icon(Icons.calendar_today, color: Theme.of(context).colorScheme.onPrimary),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Cuadro para seleccionar los días de la semana
            if (!isDailySelected)
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 8.0,
                children: weekDays.map((day) {
                  final isSelected = selectedDays.contains(day);
                  return ChoiceChip(
                    label: Text(day),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        if (selected) {
                          selectedDays.add(day);
                        } else {
                          selectedDays.remove(day);
                        }
                      });
                    },
                    selectedColor: widget.categoryColor,
                    backgroundColor: Theme.of(context).colorScheme.onPrimary,
                    labelStyle: TextStyle(
                      color: isSelected ? Theme.of(context).colorScheme.onPrimary : widget.categoryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                }).toList(),
              ),
            const Spacer(),

            // Botones de "Cancelar" y "Finalizar"
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const BackButtonWidget(),
                NavigateButton(
                  text: 'Finalizar',
                  onPressed: () {
                    if (selectedDays.isNotEmpty || isDailySelected) {
                      habitController.setFrequency(
                        isDaily: isDailySelected,
                        days: isDailySelected ? null : selectedDays,
                      );
                      habitController.addHabit();
                      Get.off(() => HabitPage()); // Regresa a la página de hábitos
                    }
                  },
                  isEnabled: selectedDays.isNotEmpty || isDailySelected,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
