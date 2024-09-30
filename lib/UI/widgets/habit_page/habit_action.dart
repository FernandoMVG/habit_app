import 'package:flutter/material.dart';

class HabitActionsWidget extends StatelessWidget {
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const HabitActionsWidget({
    super.key,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<int>(
      onSelected: (value) {
        if (value == 1) {
          onEdit();
        } else if (value == 2) {
          onDelete();
        }
      },
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: 1,
          child: Text("Editar"),
        ),
        const PopupMenuItem(
          value: 2,
          child: Text("Eliminar"),
        ),
      ],
      icon: const Icon(Icons.more_vert),
    );
  }
}
