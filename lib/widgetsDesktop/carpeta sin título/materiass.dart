import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

class MateriasWidget extends StatelessWidget {
  const MateriasWidget({super.key});

  final List<Map<String, dynamic>> materias = const [
    {
      'nombre': 'Tópicos Avanzados de Programación',
      'color': Color(0xFFBBDEFB),
    },
    {
      'nombre': 'Principios Eléctricos y Aplicaciones Digitales',
      'color': Color(0xFFFFCDD2),
    },
    {
      'nombre': 'Ecuaciones Diferenciales',
      'color': Color(0xFFC8E6C9),
    },
    {
      'nombre': 'Inglés 4',
      'color': Color(0xFFD1C4E9),
    },
    {
      'nombre': 'Métodos Numéricos',
      'color': Color(0xFFFFF9C4),
    },
    {
      'nombre': 'Fundamentos de Base de Datos',
      'color': Color(0xFFFFF3E0),
    },
    {
      'nombre': 'Simulación',
      'color': Color(0xFFB2EBF2),
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
            'Materias del Semestre',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
                childAspectRatio: 2.8,
              ),
              itemCount: materias.length,
              itemBuilder: (context, index) {
                final materia = materias[index];
                return Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  color: materia['color'],
                  elevation: 4,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        materia['nombre'],
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
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
