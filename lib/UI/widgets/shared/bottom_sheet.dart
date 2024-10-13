import 'package:flutter/material.dart';

class CustomBottomSheet extends StatefulWidget {
  final Widget content;
  final Widget editContent;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onSave;
  final int? currentStreak;  // Racha actual (opcional)
  final int? longestStreak;  // Racha más larga (opcional)

  const CustomBottomSheet({
    super.key,
    required this.content,     // Contenido estándar
    required this.editContent, // Contenido en modo de edición
    required this.onEdit,      // Acción para editar
    required this.onDelete,    // Acción para eliminar
    required this.onSave,      // Acción para guardar cambios
    this.currentStreak,        // Racha actual opcional
    this.longestStreak,        // Racha más larga opcional
  });

  @override
  State<CustomBottomSheet> createState() => _CustomBottomSheetState();
}

class _CustomBottomSheetState extends State<CustomBottomSheet> {
  bool isEditing = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Mostrar contenido según el estado de edición
          isEditing
              ? SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: widget.editContent,
                )
              : SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: widget.content,
                ),

          const SizedBox(height: 20),

          // Botones de acciones
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              if (!isEditing)
                ElevatedButton.icon(
                  icon: Icon(Icons.edit, color: Theme.of(context).colorScheme.onPrimary),
                  label: const Text('Editar'),
                  onPressed: () {
                    setState(() {
                      isEditing = true;
                    });
                    widget.onEdit();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                ),
              if (!isEditing)
                ElevatedButton.icon(
                  icon: Icon(Icons.delete, color: Theme.of(context).colorScheme.onPrimary),
                  label: const Text('Eliminar'),
                  onPressed: widget.onDelete,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.error,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                ),
              if (isEditing)
                ElevatedButton.icon(
                  icon: Icon(Icons.save, color: Theme.of(context).colorScheme.onPrimary),
                  label: const Text('Guardar'),
                  onPressed: () {
                    widget.onSave();
                    setState(() {
                      isEditing = false;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}