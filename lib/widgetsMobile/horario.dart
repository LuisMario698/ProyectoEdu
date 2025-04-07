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
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Horario Semanal',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          // Implementación móvil: Tabs para cada día
          Expanded(
            child: DefaultTabController(
              length: dias.length,
              child: Column(
                children: [
                  TabBar(
                    isScrollable: true,
                    labelColor: Theme.of(context).primaryColor,
                    unselectedLabelColor: Colors.grey,
                    tabs: dias.map((dia) => Tab(text: dia)).toList(),
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: TabBarView(
                      children: List.generate(dias.length, (diaIndex) {
                        return ListView.builder(
                          itemCount: horas.length,
                          itemBuilder: (context, horaIndex) {
                            final clase = horario[diaIndex][horaIndex];
                            return Card(
                              margin: const EdgeInsets.only(bottom: 8),
                              child: ListTile(
                                title: Text(
                                  clase['materia']!,
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Profesor: ${clase["maestro"]!}'),
                                    Text('Hora: ${horas[horaIndex]}'),
                                  ],
                                ),
                                trailing: IconButton(
                                  icon: const Icon(Icons.info_outline),
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: Text(clase['materia']!),
                                        content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text('Profesor: ${clase["maestro"]!}'),
                                            const SizedBox(height: 8),
                                            Text('Contacto: ${clase["contacto"]!}'),
                                            const SizedBox(height: 8),
                                            Text('Horario: ${horas[horaIndex]}'),
                                            const SizedBox(height: 8),
                                            Text('Día: ${dias[diaIndex]}'),
                                          ],
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () => Navigator.pop(context),
                                            child: const Text('Cerrar'),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                            );
                          },
                        );
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
}