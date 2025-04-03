import 'package:flutter/material.dart';
import 'package:proyectoeducativo/widgetsDesktop/actividad_detalle.dart.dart';

class ActividadesWidget extends StatelessWidget {
  const ActividadesWidget({super.key});

  final List<Map<String, dynamic>> actividades = const [
    {
      'materia': 'Tópicos Avanzados de Programación',
      'titulo': 'Proyecto POO',
      'descripcion': 'Desarrolla un sistema con clases abstractas y herencia.',
      'fechaLimite': '7 abril 2025 - 11:59 PM',
      'color': Color(0xFFBBDEFB),
    },
    {
      'materia': 'Métodos Numéricos',
      'titulo': 'Tarea Interpolación',
      'descripcion': 'Resolver ejercicios con el método de Lagrange.',
      'fechaLimite': '9 abril 2025 - 11:59 PM',
      'color': Color(0xFFFFF9C4),
    },
    {
      'materia': 'Simulación',
      'titulo': 'Modelado de eventos discretos',
      'descripcion': 'Investigar y representar un sistema discreto.',
      'fechaLimite': '11 abril 2025 - 11:59 PM',
      'color': Color(0xFFB2EBF2),
    },
    {
      'materia': 'Ecuaciones Diferenciales',
      'titulo': 'Ecuaciones de segundo orden',
      'descripcion': 'Ejercicios del tema 4 del libro guía.',
      'fechaLimite': '10 abril 2025 - 11:59 PM',
      'color': Color(0xFFC8E6C9),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Actividades Disponibles',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: ListView.builder(
              itemCount: actividades.length,
              itemBuilder: (context, index) {
                final actividad = actividades[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ActividadDetallePage(
                          materia: actividad['materia'],
                          titulo: actividad['titulo'],
                          descripcion: actividad['descripcion'],
                          fechaLimite: actividad['fechaLimite'],
                          color: actividad['color'],
                        ),
                      ),
                    );
                  },
                  child: Card(
                    color: actividad['color'],
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 16,
                      ),
                      title: Text(
                        actividad['titulo'],
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        actividad['materia'],
                        style: const TextStyle(fontSize: 16),
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios),
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
