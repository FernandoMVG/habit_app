import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habit_app/ui/widgets/shared/buttons.dart';
import 'package:habit_app/ui/pages/habits.dart';
import 'package:habit_app/ui/controller/habit_controller.dart';

class ChooseFrequencyPage extends StatefulWidget {
  final Color categoryColor;

  const ChooseFrequencyPage({super.key, required this.categoryColor});

  @override
  State<ChooseFrequencyPage> createState() => _ChooseFrequencyPageState();
}

class _ChooseFrequencyPageState extends State<ChooseFrequencyPage> {
  bool isDailySelected = false; // Para el botón de "Todos los días"
  List<String> selectedDays = []; // Para los días seleccionados de la semana
  final List<String> weekDays = ['Lun', 'Mar', 'Mie', 'Jue', 'Vie', 'Sab', 'Dom'];

  final HabitController habitController = Get.find<HabitController>();

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
                      color: Theme.of(context).colorScheme.primary,
                    ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 50),

            // Botón para seleccionar "Todos los días"
            _buildChoiceButton(
              context: context,
              text: 'Todos los días',
              isSelected: isDailySelected,
              icon: Icons.check_circle,
              onPressed: () {
                setState(() {
                  isDailySelected = true;
                  selectedDays.clear(); // Limpiamos los días seleccionados.
                });
              },
            ),
            const SizedBox(height: 20),

            // Botón para seleccionar "Días de la semana"
            _buildChoiceButton(
              context: context,
              text: 'Días de la semana',
              isSelected: !isDailySelected,
              icon: Icons.calendar_today,
              onPressed: () {
                setState(() {
                  isDailySelected = false;
                });
              },
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
                      color: isSelected
                          ? Theme.of(context).colorScheme.onPrimary
                          : widget.categoryColor,
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
                      Get.off(() => const HabitPage());
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

  // Widget para construir botones de selección con estilo alternado.
  Widget _buildChoiceButton({
    required BuildContext context,
    required String text,
    required bool isSelected,
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        elevation: 0,
        backgroundColor: isSelected ? widget.categoryColor : Colors.transparent,
        side: BorderSide(
          color: widget.categoryColor,
          width: 2.0,
        ),
        minimumSize: const Size(double.infinity, 60),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            text,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isSelected
                  ? Theme.of(context).colorScheme.onPrimary
                  : widget.categoryColor,
            ),
          ),
          Icon(
            icon,
            color: isSelected
                ? Theme.of(context).colorScheme.onPrimary
                : widget.categoryColor,
          ),
        ],
      ),
    );
  }
}
