import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarioWidget extends StatefulWidget {
  const CalendarioWidget({super.key});

  @override
  State<CalendarioWidget> createState() => _CalendarioWidgetState();
}

class Evento {
  final String titulo;
  final String categoria;

  Evento(this.titulo, this.categoria);
}

class _CalendarioWidgetState extends State<CalendarioWidget> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  final Map<DateTime, List<Evento>> _eventos = {};
  final Set<String> _completados = {};

  final List<String> _categorias = ['Tarea', 'Examen', 'Reunión', 'Otro'];

  List<Evento> _getEventosParaDia(DateTime day) {
    return _eventos[DateTime(day.year, day.month, day.day)] ?? [];
  }

  Color _colorCategoria(String categoria) {
    switch (categoria) {
      case 'Tarea':
        return Colors.blue.shade100;
      case 'Examen':
        return Colors.red.shade100;
      case 'Reunión':
        return Colors.purple.shade100;
      default:
        return Colors.grey.shade300;
    }
  }

  void _mostrarDialogoAgregar({Evento? eventoExistente, int? indexEditar}) {
    final TextEditingController tituloCtrl = TextEditingController(text: eventoExistente?.titulo ?? '');
    String categoriaSeleccionada = eventoExistente?.categoria ?? _categorias[0];

    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text(eventoExistente == null ? "📝 Agregar Evento" : "✏️ Editar Evento"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: tituloCtrl,
                decoration: const InputDecoration(
                  hintText: 'Ej. Entregar tarea de matemáticas',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.event),
                ),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: categoriaSeleccionada,
                items: _categorias
                    .map((c) => DropdownMenuItem(
                          value: c,
                          child: Text(c),
                        ))
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() => categoriaSeleccionada = value);
                  }
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Categoría',
                ),
              )
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancelar"),
            ),
            ElevatedButton.icon(
              onPressed: () {
                if (_selectedDay != null && tituloCtrl.text.isNotEmpty) {
                  final fecha = DateTime(_selectedDay!.year, _selectedDay!.month, _selectedDay!.day);
                  final nuevoEvento = Evento(tituloCtrl.text, categoriaSeleccionada);

                  setState(() {
                    if (indexEditar != null) {
                      _eventos[fecha]![indexEditar] = nuevoEvento;
                    } else {
                      _eventos[fecha] = [..._getEventosParaDia(fecha), nuevoEvento];
                    }
                  });
                }
                Navigator.pop(context);
              },
              icon: Icon(eventoExistente == null ? Icons.add : Icons.save),
              label: Text(eventoExistente == null ? "Agregar" : "Guardar"),
            ),
          ],
        );
      },
    );
  }

  void _marcarComoEntregado(DateTime fecha, Evento evento) {
    setState(() {
      _completados.add("${fecha.toIso8601String()}|${evento.titulo}");
    });
  }

  void _eliminarEvento(DateTime fecha, int index) {
    setState(() {
      _eventos[fecha]?.removeAt(index);
    });
  }

  bool _estaCompletado(DateTime fecha, Evento evento) {
    return _completados.contains("${fecha.toIso8601String()}|${evento.titulo}");
  }

  @override
  Widget build(BuildContext context) {
    final anchoPantalla = MediaQuery.of(context).size.width;
    final altoPantalla = MediaQuery.of(context).size.height;

    return Container(
      width: anchoPantalla,
      height: altoPantalla,
      color: Colors.grey[100],
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2050, 12, 31),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: (selected, focused) {
              setState(() {
                _selectedDay = selected;
                _focusedDay = focused;
              });
            },
            daysOfWeekStyle: const DaysOfWeekStyle(
              weekdayStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              weekendStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            headerStyle: const HeaderStyle(
              formatButtonVisible: false,
              titleTextStyle: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              leftChevronIcon: Icon(Icons.chevron_left, size: 32),
              rightChevronIcon: Icon(Icons.chevron_right, size: 32),
            ),
            calendarStyle: CalendarStyle(
              defaultTextStyle: const TextStyle(fontSize: 22),
              weekendTextStyle: const TextStyle(fontSize: 22, color: Colors.redAccent),
              outsideTextStyle: const TextStyle(fontSize: 20, color: Colors.grey),
              todayDecoration: BoxDecoration(
                color: Colors.deepPurpleAccent,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
              selectedDecoration: BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
              cellMargin: const EdgeInsets.all(6),
              tablePadding: const EdgeInsets.symmetric(vertical: 12),
              markersAlignment: Alignment.bottomCenter,
            ),
            calendarBuilders: CalendarBuilders(
              markerBuilder: (context, date, events) {
                final fecha = DateTime(date.year, date.month, date.day);
                if (_eventos.containsKey(fecha)) {
                  return const Positioned(
                    bottom: 1,
                    child: Icon(Icons.event_note, color: Colors.amber, size: 20),
                  );
                }
                return null;
              },
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              ElevatedButton.icon(
                onPressed: _selectedDay == null ? null : () => _mostrarDialogoAgregar(),
                icon: const Icon(Icons.add),
                label: const Text("Agregar evento"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(width: 20),
              if (_selectedDay != null)
                Text(
                  "Eventos del ${_selectedDay!.day}/${_selectedDay!.month}/${_selectedDay!.year}",
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
            ],
          ),
          const SizedBox(height: 20),
          if (_selectedDay != null)
            Expanded(
              child: _getEventosParaDia(_selectedDay!).isEmpty
                  ? const Center(child: Text("No hay eventos para este día."))
                  : ListView.builder(
                      itemCount: _getEventosParaDia(_selectedDay!).length,
                      itemBuilder: (context, index) {
                        final evento = _getEventosParaDia(_selectedDay!)[index];
                        final completado = _estaCompletado(_selectedDay!, evento);
                        return Card(
                          elevation: 3,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          color: completado ? Colors.green[100] : _colorCategoria(evento.categoria),
                          child: ListTile(
                            leading: Icon(
                              completado ? Icons.check_circle : Icons.assignment,
                              color: completado ? Colors.green : Colors.black54,
                            ),
                            title: Text(
                              evento.titulo,
                              style: TextStyle(
                                fontSize: 18,
                                decoration: completado ? TextDecoration.lineThrough : null,
                              ),
                            ),
                            subtitle: Text(evento.categoria),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (!completado)
                                  IconButton(
                                    icon: const Icon(Icons.check),
                                    tooltip: "Marcar como entregado",
                                    onPressed: () => _marcarComoEntregado(_selectedDay!, evento),
                                  ),
                                IconButton(
                                  icon: const Icon(Icons.edit),
                                  tooltip: "Editar evento",
                                  onPressed: () => _mostrarDialogoAgregar(
                                    eventoExistente: evento,
                                    indexEditar: index,
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.red),
                                  tooltip: "Eliminar evento",
                                  onPressed: () => _eliminarEvento(_selectedDay!, index),
                                ),
                              ],
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
