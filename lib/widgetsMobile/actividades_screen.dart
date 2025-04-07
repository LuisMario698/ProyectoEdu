import 'package:flutter/material.dart';
import '../models/actividad_model.dart';
import '../models/materia_model.dart';
import '../conexion/db.dart';
import 'actividad_form.dart';
import 'package:intl/intl.dart';

class ActividadesScreen extends StatefulWidget {
  const ActividadesScreen({super.key});

  @override
  State<ActividadesScreen> createState() => _ActividadesScreenState();
}

class _ActividadesScreenState extends State<ActividadesScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final DatabaseHelper _dbHelper = DatabaseHelper();
  
  List<Actividad> _actividadesPendientes = [];
  List<Actividad> _actividadesNoEntregadas = [];
  List<Actividad> _actividadesCompletadas = [];
  Map<int, Materia> _materiasMap = {};
  bool _isLoading = true;

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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cargar datos: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _agregarActividad() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ActividadFormWidget(),
      ),
    );

    if (result == true) {
      _cargarDatos(); // Recargar datos si se agregó una actividad
    }
  }

  Future<void> _editarActividad(Actividad actividad) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ActividadFormWidget(actividad: actividad),
      ),
    );

    if (result == true) {
      _cargarDatos(); // Recargar datos si se editó la actividad
    }
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
        _cargarDatos(); // Recargar datos
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
      _cargarDatos(); // Recargar datos
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cambiar estado: $e')),
      );
    }
  }

  Widget _buildActividadCard(Actividad actividad) {
    final materia = _materiasMap[actividad.materiaId];
    final Color materiaColor = materia != null ? Color(materia.color) : Colors.grey;
    final String materiaName = materia?.nombre ?? 'Materia no encontrada';
    final String fechaLimite = DateFormat('dd/MM/yyyy - HH:mm').format(actividad.fechaCierre);
    final bool estaVencida = actividad.fechaCierre.isBefore(DateTime.now()) && !actividad.completada;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: InkWell(
        onTap: () => _mostrarDetalleActividad(actividad),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Encabezado con color de la materia
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: materiaColor.withOpacity(0.8),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(8),
                  topRight: Radius.circular(8),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      actividad.nombre,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      overflow: TextOverflow.ellipsis,
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
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Materia
                  Row(
                    children: [
                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: materiaColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        materiaName,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Descripción
                  Text(
                    actividad.descripcion,
                    style: const TextStyle(fontSize: 14),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  // Fecha límite
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        size: 14,
                        color: estaVencida ? Colors.red : Colors.grey[700],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Entrega: $fechaLimite',
                        style: TextStyle(
                          fontSize: 12,
                          color: estaVencida ? Colors.red : Colors.grey[700],
                          fontWeight: estaVencida ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Acciones
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // Botón para marcar/desmarcar como completada
                  TextButton.icon(
                    onPressed: () => _cambiarEstadoActividad(actividad),
                    icon: Icon(
                      actividad.completada ? Icons.cancel : Icons.check_circle,
                      color: actividad.completada ? Colors.red : Colors.green,
                    ),
                    label: Text(
                      actividad.completada ? 'Desmarcar' : 'Completar',
                      style: TextStyle(
                        color: actividad.completada ? Colors.red : Colors.green,
                      ),
                    ),
                  ),
                  // Botón para editar
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.blue),
                    onPressed: () => _editarActividad(actividad),
                  ),
                  // Botón para eliminar
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _eliminarActividad(actividad),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _mostrarDetalleActividad(Actividad actividad) {
    final materia = _materiasMap[actividad.materiaId];
    final Color materiaColor = materia != null ? Color(materia.color) : Colors.grey;
    final String materiaName = materia?.nombre ?? 'Materia no encontrada';
    final String fechaCreacion = DateFormat('dd/MM/yyyy - HH:mm').format(actividad.fechaCreacion);
    final String fechaLimite = DateFormat('dd/MM/yyyy - HH:mm').format(actividad.fechaCierre);
    final String? fechaCompletado = actividad.fechaCompletado != null
        ? DateFormat('dd/MM/yyyy - HH:mm').format(actividad.fechaCompletado!)
        : null;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.3,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) => SingleChildScrollView(
          controller: scrollController,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Título
                Center(
                  child: Container(
                    width: 40,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Nombre de la actividad
                Text(
                  actividad.nombre,
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
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
                      materiaName,
                      style: const TextStyle(fontSize: 18),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Estado
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: actividad.completada ? Colors.green : Colors.orange,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    actividad.completada ? 'Completada' : 'Pendiente',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(height: 16),
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
                const SizedBox(height: 16),
                // Fechas
                const Text(
                  'Fechas:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                _buildInfoRow('Creación:', fechaCreacion, Icons.create),
                const SizedBox(height: 8),
                _buildInfoRow('Entrega:', fechaLimite, Icons.event_available),
                if (fechaCompletado != null) ...[  
                  const SizedBox(height: 8),
                  _buildInfoRow('Completada:', fechaCompletado, Icons.check_circle),
                ],
                const SizedBox(height: 24),
                // Botones de acción
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Botón para marcar/desmarcar como completada
                    ElevatedButton.icon(
                      onPressed: () {
                        _cambiarEstadoActividad(actividad);
                        Navigator.pop(context);
                      },
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
                    // Botón para editar
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        _editarActividad(actividad);
                      },
                      icon: const Icon(Icons.edit),
                      label: const Text('Editar'),
                    ),
                    // Botón para eliminar
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        _eliminarActividad(actividad);
                      },
                      icon: const Icon(Icons.delete),
                      label: const Text('Eliminar'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey[700]),
        const SizedBox(width: 8),
        Text(
          '$label ',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey[700]),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(color: Colors.grey[700]),
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
        title: const Text('Actividades'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Pendientes'),
            Tab(text: 'No entregadas'),
            Tab(text: 'Completadas'),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: [
                // Pestaña de actividades pendientes
                _actividadesPendientes.isEmpty
                    ? _buildEmptyState(
                        'No tienes actividades pendientes',
                        Icons.assignment_outlined,
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(8),
                        itemCount: _actividadesPendientes.length,
                        itemBuilder: (context, index) {
                          return _buildActividadCard(_actividadesPendientes[index]);
                        },
                      ),
                
                // Pestaña de actividades no entregadas
                _actividadesNoEntregadas.isEmpty
                    ? _buildEmptyState(
                        'No tienes actividades vencidas sin entregar',
                        Icons.assignment_late_outlined,
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(8),
                        itemCount: _actividadesNoEntregadas.length,
                        itemBuilder: (context, index) {
                          return _buildActividadCard(_actividadesNoEntregadas[index]);
                        },
                      ),
                
                // Pestaña de actividades completadas
                _actividadesCompletadas.isEmpty
                    ? _buildEmptyState(
                        'No tienes actividades completadas',
                        Icons.assignment_turned_in_outlined,
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(8),
                        itemCount: _actividadesCompletadas.length,
                        itemBuilder: (context, index) {
                          return _buildActividadCard(_actividadesCompletadas[index]);
                        },
                      ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _agregarActividad,
        child: const Icon(Icons.add),
      ),
    );
  }
}