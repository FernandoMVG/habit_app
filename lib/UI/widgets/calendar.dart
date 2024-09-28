import 'package:flutter/material.dart';

class CalendarWidget extends StatelessWidget {
  const CalendarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10.0),
      width: double.infinity,
      color: Colors.grey[200],
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildCalendarDay('Lun', '20', false),
            _buildCalendarDay('Mar', '21', true),
            _buildCalendarDay('Mié', '22', false),
            _buildCalendarDay('Jue', '23', false),
            _buildCalendarDay('Vie', '24', false),
            _buildCalendarDay('Sáb', '25', false),
            _buildCalendarDay('Dom', '26', false),
          ],
        ),
      ),
    );
  }

  Widget _buildCalendarDay(String day, String date, bool isSelected) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5.0),
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFF2C3E50) : Colors.grey[300],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
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
}
