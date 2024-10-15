// habit_app/ui/widgets/habit_list.dart

import 'package:flutter/material.dart';

class HabitListWidget extends StatelessWidget {
  final List<String> habits;
  final Function(String) onDelete;

  const HabitListWidget({
    Key? key,
    required this.habits,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: habits.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(habits[index]),
          trailing: IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              onDelete(habits[index]); // Llama a la función para eliminar el hábito
            },
          ),
        );
      },
    );
  }
}
