import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class HorarioWidget extends StatefulWidget {
  const HorarioWidget({super.key});

  @override
  State<HorarioWidget> createState() => _HorarioWidgetState();
}

class _HorarioWidgetState extends State<HorarioWidget> {
  Map<String, Map<String, String>> horario = {};

  final List<String> dias = ['Lunes', 'Martes', 'Miércoles', 'Jueves', 'Viernes'];
  final List<String> horas = [
    '7:00 - 8:00',
    '8:00 - 9:00',
    '9:00 - 10:00',
    '10:00 - 11:00',
    '11:00 - 12:00',
    '12:00 - 13:00',
    '13:00 - 14:00',
  ];

  @override
  void initState() {
    super.initState();
    _cargarHorario();
  }

  Future<void> _cargarHorario() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('horarioData');
    if (data != null) {
      setState(() {
        horario = Map<String, Map<String, String>>.from(json.decode(data).map(
          (key, value) => MapEntry(
            key,
            Map<String, String>.from(value),
          ),
        ));
      });
    }
  }

  Future<void> _guardarHorario() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('horarioData', json.encode(horario));
  }

  Future<void> _reiniciarHorario() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('¿Reiniciar horario?'),
        content: const Text('Esta acción eliminará todo el contenido del horario.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancelar')),
          ElevatedButton(onPressed: () => Navigator.pop(context, true), child: const Text('Reiniciar')),
        ],
      ),
    );
    if (confirm == true) {
      setState(() {
        horario.clear();
      });
      _guardarHorario();
    }
  }

  void _editarCelda(String key) {
    final materiaCtrl = TextEditingController(text: horario[key]?['materia']);
    final maestroCtrl = TextEditingController(text: horario[key]?['maestro']);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Editar clase'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: materiaCtrl,
              decoration: const InputDecoration(labelText: 'Nombre de la clase'),
            ),
            TextField(
              controller: maestroCtrl,
              decoration: const InputDecoration(labelText: 'Nombre del maestro'),
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
              setState(() {
                horario[key] = {
                  'materia': materiaCtrl.text,
                  'maestro': maestroCtrl.text,
                };
              });
              _guardarHorario();
              Navigator.pop(context);
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Text(
              'Horario de Clases (7:00 AM - 2:00 PM)',
              style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton.icon(
                  onPressed: _reiniciarHorario,
                  icon: const Icon(Icons.refresh),
                  label: const Text(
                    'Reiniciar Horario',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.error,
                    foregroundColor: theme.colorScheme.onError,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Table(
              border: TableBorder.all(color: theme.dividerColor),
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              children: [
                TableRow(
                  children: [
                    const TableCell(
                      child: Padding(
                        padding: EdgeInsets.all(12.0),
                        child: Text('Hora', style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ),
                    ...dias.map((d) => Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Text(
                            d,
                            style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
                          ),
                        )),
                  ],
                ),
                ...horas.map((hora) {
                  return TableRow(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Text(hora),
                      ),
                      ...dias.map((dia) {
                        final key = '$dia-$hora';
                        final data = horario[key];
                        return GestureDetector(
                          onTap: () => _editarCelda(key),
                          child: Container(
                            height: 60,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primary.withOpacity(0.08),
                            ),
                            padding: const EdgeInsets.all(4.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  data?['materia'] ?? '',
                                  textAlign: TextAlign.center,
                                  style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
                                ),
                                if ((data?['maestro'] ?? '').isNotEmpty)
                                  Text(
                                    data?['maestro'] ?? '',
                                    textAlign: TextAlign.center,
                                    style: theme.textTheme.bodySmall,
                                  ),
                              ],
                            ),
                          ),
                        );
                      }),
                    ],
                  );
                }).toList(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
