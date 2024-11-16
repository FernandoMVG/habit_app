import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import 'package:habit_app/UI/controller/habit_controller.dart';
import 'package:habit_app/constants.dart';

class CalendarWidget extends StatelessWidget {
  final HabitController habitController = Get.find<HabitController>();

  CalendarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final today = habitController.simulatedDate.value; // Usamos la fecha simulada.
      final startOfWeek = _getStartOfWeek(today);

      // Generamos la lista de 7 días de la semana basados en la fecha simulada
      List<DateTime> weekDays = List.generate(7, (index) {
        return startOfWeek.add(Duration(days: index));
      });

      return Container(
        padding: const EdgeInsets.all(10.0),
        color: secondaryColor, // Fondo del calendario
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: weekDays.map((date) {
            final isToday = _isSameDay(date, today); // Verificar si es el día actual
            final dayAbbreviation = DateFormat.E('es').format(date); // Ej: "Lun"
            final dayNumber = date.day.toString();
            final monthAbbreviation = DateFormat.MMM('es').format(date); // Ej: "Ene"

            return Expanded(
              child: GestureDetector(
                onTap: () {
                  habitController.simulatedDate.value = date; // Cambiar la fecha simulada
                },
                child: _buildCalendarDay(
                  dayAbbreviation,
                  dayNumber,
                  monthAbbreviation,
                  isToday, // Indica si este día es el actual
                ),
              ),
            );
          }).toList(),
        ),
      );
    });
  }

  // Método para obtener la fecha del lunes de la semana actual
  DateTime _getStartOfWeek(DateTime date) {
    return date.subtract(Duration(days: date.weekday - 1));
  }

  // Método para construir cada día del calendario
  Widget _buildCalendarDay(String day, String date, String month, bool isToday) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 2.0, vertical: 4.0), // Adjust margins for better fit
      padding: const EdgeInsets.all(8.0), // Adjust padding for better fit
      decoration: BoxDecoration(
        color: isToday ? primaryColor : cardBackgroundColor, // Cambiar color si es el día actual
        borderRadius: BorderRadius.circular(defaultRadius),
        boxShadow: const [
          BoxShadow(
            color: cardShadowColor,
            blurRadius: 4.0,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            month,
            style: TextStyle(
              color: isToday ? onPrimaryColor : onSurfaceColor,
              fontWeight: FontWeight.bold,
              fontSize: 10, // Adjust font size for better fit
            ),
          ),
          const SizedBox(height: 3), // Adjust spacing for better fit
          Text(
            date,
            style: TextStyle(
              color: isToday ? onPrimaryColor : blackColor,
              fontWeight: FontWeight.bold,
              fontSize: 20, // Adjust font size for better fit
            ),
          ),
          const SizedBox(height: 3), // Adjust spacing for better fit
          Text(
            day,
            style: TextStyle(
              color: isToday ? onPrimaryColor : blackColor,
              fontWeight: FontWeight.bold,
              fontSize: 14, // Adjust font size for better fit
            ),
          ),
        ],
      ),
    );
  }

  // Método para verificar si dos fechas son el mismo día
  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }
}
