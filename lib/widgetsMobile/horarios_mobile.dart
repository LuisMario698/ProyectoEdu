import 'package:flutter/material.dart';

class HorariosWidget extends StatelessWidget {
  const HorariosWidget({super.key});

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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Horario de Clases'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Horario de Clases (7:00 AM - 2:00 PM)',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          // Selector de día (pestañas)
          DefaultTabController(
            length: dias.length,
            child: Expanded(
              child: Column(
                children: [
                  TabBar(
                    isScrollable: true,
                    labelColor: Theme.of(context).primaryColor,
                    tabs: dias.map((dia) => Tab(text: dia)).toList(),
                  ),
                  Expanded(
                    child: TabBarView(
                      children: List.generate(dias.length, (diaIndex) {
                        return _buildHorarioDia(diaIndex);
                      }),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHorarioDia(int diaIndex) {
    return ListView.builder(
      itemCount: horas.length,
      itemBuilder: (context, horaIndex) {
        final clase = horario[diaIndex][horaIndex];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
          child: ExpansionTile(
            title: Text(horas[horaIndex]),
            subtitle: Text(clase['materia'] ?? ''),
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Materia: ${clase['materia']}',
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Text('Profesor: ${clase['maestro']}'),
                    const SizedBox(height: 4),
                    Text('Contacto: ${clase['contacto']}'),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}