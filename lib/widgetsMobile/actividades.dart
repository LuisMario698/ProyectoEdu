import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/actividad.dart';
import '../models/materia.dart';
import '../services/file_storage.dart';

class ActividadesWidget extends StatefulWidget {
  @override
  _ActividadesWidgetState createState() => _ActividadesWidgetState();
}

class _ActividadesWidgetState extends State<ActividadesWidget> {
  final FileStorage _storage = FileStorage();
  List<Actividad> _actividades = [];
  List<Materia> _materias = [];
  bool _isLoading = true;
  bool _hasError = false;
  String _errorMessage = '';
  
  @override
  void initState() {
    super.initState();
    _cargarDatos();
  }
  
  Future<void> _cargarDatos() async {
    try {
      setState(() {
        _isLoading = true;
        _hasError = false;
        _errorMessage = '';
      });
      
      final actividades = await _storage.getActividades();
      final materias = await _storage.getMaterias();
      
      setState(() {
        _actividades = actividades;
        _materias = materias;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _hasError = true;
        _errorMessage = 'Error al cargar datos: $e';
        debugPrint(_errorMessage);
      });
    }
  }
  
  void _mostrarDialogoNuevaActividad() {
    if (_materias.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Primero debes agregar al menos una materia'),
          duration: Duration(seconds: 3),
        ),
      );
      return;
    }
    
    final tituloController = TextEditingController();
    final descripcionController = TextEditingController();
    Materia? materiaSeleccionada = _materias.isNotEmpty ? _materias[0] : null;
    DateTime fechaSeleccionada = DateTime.now().add(Duration(days: 1));
    
    final DateFormat formatter = DateFormat('dd/MM/yyyy');
    
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Text('Nueva Actividad'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: tituloController,
                    decoration: InputDecoration(
                      labelText: 'Título de la actividad',
                    ),
                  ),
                  SizedBox(height: 16),
                  TextField(
                    controller: descripcionController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      labelText: 'Descripción',
                    ),
                  ),
                  SizedBox(height: 16),
                  DropdownButtonFormField<Materia>(
                    value: materiaSeleccionada,
                    decoration: InputDecoration(
                      labelText: 'Materia',
                    ),
                    items: _materias.map((materia) {
                      return DropdownMenuItem<Materia>(
                        value: materia,
                        child: Text(materia.nombre),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        materiaSeleccionada = newValue;
                      });
                    },
                  ),
                  SizedBox(height: 16),
                  ListTile(
                    title: Text('Fecha de entrega'),
                    subtitle: Text(formatter.format(fechaSeleccionada)),
                    trailing: Icon(Icons.calendar_today),
                    onTap: () async {
                      final DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: fechaSeleccionada,
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2101),
                      );
                      if (pickedDate != null) {
                        setState(() {
                          fechaSeleccionada = pickedDate;
                        });
                      }
                    },
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Cancelar'),
              ),
              TextButton(
                onPressed: () {
                  if (tituloController.text.isNotEmpty && 
                      descripcionController.text.isNotEmpty && 
                      materiaSeleccionada != null) {
                    
                    _storage.saveActividad(
                      tituloController.text,
                      descripcionController.text,
                      materiaSeleccionada!.id,
                      fechaSeleccionada,
                    );
                    
                    Navigator.pop(context);
                    _cargarDatos();
                  }
                },
                child: Text('Guardar'),
              ),
            ],
          );
        }
      ),
    );
  }
  
  Future<void> _marcarComoCompletada(Actividad actividad, bool completada) async {
    try {
      final success = await _storage.marcarActividadCompletada(actividad.id, completada);
      if (success) {
        _cargarDatos();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No se pudo actualizar la actividad'))
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e'))
      );
    }
  }
  
  Future<void> _eliminarActividad(String id) async {
    try {
      final confirmacion = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Eliminar actividad'),
          content: Text('¿Estás seguro que deseas eliminar esta actividad?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text('Eliminar'),
            ),
          ],
        ),
      );
      
      if (confirmacion == true) {
        final success = await _storage.deleteActividad(id);
        if (success == true) {
          _cargarDatos();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('No se pudo eliminar la actividad'))
          );
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e'))
      );
    }
  }
  
  String _getNombreMateria(String materiaId) {
    final materia = _materias.firstWhere(
      (m) => m.id == materiaId,
      orElse: () => Materia(id: '', nombre: 'Desconocida', profesor: '', color: 'FFFFFF'),
    );
    return materia.nombre;
  }
  
  Color _getColorMateria(String materiaId) {
    final materia = _materias.firstWhere(
      (m) => m.id == materiaId,
      orElse: () => Materia(id: '', nombre: '', profesor: '', color: 'FFFFFF'),
    );
    return Color(int.parse('0xFF${materia.color}'));
  }
  
  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }
    
    if (_hasError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Ha ocurrido un error al cargar las actividades'),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _cargarDatos,
              child: Text('Reintentar'),
            ),
          ],
        ),
      );
    }
    
    // Ordenar actividades por fecha
    _actividades.sort((a, b) => a.fechaEntrega.compareTo(b.fechaEntrega));
    
    // Separar actividades completadas y pendientes
    final actividadesPendientes = _actividades.where((a) => !a.completada).toList();
    final actividadesCompletadas = _actividades.where((a) => a.completada).toList();
    
    return Scaffold(
      body: _actividades.isEmpty 
          ? Center(
              child: Text(
                'No hay actividades agregadas.\nPresiona el botón "+" para agregar una nueva actividad.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
            )
          : DefaultTabController(
              length: 2,
              child: Column(
                children: [
                  TabBar(
                    labelColor: Theme.of(context).primaryColor,
                    tabs: [
                      Tab(text: 'Pendientes (${actividadesPendientes.length})'),
                      Tab(text: 'Completadas (${actividadesCompletadas.length})'),
                    ],
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [
                        // Tab de actividades pendientes
                        _buildActividadesList(actividadesPendientes),
                        // Tab de actividades completadas
                        _buildActividadesList(actividadesCompletadas),
                      ],
                    ),
                  ),
                ],
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _mostrarDialogoNuevaActividad,
        child: Icon(Icons.add),
        tooltip: 'Agregar nueva actividad',
      ),
    );
  }
  
  Widget _buildActividadesList(List<Actividad> actividades) {
    if (actividades.isEmpty) {
      return Center(
        child: Text(
          'No hay actividades en esta categoría',
          style: TextStyle(fontSize: 16),
        ),
      );
    }
    
    final DateFormat dateFormatter = DateFormat('dd/MM/yyyy');
    
    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: actividades.length,
      itemBuilder: (context, index) {
        final actividad = actividades[index];
        final esPendiente = !actividad.completada;
        final Color materiaColor = _getColorMateria(actividad.materiaId);
        
        return Card(
          margin: EdgeInsets.only(bottom: 16),
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        actividad.titulo,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          decoration: actividad.completada ? TextDecoration.lineThrough : null,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () => _eliminarActividad(actividad.id),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Text(
                  actividad.descripcion,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black87,
                    decoration: actividad.completada ? TextDecoration.lineThrough : null,
                  ),
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: materiaColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: materiaColor),
                      ),
                      child: Text(
                        _getNombreMateria(actividad.materiaId),
                        style: TextStyle(
                          color: materiaColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Spacer(),
                    Icon(
                      Icons.calendar_today,
                      size: 16,
                      color: esPendiente && actividad.fechaEntrega.isBefore(DateTime.now())
                          ? Colors.red
                          : Colors.grey,
                    ),
                    SizedBox(width: 4),
                    Text(
                      dateFormatter.format(actividad.fechaEntrega),
                      style: TextStyle(
                        fontSize: 14,
                        color: esPendiente && actividad.fechaEntrega.isBefore(DateTime.now())
                            ? Colors.red
                            : Colors.grey,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                esPendiente
                    ? ElevatedButton.icon(
                        onPressed: () => _marcarComoCompletada(actividad, true),
                        icon: Icon(Icons.check),
                        label: Text('Marcar como completada'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          minimumSize: Size(double.infinity, 36),
                        ),
                      )
                    : OutlinedButton.icon(
                        onPressed: () => _marcarComoCompletada(actividad, false),
                        icon: Icon(Icons.refresh),
                        label: Text('Marcar como pendiente'),
                        style: OutlinedButton.styleFrom(
                          minimumSize: Size(double.infinity, 36),
                        ),
                      ),
              ],
            ),
          ),
        );
      },
    );
  }
}
