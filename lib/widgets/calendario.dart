import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CalendarioWidget extends StatefulWidget {
  const CalendarioWidget({super.key});

  @override
  _CalendarioWidgetState createState() => _CalendarioWidgetState();
}

class _CalendarioWidgetState extends State<CalendarioWidget> {
  DateTime _selectedDate = DateTime.now();
  final Map<DateTime, List<Actividad>> _actividades = {};

  // Mapa de materias y sus colores
  final Map<String, Color> _materiasColores = {
    'Matemáticas': Colors.blue,
    'Historia': Colors.red,
    'Ciencias': Colors.green,
    'Inglés': Colors.orange,
  };

  void _selectDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2023),
      lastDate: DateTime(2030),
    );
    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  void _agregarActividad() {
    final TextEditingController tituloController = TextEditingController();
    final TextEditingController descripcionController = TextEditingController();
    String materiaSeleccionada = _materiasColores.keys.first;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text("Agregar Actividad"),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: tituloController,
                      decoration: const InputDecoration(labelText: "Título"),
                    ),
                    TextField(
                      controller: descripcionController,
                      decoration: const InputDecoration(labelText: "Descripción"),
                    ),
                    DropdownButton<String>(
                      value: materiaSeleccionada,
                      isExpanded: true,
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          setState(() {
                            materiaSeleccionada = newValue;
                          });
                        }
                      },
                      items: _materiasColores.keys.map<DropdownMenuItem<String>>((String materia) {
                        return DropdownMenuItem<String>(
                          value: materia,
                          child: Row(
                            children: [
                              Container(
                                width: 20,
                                height: 20,
                                color: _materiasColores[materia],
                                margin: const EdgeInsets.only(right: 8),
                              ),
                              Text(materia),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("Cancelar"),
                ),
                TextButton(
                  onPressed: () {
                    // Crear nueva actividad
                    final actividad = Actividad(
                      titulo: tituloController.text,
                      descripcion: descripcionController.text,
                      materia: materiaSeleccionada,
                      color: _materiasColores[materiaSeleccionada]!,
                    );

                    // Agregar actividad al mapa
                    this.setState(() {
                      final dateOnly = DateTime(
                        _selectedDate.year,
                        _selectedDate.month,
                        _selectedDate.day,
                      );

                      if (_actividades[dateOnly] == null) {
                        _actividades[dateOnly] = [];
                      }
                      _actividades[dateOnly]!.add(actividad);
                    });

                    Navigator.pop(context);
                  },
                  child: const Text("Agregar"),
                ),
              ],
            );
          }
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('yyyy-MM-dd');
    final formattedDate = dateFormat.format(_selectedDate);
    final dateOnly = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
    );
    
    // Actividades del día seleccionado
    final actividadesDelDia = _actividades[dateOnly] ?? [];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendario'),
      ),
      body: Column(
        children: [
          // Selector de fecha
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Fecha: $formattedDate',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                ElevatedButton(
                  onPressed: _selectDate,
                  child: const Text('Cambiar fecha'),
                ),
              ],
            ),
          ),
          
          // Lista de actividades
          Expanded(
            child: actividadesDelDia.isEmpty
                ? const Center(child: Text("No hay actividades para este día"))
                : ListView.builder(
                    itemCount: actividadesDelDia.length,
                    itemBuilder: (context, index) {
                      final actividad = actividadesDelDia[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 4.0,
                        ),
                        color: actividad.color.withOpacity(0.3),
                        child: ListTile(
                          leading: Icon(Icons.assignment, color: actividad.color),
                          title: Text(actividad.titulo),
                          subtitle: Text(
                            "${actividad.descripcion}\nMateria: ${actividad.materia}",
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: _agregarActividad,
      ),
    );
  }
}

class Actividad {
  final String titulo;
  final String descripcion;
  final String materia;
  final Color color;

  Actividad({
    required this.titulo,
    required this.descripcion,
    required this.materia,
    required this.color,
  });
}
