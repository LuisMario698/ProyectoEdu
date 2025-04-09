import 'package:flutter/material.dart';
import '../models/actividad_model.dart';
import '../models/materia_model.dart';
import '../conexion/db.dart';
import 'actividad_form.dart';
import 'package:intl/intl.dart';

class ActividadesScreenDesktop extends StatefulWidget {
  const ActividadesScreenDesktop({super.key});

  @override
  State<ActividadesScreenDesktop> createState() => _ActividadesScreenDesktopState();
}

class _ActividadesScreenDesktopState extends State<ActividadesScreenDesktop> with SingleTickerProviderStateMixin {
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
      _actividadesCompletadas = await _dbHelper.getActividadesCompletadas();

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        // Manejo de errores
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Actividades'),
          bottom: TabBar(
            controller: _tabController,
            tabs: const [
              Tab(text: 'Pendientes'),
              Tab(text: 'No Entregadas'),
              Tab(text: 'Completadas'),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            _buildActividadesList(_actividadesPendientes, false),
            _buildActividadesList(_actividadesNoEntregadas, false),
            _buildActividadesList(_actividadesCompletadas, true),
          ],
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

    return ListView.builder(
      itemCount: actividades.length,
      itemBuilder: (context, index) {
        final actividad = actividades[index];
        final nombreMateria = _materiasMap[actividad.materiaId]?.nombre ?? 'Materia desconocida';
final colorMateria = Color(_materiasMap[actividad.materiaId]?.color ?? 0xFFE0E0E0);

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
        // Lógica para cambiar el estado de completada
      },
    ),
    onTap: () {
      // Lógica para mostrar detalles de la actividad
    },
  ),
);
      },
    );
  }
}