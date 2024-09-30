import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CalendarWidget extends StatelessWidget {
  const CalendarWidget({super.key});

  // Método para obtener la fecha del lunes de la semana actual
  DateTime _getStartOfWeek(DateTime date) {
    // DateTime.weekday: 1 (Monday) - 7 (Sunday)
    return date.subtract(Duration(days: date.weekday - 1));
  }

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final startOfWeek = _getStartOfWeek(today);

    // Generar la lista de 7 días de la semana
    List<DateTime> weekDays = List.generate(7, (index) {
      return startOfWeek.add(Duration(days: index));
    });

    // Obtener el ancho de la pantalla para hacer el widget responsive
    final screenWidth = MediaQuery.of(context).size.width;
    final dayWidth = (screenWidth - 20) / 7; // 20 es el padding total horizontal

    return Container(
      padding: const EdgeInsets.all(10.0),
      width: double.infinity,
      color: Colors.grey[200],
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: weekDays.map((date) {
            final isToday = _isSameDay(date, today);
            final dayAbbreviation = DateFormat.E('es').format(date); // Formato abreviado en español
            final dayNumber = date.day.toString();

            return _buildCalendarDay(dayAbbreviation, dayNumber, isToday, dayWidth);
          }).toList(),
        ),
      ),
    );
  }

  // Método para construir cada día del calendario
  Widget _buildCalendarDay(String day, String date, bool isSelected, double width) {
    return Container(
      width: width * 0.9, // Ajusta el ancho según sea necesario
      margin: const EdgeInsets.symmetric(horizontal: 5.0),
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFF2C3E50) : Colors.grey[300],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            day,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            date,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  // Método para comparar si dos fechas son el mismo día
  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }
}
