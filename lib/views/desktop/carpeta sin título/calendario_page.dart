import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:proyectoeducativo/models/calendario_model.dart';
import 'package:proyectoeducativo/models/actividad_model.dart';
import 'package:proyectoeducativo/conexion/db.dart';
import 'package:intl/intl.dart';

class CalendarioPage extends StatefulWidget {
  const CalendarioPage({super.key});

  @override
  State<CalendarioPage> createState() => _CalendarioPageState();
}

class _CalendarioPageState extends State<CalendarioPage> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();
  bool _isLoading = true;
  Map<DateTime, List<dynamic>> _eventos = {};

  @override
  void initState() {
    super.initState();
    _cargarDatos();
  }

  Future<void> _cargarDatos() async {
    setState(() => _isLoading = true);
    try {
      final actividades = await _dbHelper.getActividades();
      final eventos = await _dbHelper.getEventosCalendario();

      // Crear un mapa de eventos por fecha
      Map<DateTime, List<dynamic>> eventosMap = {};

      for (var evento in eventos) {
        final fechaEvento = DateTime(
          evento.fecha.year,
          evento.fecha.month,
          evento.fecha.day,
        );
        eventosMap[fechaEvento] ??= [];
        eventosMap[fechaEvento]!.add(evento);
      }

      for (var actividad in actividades.where((a) => !a.completada)) {
        final fechaAct = DateTime(
          actividad.fechaCierre.year,
          actividad.fechaCierre.month,
          actividad.fechaCierre.day,
        );
        final materiaAsociada = await _dbHelper.getMateria(actividad.materiaId!);
        final colorDeMateria = materiaAsociada != null ? materiaAsociada.color : 0xFFE57373;
        eventosMap[fechaAct] ??= [];
        eventosMap[fechaAct]!.add(
          CalendarioEvento(
            titulo: actividad.nombre,
            descripcion: actividad.descripcion,
            fecha: actividad.fechaCierre,
            color: colorDeMateria,
            esActividad: true,
            actividadId: actividad.id,
          ),
        );
      }

      setState(() {
        _eventos = eventosMap;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cargar datos: $e')),
      );
    }
  }

  // Retorna la lista de eventos del día indicado
  List<dynamic> _getEventosParaDia(DateTime day) {
    final normalized = DateTime(day.year, day.month, day.day);
    return _eventos[normalized] ?? [];
  }

  void _mostrarDetallesEvento(dynamic item) {
    final CalendarioEvento evento = item;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(evento.titulo),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Fecha: ${DateFormat('dd/MM/yyyy').format(evento.fecha)}'),
              const SizedBox(height: 8),
              Text('Descripción: ${evento.descripcion}'),
              if (evento.esActividad) const SizedBox(height: 16),
              if (evento.esActividad) const Text('Esta es una actividad pendiente.'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cerrar'),
          ),
          if (evento.esActividad)
            ElevatedButton(
              onPressed: () async {
                if (evento.actividadId != null) {
                  await _dbHelper.marcarActividadComoCompletada(evento.actividadId!);
                  Navigator.of(context).pop();
                  await _cargarDatos();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Actividad marcada como completada')),
                  );
                }
              },
              child: const Text('Marcar como completada'),
            ),
          if (!evento.esActividad)
            ElevatedButton(
              onPressed: () async {
                if (evento.id != null) {
                  await _dbHelper.deleteEventoCalendario(evento.id!);
                  Navigator.of(context).pop();
                  await _cargarDatos();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Evento eliminado')),
                  );
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('Eliminar'),
            ),
        ],
      ),
    );
  }

  void _agregarEvento() {
    showDialog(
      context: context,
      builder: (context) => _DialogoNuevoEvento(
        selectedDay: _selectedDay,
        onEventoGuardado: (evento) async {
          try {
            final id = await _dbHelper.insertEventoCalendario(evento);
            Navigator.of(context).pop();
            await _cargarDatos();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Evento guardado correctamente')),
            );
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error al guardar evento: $e')),
            );
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    return Scaffold(
      appBar: AppBar(title: const Text('Calendario')),
      body: Column(
        children: [
          TableCalendar(
            focusedDay: _focusedDay,
            firstDay: DateTime(2000),
            lastDay: DateTime(2100),
            eventLoader: _getEventosParaDia,
            selectedDayPredicate: (day) => isSameDay(day, _selectedDay),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            calendarBuilders: CalendarBuilders(
              singleMarkerBuilder: (context, date, event) {
                final e = event as CalendarioEvento;
                return Container(
                  width: 7,
                  height: 7,
                  margin: const EdgeInsets.symmetric(horizontal: 1.5),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(e.color),
                  ),
                );
              },
              todayBuilder: (context, date, _) {
                return Container(
                  margin: const EdgeInsets.all(5.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.blue, width: 2),
                  ),
                  child: Center(child: Text('${date.day}')),
                );
              },
              
              /*
              selectedBuilder: (context, date, events) {
                if (events.isNotEmpty && events.first is CalendarioEvento) {
                  final e = events.first as CalendarioEvento;
                  return Container(
                    margin: const EdgeInsets.all(5.0),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Color(e.color), width: 2),
                    ),
                    child: Center(child: Text('${date.day}')),
                  );
                }
                // Si no hay eventos
                return Container(
                  margin: const EdgeInsets.all(5.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.green, width: 2),
                  ),
                  child: Center(child: Text('${date.day}')),
                );
              },
              */
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
          ),
          const Divider(),
          Expanded(
            child: _buildEventosList(_getEventosParaDia(_selectedDay)),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _agregarEvento,
        child: const Icon(Icons.add),
        tooltip: 'Agregar evento',
      ),
    );
  }

  Widget _buildEventosList(List<dynamic> eventos) {
    if (eventos.isEmpty) {
      return const Center(child: Text('No hay eventos para este día'));
    }
    return ListView.builder(
      itemCount: eventos.length,
      itemBuilder: (context, index) {
        final item = eventos[index] as CalendarioEvento;
        return ListTile(
          leading: CircleAvatar(
            backgroundColor: Color(item.color),
            child: Icon(
              item.esActividad ? Icons.assignment : Icons.event,
              color: Colors.white,
            ),
          ),
          title: Text(item.titulo),
          subtitle: Text(item.esActividad ? 'Actividad pendiente' : 'Evento'),
          onTap: () => _mostrarDetallesEvento(item),
        );
      },
    );
  }
}

// Diálogo para crear un nuevo evento
class _DialogoNuevoEvento extends StatefulWidget {
  final DateTime selectedDay;
  final Function(CalendarioEvento) onEventoGuardado;

  const _DialogoNuevoEvento({
    required this.selectedDay,
    required this.onEventoGuardado,
  });

  @override
  State<_DialogoNuevoEvento> createState() => _DialogoNuevoEventoState();
}

class _DialogoNuevoEventoState extends State<_DialogoNuevoEvento> {
  final _tituloController = TextEditingController();
  final _descripcionController = TextEditingController();
  int _colorSeleccionado = 0xFF2196F3;

  void _guardarEvento() {
    if (_tituloController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, ingresa un título')),
      );
      return;
    }
    // Ajustamos la hora a mediodía para evitar problemas de zonas horarias
    final fechaSinOffset = DateTime(
      widget.selectedDay.year,
      widget.selectedDay.month,
      widget.selectedDay.day,
      12, 0, 0,
    );

    final nuevoEvento = CalendarioEvento(
      titulo: _tituloController.text,
      descripcion: _descripcionController.text,
      fecha: fechaSinOffset,
      color: _colorSeleccionado,
    );
    widget.onEventoGuardado(nuevoEvento);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Nuevo Evento'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _tituloController,
              decoration: const InputDecoration(labelText: 'Título'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _descripcionController,
              decoration: const InputDecoration(labelText: 'Descripción'),
              maxLines: 2,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Text('Color: '),
                IconButton(
                  icon: Icon(
                    Icons.circle,
                    color: Colors.blue,
                    // Destaca el botón si es el color seleccionado
                    size: _colorSeleccionado == 0xFF2196F3 ? 30 : 24,
                  ),
                  onPressed: () => setState(() => _colorSeleccionado = 0xFF2196F3),
                ),
                IconButton(
                  icon: Icon(
                    Icons.circle,
                    color: Colors.green,
                    size: _colorSeleccionado == 0xFF4CAF50 ? 30 : 24,
                  ),
                  onPressed: () => setState(() => _colorSeleccionado = 0xFF4CAF50),
                ),
                IconButton(
                  icon: Icon(
                    Icons.circle,
                    color: Colors.red,
                    size: _colorSeleccionado == 0xFFF44336 ? 30 : 24,
                  ),
                  onPressed: () => setState(() => _colorSeleccionado = 0xFFF44336),
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: _guardarEvento,
          child: const Text('Guardar'),
        ),
      ],
    );
  }
}
