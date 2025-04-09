import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'actividad_modelo.dart';

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
              decoration: const InputDecoration(labelText: 'Categoría (Ej. Reunión)'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              if (tituloCtrl.text.isNotEmpty && _selectedDay != null) {
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
            child: const Text('Agregar'),
          ),
        ],
      ),
    );
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
                final eventos = _getEventosParaDia(date);
                if (eventos.isNotEmpty) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: eventos.map((e) =>
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 1.5),
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: e.entregada ? Colors.green : Colors.red,
                          shape: BoxShape.circle,
                        ),
                      )).toList(),
                  );
                }
                return null;
              },
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Eventos del día:', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
              ElevatedButton.icon(
                onPressed: _mostrarDialogoAgregarEvento,
                icon: const Icon(Icons.add),
                label: const Text('Agregar evento'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (_selectedDay != null)
            Expanded(
              child: _getEventosParaDia(_selectedDay!).isEmpty
                  ? const Center(child: Text("No hay eventos para este día."))
                  : ListView.builder(
                      itemCount: _getEventosParaDia(_selectedDay!).length,
                      itemBuilder: (context, index) {
                        final evento = _getEventosParaDia(_selectedDay!)[index];
                        return Card(
                          elevation: 3,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          color: evento.color,
                          child: ListTile(
                            leading: Icon(
                              evento.entregada ? Icons.check_circle : Icons.pending_actions,
                              color: evento.entregada ? Colors.green : Colors.orange,
                            ),
                            title: Text(
                              evento.titulo,
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(evento.materia),
                            trailing: !evento.entregada
                                ? TextButton(
                                    onPressed: () => _marcarComoEntregada(evento),
                                    child: const Text('Marcar como entregada'),
                                  )
                                : const Text('Entregada ✅'),
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
