import 'package:flutter/material.dart';
import 'package:proyectoeducativo/widgetsMobile/actividades.dart';

class MateriasWidget extends StatefulWidget {
  const MateriasWidget({super.key});

  @override
  _MateriasWidgetState createState() => _MateriasWidgetState();
}

class _MateriasWidgetState extends State<MateriasWidget> {
  final bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();

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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Materias del Semestre'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Implementar búsqueda
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Búsqueda no implementada')),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ListView.builder(
          itemCount: materias.length,
          itemBuilder: (context, index) {
            final materia = materias[index];
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 6.0),
              elevation: 3,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
              color: materia['color'],
              child: ListTile(
                leading: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: materia['color'],
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                title: Text(materia['nombre']),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ActividadesWidget(materiaSeleccionada: materia['nombre']),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
