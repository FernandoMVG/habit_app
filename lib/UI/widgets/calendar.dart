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

            return Expanded(
              child: GestureDetector(
                onTap: () {
                  habitController.simulatedDate.value = date; // Cambiar la fecha simulada
                },
                child: _buildCalendarDay(
                  dayAbbreviation,
                  dayNumber,
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
  Widget _buildCalendarDay(String day, String date, bool isToday) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      decoration: BoxDecoration(
        color: isToday ? primaryColor : cardBackgroundColor, // Cambiar color si es el día actual
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: cardShadowColor.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3), // Sombra sutil debajo del día
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            day,
            style: TextStyle(
              color: isToday ? onPrimaryColor : blackColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            date,
            style: TextStyle(
              color: isToday ? onPrimaryColor : blackColor,
              fontWeight: FontWeight.bold,
              fontSize: 16,
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
