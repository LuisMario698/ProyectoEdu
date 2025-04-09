import 'package:flutter/material.dart';
import '../models/actividad_model.dart';
import '../models/materia_model.dart';
import '../conexion/db.dart';
import 'package:intl/intl.dart';

class ActividadesDesktop extends StatefulWidget {
  const ActividadesDesktop({super.key});

  @override
  State<ActividadesDesktop> createState() => _ActividadesDesktopState();
}

class _ActividadesDesktopState extends State<ActividadesDesktop> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final DatabaseHelper _dbHelper = DatabaseHelper();
  
  List<Actividad> _actividadesPendientes = [];
  List<Actividad> _actividadesNoEntregadas = [];
  List<Actividad> _actividadesCompletadas = [];
  Map<int, Materia> _materiasMap = {};
  bool _isLoading = true;
  Actividad? _actividadSeleccionada;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _cargarDatos();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _cargarDatos() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Cargar todas las materias y crear un mapa para acceso rápido
      final materias = await _dbHelper.getMaterias();
      _materiasMap = {for (var m in materias) m.id!: m};
      
      // Cargar actividades por categoría
      _actividadesPendientes = await _dbHelper.getActividadesPendientes();
      _actividadesNoEntregadas = await _dbHelper.getActividadesNoEntregadas();
      _actividadesCompletadas = await _dbHelper.getActividadesPorEstado(true);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al cargar datos: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _agregarActividad() async {
    await _mostrarFormularioActividad();
    _cargarDatos();
  }

  Future<void> _editarActividad(Actividad actividad) async {
    await _mostrarFormularioActividad(actividad: actividad);
    _cargarDatos();
  }

  Future<void> _mostrarFormularioActividad({Actividad? actividad}) async {
    final formKey = GlobalKey<FormState>();
    final nombreController = TextEditingController(text: actividad?.nombre ?? '');
    final descripcionController = TextEditingController(text: actividad?.descripcion ?? '');
    
    List<Materia> materias = await _dbHelper.getMaterias();
    Materia? materiaSeleccionada;
    
    if (actividad != null) {
      for (var materia in materias) {
        if (materia.id == actividad.materiaId) {
          materiaSeleccionada = materia;
          break;
        }
      }
    } else if (materias.isNotEmpty) {
      materiaSeleccionada = materias.first;
    }
    
    DateTime fechaCierre = actividad?.fechaCierre ?? DateTime.now().add(const Duration(days: 7));
    
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(actividad == null ? 'Nueva Actividad' : 'Editar Actividad'),
        content: SizedBox(
          width: 500,
          child: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Selector de materia
                  DropdownButtonFormField<Materia>(
                    decoration: const InputDecoration(
                      labelText: 'Materia',
                      border: OutlineInputBorder(),
                    ),
                    value: materiaSeleccionada,
                    items: materias.map((materia) {
                      return DropdownMenuItem<Materia>(
                        value: materia,
                        child: Row(
                          children: [
                            Container(
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                color: Color(materia.color),
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(materia.nombre),
                          ],
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      materiaSeleccionada = value;
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'Por favor selecciona una materia';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  
                  // Nombre de la actividad
                  TextFormField(
                    controller: nombreController,
                    decoration: const InputDecoration(
                      labelText: 'Nombre de la actividad',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingresa un nombre';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  
                  // Descripción
                  TextFormField(
                    controller: descripcionController,
                    decoration: const InputDecoration(
                      labelText: 'Descripción',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 3,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingresa una descripción';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  
                  // Fecha de cierre
                  ListTile(
                    title: const Text('Fecha de entrega'),
                    subtitle: Text(
                      DateFormat('dd/MM/yyyy - HH:mm').format(fechaCierre),
                    ),
                    trailing: const Icon(Icons.calendar_today),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                      side: const BorderSide(color: Colors.grey),
                    ),
                    onTap: () async {
                      final DateTime? fechaSeleccionada = await showDatePicker(
                        context: context,
                        initialDate: fechaCierre,
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2030),
                      );

                      if (fechaSeleccionada != null) {
                        final TimeOfDay? horaSeleccionada = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.fromDateTime(fechaCierre),
                        );

                        if (horaSeleccionada != null) {
                          fechaCierre = DateTime(
                            fechaSeleccionada.year,
                            fechaSeleccionada.month,
                            fechaSeleccionada.day,
                            horaSeleccionada.hour,
                            horaSeleccionada.minute,
                          );
                        }
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (formKey.currentState!.validate() && materiaSeleccionada != null) {
                try {
                  final nuevaActividad = actividad != null
                      ? actividad.copyWith(
                          materiaId: materiaSeleccionada!.id!,
                          nombre: nombreController.text,
                          descripcion: descripcionController.text,
                          fechaCierre: fechaCierre,
                        )
                      : Actividad(
                          materiaId: materiaSeleccionada!.id!,
                          nombre: nombreController.text,
                          descripcion: descripcionController.text,
                          fechaCreacion: DateTime.now(),
                          fechaCierre: fechaCierre,
                        );

                  if (actividad != null) {
                    await _dbHelper.updateActividad(nuevaActividad);
                  } else {
                    await _dbHelper.insertActividad(nuevaActividad);
                  }

                  Navigator.pop(context);
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error al guardar: $e')),
                  );
                }
              }
            },
            child: Text(actividad == null ? 'Guardar' : 'Actualizar'),
          ),
        ],
      ),
    );
  }

  Future<void> _eliminarActividad(Actividad actividad) async {
    final confirmacion = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar eliminación'),
        content: Text('¿Estás seguro de eliminar la actividad "${actividad.nombre}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );

    if (confirmacion == true) {
      try {
        await _dbHelper.deleteActividad(actividad.id!);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Actividad eliminada')),
        );
        _cargarDatos();
        setState(() {
          if (_actividadSeleccionada?.id == actividad.id) {
            _actividadSeleccionada = null;
          }
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al eliminar: $e')),
        );
      }
    }
  }

  Future<void> _cambiarEstadoActividad(Actividad actividad) async {
    try {
      if (actividad.completada) {
        await _dbHelper.desmarcarActividadComoCompletada(actividad.id!);
      } else {
        await _dbHelper.marcarActividadComoCompletada(actividad.id!);
      }
      _cargarDatos();
      if (_actividadSeleccionada?.id == actividad.id) {
        // Actualizar la actividad seleccionada si es la misma
        final actividades = await _dbHelper.getActividades();
        for (var a in actividades) {
          if (a.id == actividad.id) {
            setState(() {
              _actividadSeleccionada = a;
            });
            break;
          }
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cambiar estado: $e')),
      );
    }
  }

  Widget _buildActividadItem(Actividad actividad) {
    final materia = _materiasMap[actividad.materiaId];
    final Color materiaColor = materia != null ? Color(materia.color) : Colors.grey;
    final bool estaVencida = actividad.fechaCierre.isBefore(DateTime.now()) && !actividad.completada;
    final bool esSeleccionada = _actividadSeleccionada?.id == actividad.id;

    return ListTile(
      selected: esSeleccionada,
      selectedTileColor: Colors.blue.withOpacity(0.1),
      leading: Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          color: materiaColor,
          shape: BoxShape.circle,
        ),
        child: actividad.completada
            ? const Icon(Icons.check, size: 16, color: Colors.white)
            : estaVencida
                ? const Icon(Icons.warning, size: 16, color: Colors.white)
                : null,
      ),
      title: Text(
        actividad.nombre,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          decoration: actividad.completada ? TextDecoration.lineThrough : null,
        ),
      ),
      subtitle: Text(
        materia?.nombre ?? 'Materia no encontrada',
        style: TextStyle(
          color: estaVencida ? Colors.red : null,
        ),
      ),
      trailing: Text(
        DateFormat('dd/MM/yyyy').format(actividad.fechaCierre),
        style: TextStyle(
          color: estaVencida ? Colors.red : null,
          fontWeight: estaVencida ? FontWeight.bold : null,
        ),
      ),
      onTap: () {
        setState(() {
          _actividadSeleccionada = actividad;
        });
      },
    );
  }

  Widget _buildDetalleActividad() {
    if (_actividadSeleccionada == null) {
      return const Center(
        child: Text(
          'Selecciona una actividad para ver sus detalles',
          style: TextStyle(fontSize: 16),
        ),
      );
    }

    final actividad = _actividadSeleccionada!;
    final materia = _materiasMap[actividad.materiaId];
    final Color materiaColor = materia != null ? Color(materia.color) : Colors.grey;
    final String materiaName = materia?.nombre ?? 'Materia no encontrada';
    final String fechaCreacion = DateFormat('dd/MM/yyyy - HH:mm').format(actividad.fechaCreacion);
    final String fechaLimite = DateFormat('dd/MM/yyyy - HH:mm').format(actividad.fechaCierre);
    final String? fechaCompletado = actividad.fechaCompletado != null
        ? DateFormat('dd/MM/yyyy - HH:mm').format(actividad.fechaCompletado!)
        : null;
    final bool estaVencida = actividad.fechaCierre.isBefore(DateTime.now()) && !actividad.completada;

    return Card(
      elevation: 4,
      margin: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Encabezado con color de la materia
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: materiaColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(4),
                topRight: Radius.circular(4),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    actividad.nombre,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                if (actividad.completada)
                  const Icon(Icons.check_circle, color: Colors.white),
                if (estaVencida)
                  const Icon(Icons.warning, color: Colors.white),
              ],
            ),
          ),
          // Contenido
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Materia
                  Row(
                    children: [
                      Container(
                        width: 16,
                        height: 16,
                        decoration: BoxDecoration(
                          color: materiaColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Materia: $materiaName',
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Estado
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: actividad.completada
                          ? Colors.green
                          : estaVencida
                              ? Colors.red
                              : Colors.orange,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      actividad.completada
                          ? 'Completada'
                          : estaVencida
                              ? 'No entregada'
                              : 'Pendiente',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Descripción
                  const Text(
                    'Descripción:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    actividad.descripcion,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 24),
                  // Fechas
                  const Text(
                    'Fechas:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  _buildInfoRow('Creación:', fechaCreacion, Icons.create),
                  const SizedBox(height: 8),
                  _buildInfoRow(
                    'Entrega:',
                    fechaLimite,
                    Icons.event_available,
                    color: estaVencida ? Colors.red : null,
                  ),
                  if (fechaCompletado != null) ...[  
                    const SizedBox(height: 8),
                    _buildInfoRow('Completada:', fechaCompletado, Icons.check_circle, color: Colors.green),
                  ],
                ],
              ),
            ),
          ),
          // Botones de acción
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // Botón para marcar/desmarcar como completada
                ElevatedButton.icon(
                  onPressed: () => _cambiarEstadoActividad(actividad),
                  icon: Icon(
                    actividad.completada ? Icons.cancel : Icons.check_circle,
                  ),
                  label: Text(
                    actividad.completada ? 'Desmarcar' : 'Completar',
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: actividad.completada ? Colors.red : Colors.green,
                    foregroundColor: Colors.white,
                  ),
                ),
                const SizedBox(width: 8),
                // Botón para editar
                ElevatedButton.icon(
                  onPressed: () => _editarActividad(actividad),
                  icon: const Icon(Icons.edit),
                  label: const Text('Editar'),
                ),
                const SizedBox(width: 8),
                // Botón para eliminar
                ElevatedButton.icon(
                  onPressed: () => _eliminarActividad(actividad),
                  icon: const Icon(Icons.delete),
                  label: const Text('Eliminar'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, IconData icon, {Color? color}) {
    return Row(
      children: [
        Icon(icon, size: 16, color: color ?? Colors.grey[700]),
        const SizedBox(width: 8),
        Text(
          '$label ',
          style: TextStyle(fontWeight: FontWeight.bold, color: color ?? Colors.grey[700]),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(color: color ?? Colors.grey[700]),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState(String mensaje, IconData icon) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            mensaje,
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _agregarActividad,
            icon: const Icon(Icons.add),
            label: const Text('Agregar actividad'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestión de Actividades'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Agregar actividad',
            onPressed: _agregarActividad,
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Actualizar',
            onPressed: _cargarDatos,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Row(
              children: [
                // Panel izquierdo con pestañas y listas
                Expanded(
                  flex: 2,
                  child: Column(
                    children: [
                      // Pestañas
                      TabBar(
                        controller: _tabController,
                        labelColor: Theme.of(context).primaryColor,
                        tabs: const [
                          Tab(text: 'Pendientes'),
                          Tab(text: 'No entregadas'),
                          Tab(text: 'Completadas'),
                        ],
                      ),
                      // Contenido de las pestañas
                      Expanded(
                        child: TabBarView(
                          controller: _tabController,
                          children: [
                            // Pestaña de actividades pendientes
                            _actividadesPendientes.isEmpty
                                ? _buildEmptyState(
                                    'No tienes actividades pendientes',
                                    Icons.assignment_outlined,
                                  )
                                : ListView.builder(
                                    itemCount: _actividadesPendientes.length,
                                    itemBuilder: (context, index) {
                                      return _buildActividadItem(_actividadesPendientes[index]);
                                    },
                                  ),
                            
                            // Pestaña de actividades no entregadas
                            _actividadesNoEntregadas.isEmpty
                                ? _buildEmptyState(
                                    'No tienes actividades vencidas sin entregar',
                                    Icons.assignment_late_outlined,
                                  )
                                : ListView.builder(
                                    itemCount: _actividadesNoEntregadas.length,
                                    itemBuilder: (context, index) {
                                      return _buildActividadItem(_actividadesNoEntregadas[index]);
                                    },
                                  ),
                            
                            // Pestaña de actividades completadas
                            _actividadesCompletadas.isEmpty
                                ? _buildEmptyState(
                                    'No tienes actividades completadas',
                                    Icons.assignment_turned_in_outlined,
                                  )
                                : ListView.builder(
                                    itemCount: _actividadesCompletadas.length,
                                    itemBuilder: (context, index) {
                                      return _buildActividadItem(_actividadesCompletadas[index]);
                                    },
                                  ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                // Separador vertical
                const VerticalDivider(width: 1),
                // Panel derecho con detalles
                Expanded(
                  flex: 3,
                  child: _buildDetalleActividad(),
                ),
              ],
            ),
    );
  }
}