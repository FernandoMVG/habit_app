import 'package:flutter/material.dart';
import 'package:habit_app/ui/widgets/shared/text_field.dart';

class HabitEditWidget extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController descriptionController;

  const HabitEditWidget({
    super.key,
    required this.nameController,
    required this.descriptionController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomTextField(
          controller: nameController,
          labelText: 'Editar nombre',
        ),
        const SizedBox(height: 20),
        CustomTextField(
          controller: descriptionController,
          labelText: 'Editar descripción',
        ),
      ],
    );
  }
}
