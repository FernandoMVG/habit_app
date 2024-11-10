import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habit_app/UI/widgets/shared/buttons.dart';
import 'package:habit_app/UI/widgets/shared/text_field.dart';
import 'package:habit_app/UI/controller/habit_controller.dart';
import 'package:habit_app/UI/pages/habits_pages/choose_category.dart';
import 'package:habit_app/constants.dart'; // Importar los colores y estilos

class QuantityHabitPage extends StatefulWidget {
  const QuantityHabitPage({super.key});

  @override
  State<QuantityHabitPage> createState() => _QuantityHabitPageState();
}

class _QuantityHabitPageState extends State<QuantityHabitPage> {
  final HabitController habitController = Get.find<HabitController>();

  final TextEditingController quantityController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController unitController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  String selectedQuantificationType = 'Exactamente';
  final List<String> quantificationOptions = [
    'Exactamente',
    'Sin especificar',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        automaticallyImplyLeading: false,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(defaultPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      'Crea tu hábito',
                      style: titleTextStyle.copyWith(
                        fontSize: 32,
                        color: primaryColor,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(height: 50),

                  CustomTextField(
                    controller: nameController,
                    labelText: 'Nombre del hábito',
                  ),
                  const SizedBox(height: 10),

                  _buildExampleText('Ejemplo: Tomar agua', context),
                  const SizedBox(height: 10),

                  CustomTextField(
                    controller: descriptionController,
                    labelText: 'Descripción del hábito',
                  ),
                  const SizedBox(height: 10),

                  _buildExampleText(
                    'Ejemplo: Repasar formas de obtener un autómata finito.',
                    context,
                  ),
                  const SizedBox(height: 20),

                  const Text(
                    'Escoge la frecuencia con la que quieres realizarlo',
                    style: bodyTextStyle,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),

                  Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              value: selectedQuantificationType,
                              decoration: InputDecoration(
                                labelText: 'Selecciona una opción',
                                filled: true,
                                fillColor: cardBackgroundColor,
                                labelStyle: bodyTextStyle,
                                border: _buildInputBorder(),
                                enabledBorder: _buildInputBorder(),
                                focusedBorder: _buildFocusedInputBorder(context),
                              ),
                              items: quantificationOptions.map((option) {
                                return DropdownMenuItem(
                                  value: option,
                                  child: Text(option, style: bodyTextStyle),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  selectedQuantificationType = value!;
                                  if (value == 'Sin especificar') {
                                    quantityController.clear();
                                    unitController.clear();
                                  }
                                });
                              },
                            ),
                          ),
                          const SizedBox(width: 10),

                          Expanded(
                            child: CustomTextField(
                              controller: quantityController,
                              labelText: 'Cantidad',
                              enabled: selectedQuantificationType != 'Sin especificar',
                              keyboardType: TextInputType.number, // Add numeric keyboard
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: CustomTextField(
                              controller: unitController,
                              labelText: 'Unidad',
                              enabled: selectedQuantificationType != 'Sin especificar',
                            ),
                          ),
                          const SizedBox(width: 10),
                          const Expanded(
                            child: Text(
                              'en el día.',
                              textAlign: TextAlign.center,
                              style: bodyTextStyle,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  _buildExampleText(
                    'Ejemplo: Al menos 8 vasos en el día.',
                    context,
                  ),
                ],
              ),
            ),
          ),
          // Botones al final de la pantalla
          Padding(
            padding: const EdgeInsets.all(defaultPadding),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const BackButtonWidget(),
                NavigateButton(
                  text: 'Continuar',
                  onPressed: () {
                    if (_validateInput()) {
                      _saveHabitData();
                      Get.to(() => const ChooseCategoryPage());
                    } else {
                      _showErrorSnackbar(context);
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExampleText(String text, BuildContext context) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: subtitleTextStyle,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  bool _validateInput() {
    return nameController.text.isNotEmpty &&
        (quantityController.text.isNotEmpty ||
            selectedQuantificationType == 'Sin especificar');
  }

  void _saveHabitData() {
    habitController.setHabitName(nameController.text);
    habitController.setHabitDescription(
      descriptionController.text.isNotEmpty ? descriptionController.text : null,
    );
    habitController.setQuantificationType(selectedQuantificationType);
    habitController.setQuantity(
      selectedQuantificationType != 'Sin especificar'
          ? int.tryParse(quantityController.text) ?? 0
          : null,
    );
    habitController.setUnit(
      selectedQuantificationType != 'Sin especificar' &&
              unitController.text.isNotEmpty
          ? unitController.text
          : null,
    );
  }

  void _showErrorSnackbar(BuildContext context) {
    Get.snackbar(
      'Error',
      'Debes ingresar una cantidad o seleccionar "Sin especificar".',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: errorColor,
      colorText: onPrimaryColor,
    );
  }

  OutlineInputBorder _buildInputBorder() {
    return const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(10.0)),
      borderSide: BorderSide(color: blackColor, width: 2.0),
    );
  }

  OutlineInputBorder _buildFocusedInputBorder(BuildContext context) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.0),
      borderSide: BorderSide(
        color: Theme.of(context).colorScheme.primary,
        width: 2.0,
      ),
    );
  }
}
