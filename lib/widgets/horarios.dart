import 'package:flutter/material.dart';

class HorariosWidget extends StatefulWidget {
  const HorariosWidget({super.key});

  @override
  _HorariosWidgetState createState() => _HorariosWidgetState();
}

class _HorariosWidgetState extends State<HorariosWidget> {
  final Map<String, List<Map<String, String>>> _horariosPorDia = {
    "Lunes": [
      {"materia": "Matemáticas", "horario": "8:00 AM - 10:00 AM"},
      {"materia": "Inglés", "horario": "3:00 PM - 4:00 PM"}
    ],
    "Martes": [
      {"materia": "Historia", "horario": "10:00 AM - 12:00 PM"}
    ],
    "Miércoles": [
      {"materia": "Matemáticas", "horario": "8:00 AM - 10:00 AM"},
      {"materia": "Inglés", "horario": "3:00 PM - 4:00 PM"}
    ],
    "Jueves": [
      {"materia": "Historia", "horario": "10:00 AM - 12:00 PM"}
    ],
    "Viernes": [
      {"materia": "Ciencias", "horario": "1:00 PM - 3:00 PM"}
    ],
    "Sábado": [],
    "Domingo": []
  };

  String _diaSeleccionado = "Lunes"; // Día seleccionado por defecto

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> horariosDia = _horariosPorDia[_diaSeleccionado] ?? [];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Horarios"),
      ),
      body: Column(
        children: [
          // Selector de día
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const Text("Seleccionar día: ", style: TextStyle(fontWeight: FontWeight.bold)),
                Expanded(
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: _diaSeleccionado,
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        setState(() {
                          _diaSeleccionado = newValue;
                        });
                      }
                    },
                    items: _horariosPorDia.keys
                        .map<DropdownMenuItem<String>>((String dia) {
                      return DropdownMenuItem<String>(
                        value: dia,
                        child: Text(dia),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
          
          // Listado de horarios para el día seleccionado
          Expanded(
            child: horariosDia.isEmpty
                ? const Center(child: Text("No hay horarios para este día"))
                : ListView.builder(
                    itemCount: horariosDia.length,
                    itemBuilder: (context, index) {
                      final horario = horariosDia[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: ListTile(
                          leading: const Icon(Icons.book),
                          title: Text(horario["materia"]!),
                          subtitle: Text(horario["horario"]!),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
