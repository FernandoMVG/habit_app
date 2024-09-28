import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habit_app/ui/widgets/buttons.dart';
//importar pagina de habitos

class ChooseFrequencyPage extends StatefulWidget {
  final Color categoryColor;  // El color de la categoría seleccionada

  const ChooseFrequencyPage({
    super.key, 
    required this.categoryColor
    });

  @override
  ChooseFrequencyPageState createState() => ChooseFrequencyPageState();
}

class ChooseFrequencyPageState extends State<ChooseFrequencyPage> {
  bool isWeeklySelected = false;  // Controla si la opción "Días de la semana" está seleccionada
  final List<String> selectedDays = [];  // Lista de días seleccionados

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor:  Theme.of(context).scaffoldBackgroundColor,  // Color de la barra de navegación
        automaticallyImplyLeading: false,  // Oculta el botón de atrás
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [

            // Título centrado
            Center(
              child: Text(
                'Elige una frecuencia',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 50),

            // Botón "Todos los días"
            ElevatedButton(
              onPressed: () {
                setState(() {
                  isWeeklySelected = false;
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: isWeeklySelected ? Colors.white : Theme.of(context).colorScheme.primary,
                side: BorderSide(
                  color: Theme.of(context).colorScheme.primary,
                  width: 2,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Todos los días',
                    style: TextStyle(
                      color: isWeeklySelected ? Colors.black : Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Icon(
                    Icons.check_circle_outline,
                    color: widget.categoryColor, // Usamos el color de la categoría seleccionada
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Botón "Días de la semana"
            ElevatedButton(
              onPressed: () {
                setState(() {
                  isWeeklySelected = true;
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: isWeeklySelected ? Theme.of(context).colorScheme.primary : Colors.white,
                side: BorderSide(
                  color: Theme.of(context).colorScheme.primary,
                  width: 2,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Días de la semana',
                    style: TextStyle(
                      color: isWeeklySelected ? Colors.white : Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Icon(
                    Icons.calendar_today,
                    color: widget.categoryColor,
                  ),
                ],
              ),
            ),

            // Desplegar los días de la semana si la opción "Días de la semana" está seleccionada
            if (isWeeklySelected)
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: GridView.builder(
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,  // 4 columnas
                    childAspectRatio: 2 / 1,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: 7,
                  itemBuilder: (context, index) {
                    final daysOfWeek = ['Lun', 'Mar', 'Mié', 'Jue', 'Vie', 'Sab', 'Dom'];
                    final day = daysOfWeek[index];

                    final isSelected = selectedDays.contains(day);

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          if (isSelected) {
                            selectedDays.remove(day);
                          } else {
                            selectedDays.add(day);
                          }
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: isSelected ? widget.categoryColor : widget.categoryColor.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          day,
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const BackButtonWidget(),
                
                NavigateButton(
                  text: 'Finalizar',
                  onPressed: () {
                    if (selectedDays.isNotEmpty || !isWeeklySelected) {
                      // Lógica para finalizar el flujo
                      //print('Frecuencia seleccionada');
                    }
                  },
                  isEnabled: selectedDays.isNotEmpty || !isWeeklySelected,  // Controla si el botón debe estar habilitado
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
