import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habit_app/ui/widgets/shared/buttons.dart';
import 'package:habit_app/ui/widgets/shared/text_field.dart';
import 'package:habit_app/ui/controller/habit_controller.dart';
import 'package:habit_app/ui/pages/habits_pages/choose_category.dart';

class QuantityHabitPage extends StatefulWidget {
  const QuantityHabitPage({super.key});

  @override
  State<QuantityHabitPage> createState() => _QuantityHabitPageState();
}

class _QuantityHabitPageState extends State<QuantityHabitPage> {
  final HabitController habitController = Get.find<HabitController>();

  // Controladores para los campos de cantidad y unidad
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController unitController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  String selectedQuantificationType = 'Al menos';
  final List<String> quantificationOptions = [
    'Al menos',
    'Menos de',
    'Exactamente',
    'Más de',
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
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                'Crea tu hábito',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 50),

            // Campo de texto para el nombre del hábito
            CustomTextField(
              controller: nameController,
              labelText: 'Nombre del hábito',
            ),
            const SizedBox(height: 10),
            
            // Texto de ejemplo para el nombre del hábito
            Text(
              'Ejemplo: Tomar agua',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).textTheme.labelSmall?.color,
              ),
            ),
            const SizedBox(height: 10),

            // Campo de texto para la descripción del hábito
            CustomTextField(
              controller: descriptionController,
              labelText: 'Descripción del hábito',
            ),
            const SizedBox(height: 10),

            // Texto de ejemplo para la descripción del hábito
            Text(
              'Ejemplo: Repasar formas de obtener un automata finito.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).textTheme.labelSmall?.color,
              ),
            ),
            const SizedBox(height: 20),

            // Row para label de cantidad y unidad
            Row(
              children: [
                Text(
                  'Escoge la frecuencia con la que quieres realizarlo',
                  style: TextStyle(
                    fontWeight: Theme.of(context).textTheme.bodyLarge?.fontWeight,
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                  ),
                  textAlign: TextAlign.center,
                )
              ],
            ),
            const SizedBox(height: 20),

            //"Grid" de columna para dropdown y textfield
            Column(
              children: [
                Row(
                  children: [
                    
                    // Dropdown para seleccionar el tipo de cuantificación
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: selectedQuantificationType,
                        decoration: const InputDecoration(
                          labelText: 'Selecciona una opción',
                          fillColor: Colors.white, //color del fondo del textfield
                          filled: true,
                          labelStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10.0)),
                            borderSide: BorderSide(
                              color: Colors.black,
                              width: 2.0,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10.0)),
                            borderSide: BorderSide(
                              color: Colors.black,
                              width: 2.0,
                            ),
                          ),
                        ),
                        items: quantificationOptions
                            .map((option) => DropdownMenuItem(
                                  value: option,
                                  child: Text(option),
                                ))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedQuantificationType = value!;
                            // Si el usuario selecciona "Sin especificar", desactivamos los campos de cantidad y unidad
                            if (value == 'Sin especificar') {
                              quantityController.clear();
                              unitController.clear();
                            }
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                
                    // Campo de texto para la cantidad
                    Expanded(
                      child: CustomTextField(
                        controller: quantityController,
                        labelText: 'Cantidad',
                        enabled: selectedQuantificationType != 'Sin especificar',
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                Row(
                  children: [
                    // Campo de texto para la unidad
                    Expanded(
                      child: CustomTextField(
                        controller: unitController,
                        labelText: 'Unidad',
                        enabled: selectedQuantificationType != 'Sin especificar',
                      ),
                    ),
                    const Expanded(
                      child: Text(
                        'en el día.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Texto de ejemplo para la cantidad
            Text(
              'Ejemplo: Al menos 8 vasos en el día.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).textTheme.labelSmall?.color,
              ),
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const BackButtonWidget(),  // Botón para ir atrás
                NavigateButton(
                  text: 'Continuar',
                  onPressed: () {
                    if (nameController.text.isNotEmpty && (quantityController.text.isNotEmpty || selectedQuantificationType == 'Sin especificar')) {
                      
                      habitController.setHabitName(nameController.text);
                      habitController.setHabitDescription(descriptionController.text.isNotEmpty ? descriptionController.text : null);

                      // Llamada a los setters, para guardar los valores ingresados por el usuario. Definir que sin especificar es libre
                      habitController.setQuantificationType(selectedQuantificationType);
                      habitController.setQuantity(selectedQuantificationType != 'Sin especificar'
                          ? int.tryParse(quantityController.text) ?? 0
                          : null);
                      habitController.setUnit(selectedQuantificationType != 'Sin especificar'
                          ? unitController.text.isNotEmpty ? unitController.text : null
                          : null);

                      // Navegamos a la siguiente página en el flujo
                      Get.to(() => const ChooseCategoryPage());
                    } else {
                      // Mostrar error si no se ingresó una cantidad y no es "Sin especificar"
                      Get.snackbar(
                        'Error',
                        'Debes ingresar una cantidad o seleccionar "Sin especificar".',
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: Theme.of(context).colorScheme.error,
                        colorText: Theme.of(context).textTheme.labelLarge?.color,
                      );
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
