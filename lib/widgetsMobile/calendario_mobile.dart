import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../widgetsDesktop/actividad_modelo.dart';

class CalendarioMobileWidget extends StatefulWidget {
  const CalendarioMobileWidget({super.key});

  @override
  State<CalendarioMobileWidget> createState() => _CalendarioMobileWidgetState();
}

class _CalendarioMobileWidgetState extends State<CalendarioMobileWidget> {
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
    final TextEditingController fechaCtrl = TextEditingController();

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
            DropdownButton<String>(
              value: _selectedMateria,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedMateria = newValue;
                });
              },
              items: listaMaterias.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              hint: const Text('Selecciona una materia'),
            ),
            TextField(
              controller: fechaCtrl,
              decoration: const InputDecoration(labelText: 'Fecha y Hora de Vencimiento'),
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2100),
                );
                if (pickedDate != null) {
                  TimeOfDay? pickedTime = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                  if (pickedTime != null) {
                    DateTime fullDate = DateTime(
                      pickedDate.year,
                      pickedDate.month,
                      pickedDate.day,
                      pickedTime.hour,
                      pickedTime.minute,
                    );
                    fechaCtrl.text = fullDate.toString();
                  }
                }
              },
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
                      materia: _selectedMateria ?? '',
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendario'),
      ),
      body: Column(
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
            headerStyle: const HeaderStyle(
              formatButtonVisible: false,
              titleTextStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            calendarStyle: CalendarStyle(
              todayDecoration: BoxDecoration(
                color: Colors.deepPurpleAccent,
                shape: BoxShape.circle,
              ),
              selectedDecoration: BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
              ),
            ),
            calendarBuilders: CalendarBuilders(
              markerBuilder: (context, date, events) {
                final eventos = _getEventosParaDia(date);
                if (eventos.isNotEmpty) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: eventos.map((e) =>
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 1.0),
                        width: 6,
                        height: 6,
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
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Eventos del día:', 
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                IconButton(
                  onPressed: _mostrarDialogoAgregarEvento,
                  icon: const Icon(Icons.add_circle),
                  tooltip: 'Agregar evento',
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          if (_selectedDay != null)
            Expanded(
              child: _getEventosParaDia(_selectedDay!).isEmpty
                  ? const Center(child: Text("No hay eventos para este día."))
                  : ListView.builder(
                      itemCount: _getEventosParaDia(_selectedDay!).length,
                      itemBuilder: (context, index) {
                        final evento = _getEventosParaDia(_selectedDay!)[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                          elevation: 2,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          color: evento.color,
                          child: ListTile(
                            leading: Icon(
                              evento.entregada ? Icons.check_circle : Icons.pending_actions,
                              color: evento.entregada ? Colors.green : Colors.orange,
                            ),
                            title: Text(
                              evento.titulo,
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(evento.materia),
                            trailing: !evento.entregada
                                ? IconButton(
                                    onPressed: () => _marcarComoEntregada(evento),
                                    icon: const Icon(Icons.check),
                                    tooltip: 'Marcar como entregada',
                                  )
                                : const Icon(Icons.check_circle, color: Colors.green),
                          ),
                        );
                      },
                    ),
            ),
        ],
      ),    );
  }
}

List<String> listaMaterias = ['Matemáticas', 'Ciencias', 'Historia'];

String? _selectedMateria;