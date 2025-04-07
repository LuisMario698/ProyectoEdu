import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class Actividad {
  final String titulo;
  final String descripcion;
  final String materia;
  final DateTime fecha;
  bool entregada;

  Actividad({
    required this.titulo,
    required this.descripcion,
    required this.materia,
    required this.fecha,
    this.entregada = false,
  });

  Color get color => entregada ? Colors.greenAccent : Colors.redAccent;

  String get estado => entregada ? 'Entregada' : 'Pendiente';
}

List<Actividad> listaActividades = [
  Actividad(
    titulo: 'Proyecto POO',
    descripcion: 'Desarrolla un sistema con clases abstractas y herencia.',
    materia: 'Tópicos Avanzados de Programación',
    fecha: DateTime(2025, 4, 7),
  ),
  Actividad(
    titulo: 'Tarea Interpolación',
    descripcion: 'Resolver ejercicios con el método de Lagrange.',
    materia: 'Métodos Numéricos',
    fecha: DateTime(2025, 4, 9),
  ),
  Actividad(
    titulo: 'Modelado de eventos discretos',
    descripcion: 'Investigar y representar un sistema discreto.',
    materia: 'Simulación',
    fecha: DateTime(2025, 4, 11),
  ),
  Actividad(
    titulo: 'Ecuaciones de segundo orden',
    descripcion: 'Ejercicios del tema 4 del libro guía.',
    materia: 'Ecuaciones Diferenciales',
    fecha: DateTime(2025, 4, 10),
  ),
];

class CalendarioWidget extends StatefulWidget {
  const CalendarioWidget({super.key});

  @override
  State<CalendarioWidget> createState() => _CalendarioWidgetState();
}

class _CalendarioWidgetState extends State<CalendarioWidget> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  List<Actividad> _getEventosParaDia(DateTime day) {
    return listaActividades.where((a) =>
      a.fecha.year == day.year &&
      a.fecha.month == day.month &&
      a.fecha.day == day.day
    ).toList();
  }

  void _marcarComoEntregada(Actividad actividad) {
    setState(() {
      actividad.entregada = true;
    });
  }

  void _mostrarDialogoAgregarEvento() {
    final TextEditingController tituloCtrl = TextEditingController();
    final TextEditingController descripcionCtrl = TextEditingController();
    final TextEditingController materiaCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Nuevo Evento'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: tituloCtrl,
              decoration: const InputDecoration(labelText: 'Título'),
            ),
            TextField(
              controller: descripcionCtrl,
              decoration: const InputDecoration(labelText: 'Descripción'),
            ),
            TextField(
              controller: materiaCtrl,
              decoration: const InputDecoration(labelText: 'Materia'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              if (tituloCtrl.text.isNotEmpty &&
                  descripcionCtrl.text.isNotEmpty &&
                  materiaCtrl.text.isNotEmpty &&
                  _selectedDay != null) {
                setState(() {
                  listaActividades.add(
                    Actividad(
                      titulo: tituloCtrl.text,
                      descripcion: descripcionCtrl.text,
                      materia: materiaCtrl.text,
                      fecha: _selectedDay!,
                    ),
                  );
                });
                Navigator.pop(context);
              }
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Calendario',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Card(
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TableCalendar(
                firstDay: DateTime.utc(2025, 1, 1),
                lastDay: DateTime.utc(2025, 12, 31),
                focusedDay: _focusedDay,
                calendarFormat: CalendarFormat.month,
                selectedDayPredicate: (day) {
                  return isSameDay(_selectedDay, day);
                },
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                  });
                },
                eventLoader: _getEventosParaDia,
                calendarStyle: const CalendarStyle(
                  markersMaxCount: 3,
                  markerDecoration: BoxDecoration(
                    color: Colors.redAccent,
                    shape: BoxShape.circle,
                  ),
                ),
                headerStyle: const HeaderStyle(
                  formatButtonVisible: false,
                  titleCentered: true,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _selectedDay == null
                    ? 'Actividades de hoy'
                    : 'Actividades para ${_selectedDay!.day}/${_selectedDay!.month}/${_selectedDay!.year}',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: const Icon(Icons.add_circle),
                onPressed: _mostrarDialogoAgregarEvento,
                tooltip: 'Agregar evento',
              ),
            ],
          ),
          const SizedBox(height: 8),
          Expanded(
            child: _selectedDay == null
                ? const Center(child: Text('Selecciona un día para ver actividades'))
                : _getEventosParaDia(_selectedDay!).isEmpty
                    ? const Center(child: Text('No hay actividades para este día'))
                    : ListView.builder(
                        itemCount: _getEventosParaDia(_selectedDay!).length,
                        itemBuilder: (context, index) {
                          final actividad = _getEventosParaDia(_selectedDay!)[index];
                          return Card(
                            margin: const EdgeInsets.only(bottom: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: ListTile(
                              contentPadding: const EdgeInsets.all(12),
                              leading: CircleAvatar(
                                backgroundColor: actividad.color,
                                child: Icon(
                                  actividad.entregada
                                      ? Icons.check
                                      : Icons.access_time,
                                  color: Colors.white,
                                ),
                              ),
                              title: Text(
                                actividad.titulo,
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(actividad.materia),
                                  const SizedBox(height: 4),
                                  Text('Estado: ${actividad.estado}'),
                                ],
                              ),
                              trailing: actividad.entregada
                                  ? const Icon(Icons.check_circle, color: Colors.green)
                                  : IconButton(
                                      icon: const Icon(Icons.done),
                                      onPressed: () => _marcarComoEntregada(actividad),
                                    ),
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