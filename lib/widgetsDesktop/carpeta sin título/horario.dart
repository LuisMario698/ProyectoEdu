import 'package:flutter/material.dart';

class HorarioWidget extends StatelessWidget {
  const HorarioWidget({super.key});

  final List<String> horas = const [
    '7:00 - 8:00',
    '8:00 - 9:00',
    '9:00 - 10:00',
    '10:00 - 11:00',
    '11:00 - 12:00',
    '12:00 - 13:00',
    '13:00 - 14:00',
  ];

  final List<String> dias = const ['Lunes', 'Martes', 'Miércoles', 'Jueves', 'Viernes'];

  final List<List<Map<String, String>>> horario = const [
    // Lunes
    [
      {'materia': 'Inglés 4', 'maestro': 'Contratación', 'contacto': 'maribel@escuela.edu.mx'},
      {'materia': 'Ecuaciones Diferenciales', 'maestro': 'M.C. Anaís Sotelo Burke', 'contacto': 'aburke@escuela.edu.mx'},
      {'materia': 'Fundamentos de Base de Datos', 'maestro': 'MED Diana Elizabeth López Chacón', 'contacto': 'dchacon@escuela.edu.mx'},
      {'materia': 'Simulación', 'maestro': 'ISC Brenda Dayana Bejarano García', 'contacto': 'bdayana@escuela.edu.mx'},
      {'materia': 'Tópicos Avanzados de Programación', 'maestro': 'ISC José María Gerónimo Pérez', 'contacto': 'jgeronimo@escuela.edu.mx'},
      {'materia': 'Métodos Numéricos', 'maestro': 'M.C. Anaís Sotelo Burke', 'contacto': 'aburke@escuela.edu.mx'},
      {'materia': 'Principios Eléctricos y Aplicaciones Digitales', 'maestro': 'MTIC Daniel Alonso Osuna Talamantes', 'contacto': 'dalonso@escuela.edu.mx'},
    ],
    // Martes
    [
      {'materia': 'Inglés 4', 'maestro': 'Contratación', 'contacto': 'maribel@escuela.edu.mx'},
      {'materia': 'Ecuaciones Diferenciales', 'maestro': 'M.C. Anaís Sotelo Burke', 'contacto': 'aburke@escuela.edu.mx'},
      {'materia': 'Fundamentos de Base de Datos', 'maestro': 'MED Diana Elizabeth López Chacón', 'contacto': 'dchacon@escuela.edu.mx'},
      {'materia': 'Simulación', 'maestro': 'ISC Brenda Dayana Bejarano García', 'contacto': 'bdayana@escuela.edu.mx'},
      {'materia': 'Tópicos Avanzados de Programación', 'maestro': 'ISC José María Gerónimo Pérez', 'contacto': 'jgeronimo@escuela.edu.mx'},
      {'materia': 'Métodos Numéricos', 'maestro': 'M.C. Anaís Sotelo Burke', 'contacto': 'aburke@escuela.edu.mx'},
      {'materia': 'Principios Eléctricos y Aplicaciones Digitales', 'maestro': 'MTIC Daniel Alonso Osuna Talamantes', 'contacto': 'dalonso@escuela.edu.mx'},
    ],
    // Miércoles
    [
      {'materia': 'Inglés 4', 'maestro': 'Contratación', 'contacto': 'maribel@escuela.edu.mx'},
      {'materia': 'Ecuaciones Diferenciales', 'maestro': 'M.C. Anaís Sotelo Burke', 'contacto': 'aburke@escuela.edu.mx'},
      {'materia': 'Fundamentos de Base de Datos', 'maestro': 'MED Diana Elizabeth López Chacón', 'contacto': 'dchacon@escuela.edu.mx'},
      {'materia': 'Simulación', 'maestro': 'ISC Brenda Dayana Bejarano García', 'contacto': 'bdayana@escuela.edu.mx'},
      {'materia': 'Tópicos Avanzados de Programación', 'maestro': 'ISC José María Gerónimo Pérez', 'contacto': 'jgeronimo@escuela.edu.mx'},
      {'materia': 'Métodos Numéricos', 'maestro': 'M.C. Anaís Sotelo Burke', 'contacto': 'aburke@escuela.edu.mx'},
      {'materia': 'Principios Eléctricos y Aplicaciones Digitales', 'maestro': 'MTIC Daniel Alonso Osuna Talamantes', 'contacto': 'dalonso@escuela.edu.mx'},
    ],
    // Jueves
    [
      {'materia': 'Inglés 4', 'maestro': 'Contratación', 'contacto': 'maribel@escuela.edu.mx'},
      {'materia': 'Ecuaciones Diferenciales', 'maestro': 'M.C. Anaís Sotelo Burke', 'contacto': 'aburke@escuela.edu.mx'},
      {'materia': 'Fundamentos de Base de Datos', 'maestro': 'MED Diana Elizabeth López Chacón', 'contacto': 'dchacon@escuela.edu.mx'},
      {'materia': 'Simulación', 'maestro': 'ISC Brenda Dayana Bejarano García', 'contacto': 'bdayana@escuela.edu.mx'},
      {'materia': 'Tópicos Avanzados de Programación', 'maestro': 'ISC José María Gerónimo Pérez', 'contacto': 'jgeronimo@escuela.edu.mx'},
      {'materia': 'Métodos Numéricos', 'maestro': 'M.C. Anaís Sotelo Burke', 'contacto': 'aburke@escuela.edu.mx'},
      {'materia': 'Principios Eléctricos y Aplicaciones Digitales', 'maestro': 'MTIC Daniel Alonso Osuna Talamantes', 'contacto': 'dalonso@escuela.edu.mx'},
    ],
    // Viernes
    [
      {'materia': 'Inglés 4', 'maestro': 'Contratación', 'contacto': 'maribel@escuela.edu.mx'},
      {'materia': 'Ecuaciones Diferenciales', 'maestro': 'M.C. Anaís Sotelo Burke', 'contacto': 'aburke@escuela.edu.mx'},
      {'materia': 'Fundamentos de Base de Datos', 'maestro': 'MED Diana Elizabeth López Chacón', 'contacto': 'dchacon@escuela.edu.mx'},
      {'materia': 'Simulación', 'maestro': 'ISC Brenda Dayana Bejarano García', 'contacto': 'bdayana@escuela.edu.mx'},
      {'materia': 'Tópicos Avanzados de Programación', 'maestro': 'ISC José María Gerónimo Pérez', 'contacto': 'jgeronimo@escuela.edu.mx'},
      {'materia': 'Métodos Numéricos', 'maestro': 'M.C. Anaís Sotelo Burke', 'contacto': 'aburke@escuela.edu.mx'},
      {'materia': 'Principios Eléctricos y Aplicaciones Digitales', 'maestro': 'MTIC Daniel Alonso Osuna Talamantes', 'contacto': 'dalonso@escuela.edu.mx'},
    ],
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Horario de Clases (7:00 AM - 2:00 PM)',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Table(
              defaultColumnWidth: const FixedColumnWidth(180),
              border: TableBorder.all(color: Colors.grey.shade300),
              children: [
                TableRow(
                  decoration: BoxDecoration(color: Colors.grey[300]),
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(12.0),
                      child: Text('Hora', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    for (var dia in dias)
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Text(dia, style: const TextStyle(fontWeight: FontWeight.bold)),
                      ),
                  ],
                ),
                for (int i = 0; i < horas.length; i++)
                  TableRow(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(horas[i]),
                      ),
                      for (int j = 0; j < dias.length; j++)
                        _HorarioCelda(info: horario[j][i], color: Colors.primaries[(i + j) % Colors.primaries.length].shade100),
                    ],
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _HorarioCelda extends StatefulWidget {
  final Map<String, String> info;
  final Color color;

  const _HorarioCelda({required this.info, required this.color});

  @override
  State<_HorarioCelda> createState() => _HorarioCeldaState();
}

class _HorarioCeldaState extends State<_HorarioCelda> {
  bool _expandido = false;

  @override
  Widget build(BuildContext context) {
    if (widget.info.isEmpty) {
      return const SizedBox.shrink();
    }

    return GestureDetector(
      onTap: () => setState(() => _expandido = !_expandido),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(8),
        height: _expandido ? 120 : 60,
        decoration: BoxDecoration(
          color: widget.color,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              widget.info['materia'] ?? '',
              style: const TextStyle(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            if (_expandido) ...[
              const SizedBox(height: 6),
              Text(widget.info['maestro'] ?? '', style: const TextStyle(fontSize: 13)),
              Text(widget.info['contacto'] ?? '', style: const TextStyle(fontSize: 12, color: Colors.black54)),
            ]
          ],
        ),
      ),
    );
  }
}
