import 'package:flutter/material.dart';
import 'package:proyectoeducativo/conexion/db.dart';
import 'package:proyectoeducativo/models/actividad_model.dart';
import 'package:proyectoeducativo/models/materia_model.dart';

class ActividadesPage extends StatefulWidget {
  const ActividadesPage({super.key});

  @override
  State<ActividadesPage> createState() => _ActividadesPageState();
}

class _ActividadesPageState extends State<ActividadesPage> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  List<Actividad> _actividadesPendientes = [];
  List<Actividad> _actividadesCompletadas = [];
  List<Materia> _materias = [];
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _cargarDatos();
  }

  Future<void> _cargarDatos() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      // Primero creamos/actualizamos la base de datos inicializando datos de ejemplo
      await _dbHelper.inicializarDatosEjemplo();
      
      // Cargar materias
      _materias = await _dbHelper.getMaterias();
      
      // Cargar actividades
      final actividades = await _dbHelper.getActividades();
      
      _actividadesPendientes = [];
      _actividadesCompletadas = [];

      // Dividir actividades en pendientes y completadas
      for (var actividad in actividades) {
        if (actividad.completada) {
          _actividadesCompletadas.add(actividad);
        } else {
          _actividadesPendientes.add(actividad);
        }
      }
      
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Error al cargar datos: $e';
        print("Error detallado: $e");
      });
    }
  }

  Future<void> _toggleCompletada(Actividad actividad) async {
    try {
      if (actividad.completada) {
        await _dbHelper.desmarcarActividadComoCompletada(actividad.id!);
      } else {
        await _dbHelper.marcarActividadComoCompletada(actividad.id!);
      }
      // Recargar datos
      await _cargarDatos();
    } catch (e) {
      setState(() {
        _errorMessage = 'Error al actualizar la actividad: $e';
      });
    }
  }

  String _obtenerNombreMateria(int? materiaId) {
    if (materiaId == null) return 'Sin materia asignada';
    final materia = _materias.firstWhere(
      (m) => m.id == materiaId,
      orElse: () => Materia(nombre: 'Materia desconocida'),
    );
    return materia.nombre;
  }

  Color _obtenerColorMateria(int? materiaId) {
    if (materiaId == null) return Colors.grey;
    final materia = _materias.firstWhere(
      (m) => m.id == materiaId,
      orElse: () => Materia(nombre: 'Desconocida', color: 0xFFE0E0E0),
    );
    return Color(materia.color);
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_errorMessage.isNotEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Actividades')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _errorMessage,
                style: const TextStyle(color: Colors.red),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _cargarDatos,
                child: const Text('Reintentar'),
              ),
            ],
          ),
        ),
      );
    }

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Actividades'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Pendientes'),
              Tab(text: 'Completadas'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Pestaña de actividades pendientes
            _buildActividadesList(_actividadesPendientes, false),
            
            // Pestaña de actividades completadas
            _buildActividadesList(_actividadesCompletadas, true),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _mostrarDialogoNuevaActividad,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  Widget _buildActividadesList(List<Actividad> actividades, bool completadas) {
    if (actividades.isEmpty) {
      return Center(
        child: Text(
          completadas
              ? 'No hay actividades completadas'
              : 'No hay actividades pendientes',
          style: const TextStyle(fontSize: 18),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _cargarDatos,
      child: ListView.builder(
        itemCount: actividades.length,
        itemBuilder: (context, index) {
          final actividad = actividades[index];
          final nombreMateria = _obtenerNombreMateria(actividad.materiaId);
          final colorMateria = _obtenerColorMateria(actividad.materiaId);
          
          return Card(
            color: colorMateria.withOpacity(0.3),
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: ListTile(
              title: Text(
                actividad.nombre,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(nombreMateria),
                  Text(
                    'Fecha límite: ${actividad.fechaCierre.day}/${actividad.fechaCierre.month}/${actividad.fechaCierre.year}',
                    style: TextStyle(
                      color: actividad.fechaCierre.isBefore(DateTime.now()) && !actividad.completada
                          ? Colors.red
                          : null,
                    ),
                  ),
                ],
              ),
              trailing: Checkbox(
                value: actividad.completada,
                onChanged: (value) {
                  _toggleCompletada(actividad);
                },
              ),
              onTap: () => _mostrarDetalleActividad(actividad, nombreMateria, colorMateria),
            ),
          );
        },
      ),
    );
  }

  void _mostrarDetalleActividad(Actividad actividad, String nombreMateria, Color colorMateria) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(actividad.nombre),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Materia: $nombreMateria'),
            const SizedBox(height: 8),
            Text('Descripción: ${actividad.descripcion}'),
            const SizedBox(height: 8),
            Text(
              'Fecha de entrega: ${actividad.fechaCierre.day}/${actividad.fechaCierre.month}/${actividad.fechaCierre.year}',
            ),
            const SizedBox(height: 8),
            Text(
              'Estado: ${actividad.completada ? "Completada" : "Pendiente"}',
            ),
            if (actividad.completada && actividad.fechaCompletado != null)
              Text(
                'Completada el: ${actividad.fechaCompletado!.day}/${actividad.fechaCompletado!.month}/${actividad.fechaCompletado!.year}',
              ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cerrar'),
          ),
          if (!actividad.completada)
            ElevatedButton(
              onPressed: () {
                _toggleCompletada(actividad);
                Navigator.of(context).pop();
              },
              child: const Text('Marcar como completada'),
            ),
          if (actividad.completada)
            ElevatedButton(
              onPressed: () {
                _toggleCompletada(actividad);
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
              ),
              child: const Text('Desmarcar'),
            ),
        ],
      ),
    );
  }

  void _mostrarDialogoNuevaActividad() async {
    final nombreController = TextEditingController();
    final descripcionController = TextEditingController();
    Materia? materiaSeleccionada;
    DateTime fechaSeleccionada = DateTime.now().add(const Duration(days: 7));

    await showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Nueva Actividad'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nombreController,
                  decoration: const InputDecoration(labelText: 'Nombre de la actividad'),
                ),
                TextField(
                  controller: descripcionController,
                  decoration: const InputDecoration(labelText: 'Descripción'),
                  maxLines: 3,
                ),
                const SizedBox(height: 16),
                DropdownButton<Materia>(
                  isExpanded: true,
                  hint: const Text('Selecciona una materia'),
                  value: materiaSeleccionada,
                  items: _materias.map((materia) {
                    return DropdownMenuItem(
                      value: materia,
                      child: Text(materia.nombre),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      materiaSeleccionada = value;
                    });
                  },
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Text('Fecha de entrega: '),
                    TextButton(
                      onPressed: () async {
                        final fecha = await showDatePicker(
                          context: context,
                          initialDate: fechaSeleccionada,
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2030),
                        );
                        if (fecha != null) {
                          setState(() {
                            fechaSeleccionada = fecha;
                          });
                        }
                      },
                      child: Text(
                          '${fechaSeleccionada.day}/${fechaSeleccionada.month}/${fechaSeleccionada.year}'),
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (nombreController.text.isEmpty || materiaSeleccionada == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Por favor completa los campos obligatorios'),
                    ),
                  );
                  return;
                }

                final nuevaActividad = Actividad(
                  materiaId: materiaSeleccionada!.id,
                  nombre: nombreController.text,
                  descripcion: descripcionController.text,
                  fechaCierre: fechaSeleccionada,
                );

                try {
                  await _dbHelper.insertActividad(nuevaActividad);
                  Navigator.of(context).pop();
                  _cargarDatos(); // Recargar datos
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error al guardar la actividad: $e'),
                    ),
                  );
                }
              },
              child: const Text('Guardar'),
            ),
          ],
        ),
      ),
    );
  }
}
