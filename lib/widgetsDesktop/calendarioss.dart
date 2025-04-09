import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:proyectoeducativo/widgetsDesktop/actividad_modelo.dart';
import 'package:proyectoeducativo/widgetsDesktop/materia_model.dart';

class CalendarioWidget extends StatefulWidget {
  const CalendarioWidget({super.key});

  @override
  State<CalendarioWidget> createState() => _CalendarioWidgetState();
}

class _CalendarioWidgetState extends State<CalendarioWidget> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  List<Actividad> _eventosDelDia(DateTime d) => listaActividades
      .where((a) => a.fecha.year == d.year && a.fecha.month == d.month && a.fecha.day == d.day)
      .toList();

  void _marcarEntregada(Actividad a) => setState(() => a.entregada = true);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TableCalendar(
          firstDay: DateTime.utc(2020, 1, 1),
          lastDay: DateTime.utc(2050, 12, 31),
          focusedDay: _focusedDay,
          selectedDayPredicate: (d) => isSameDay(_selectedDay, d),
          onDaySelected: (sel, foc) => setState(() {
            _selectedDay = sel;
            _focusedDay = foc;
          }),
          calendarBuilders: CalendarBuilders(
            markerBuilder: (ctx, date, events) {
              final evts = _eventosDelDia(date);
              if (evts.isEmpty) return null;
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: evts.map((e) {
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 1),
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: e.entregada ? Colors.green : colorDeMateria(e.materia),
                      shape: BoxShape.circle,
                    ),
                  );
                }).toList(),
              );
            },
          ),
        ),
        const SizedBox(height: 16),
        if (_selectedDay != null)
          Expanded(
            child: ListView(
              children: _eventosDelDia(_selectedDay!).map((e) {
                return Card(
                  color: colorDeMateria(e.materia),
                  margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
                  child: ListTile(
                    leading: Icon(e.entregada ? Icons.check_circle : Icons.pending, color: Colors.white),
                    title: Text(e.titulo, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    subtitle: Text('${e.materia}  •  ${e.estado}', style: const TextStyle(color: Colors.white70)),
                    trailing: !e.entregada
                        ? IconButton(
                            icon: const Icon(Icons.check, color: Colors.white),
                            onPressed: () => _marcarEntregada(e),
                          )
                        : null,
                  ),
                );
              }).toList(),
            ),
          ),
      ],
    );
  }
}
