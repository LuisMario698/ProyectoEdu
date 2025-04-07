import 'package:flutter/material.dart';
import 'package:proyectoeducativo/widgetsDesktop/actividad_detalle.dart.dart';
import 'package:proyectoeducativo/conexion/db.dart';
import 'package:proyectoeducativo/models/actividad_model.dart';
import 'package:proyectoeducativo/models/materia_model.dart';

class ActividadesWidget extends StatefulWidget {
  const ActividadesWidget({super.key});

  @override
  State<ActividadesWidget> createState() => _ActividadesWidgetState();
}

class _ActividadesWidgetState extends State<ActividadesWidget> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  late Future<List<Actividad>> _actividadesFuture;
  bool _isLoading = true;
  String _errorMessage = "";

  @override
  void initState() {
    super.initState();
    _loadActividades();
  }

  // Cargar actividades de la base de datos
  Future<void> _loadActividades() async {
    setState(() {
      _isLoading = true;
      _errorMessage = "";
    });

    try {
      _actividadesFuture = _dbHelper.getActividades();
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = "Error al cargar actividades: $e";
      });
    }
  }

  // Datos de ejemplo si no hay actividades en la base de datos
  final List<Map<String, dynamic>> actividadesEjemplo = const [
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Actividades Disponibles',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              ElevatedButton.icon(
                onPressed: _loadActividades,
                icon: const Icon(Icons.refresh),
                label: const Text('Actualizar'),
              ),
            ],
          ),
          const SizedBox(height: 24),
          if (_isLoading) 
            const Center(child: CircularProgressIndicator())
          else if (_errorMessage.isNotEmpty)
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(_errorMessage, style: const TextStyle(color: Colors.red)),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _isLoading = false;
                        _errorMessage = "";
                      });
                    },
                    child: const Text('Mostrar datos de ejemplo'),
                  ),
                ],
              ),
            )
          else
            Expanded(
              child: FutureBuilder<List<Actividad>>(
                future: _actividadesFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Error: ${snapshot.error}', style: const TextStyle(color: Colors.red)),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              // Usar datos de ejemplo en caso de error
                              setState(() {
                                _errorMessage = "";
                              });
                            },
                            child: const Text('Mostrar datos de ejemplo'),
                          ),
                        ],
                      ),
                    );
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    // Si no hay datos en la base de datos, mostrar datos de ejemplo
                    return ListView.builder(
                      itemCount: actividadesEjemplo.length,
                      itemBuilder: (context, index) {
                        final actividad = actividadesEjemplo[index];
                        return _buildActividadCard(actividad);
                      },
                    );
                  }
                  
                  // Mostrar actividades de la base de datos
                  final actividades = snapshot.data!;
                  return ListView.builder(
                    itemCount: actividades.length,
                    itemBuilder: (context, index) {
                      final actividad = actividades[index];
                      // Convertir el formato de actividad a map para usar con _buildActividadCard
                      final actividadMap = {
                        'titulo': actividad.nombre,
                        'descripcion': actividad.descripcion,
                        'materia': 'Materia ID: ${actividad.materiaId}',
                        'fechaLimite': '${actividad.fechaCierre.day}/${actividad.fechaCierre.month}/${actividad.fechaCierre.year}',
                        'color': const Color(0xFFBBDEFB),  // Color predeterminado
                      };
                      return _buildActividadCard(actividadMap);
                    },
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildActividadCard(Map<String, dynamic> actividad) {
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
  }
}
