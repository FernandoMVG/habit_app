import 'package:flutter/material.dart';

class CustomBottomSheet extends StatelessWidget {
  final Widget content; // Widget personalizado para el contenido
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const CustomBottomSheet({
    super.key,
    required this.content,  // Se espera un widget en lugar de textos individuales
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [

          content, // Aquí colocamos el widget personalizado que contiene los textos u otros elementos
          const SizedBox(height: 20),
          
          // Botones de Editar y Eliminar
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton.icon(
                icon: const Icon(Icons.edit, color: Colors.white),
                label: const Text('Editar'),
                onPressed: onEdit, // Llama a la función onEdit si se proporciona. Es pasada como parametro
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 12),
                ),
              ),
              ElevatedButton.icon(
                icon: const Icon(Icons.delete, color: Colors.white),
                label: const Text('Eliminar'),
                onPressed: onDelete, // Llama a la función onDelete si se proporciona. Es pasada como parametro
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.error,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 12),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
