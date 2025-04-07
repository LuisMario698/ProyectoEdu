import 'package:flutter/material.dart';
import '../models/actividad_model.dart';
import '../models/materia_model.dart';
import '../conexion/db.dart';
import '../utils/color_utils.dart';
import 'package:intl/intl.dart';

class ActividadFormWidget extends StatefulWidget {
  final Actividad? actividad; // Null para crear nueva, objeto para editar

  const ActividadFormWidget({super.key, this.actividad});

  @override
  State<ActividadFormWidget> createState() => _ActividadFormWidgetState();
}

class _ActividadFormWidgetState extends State<ActividadFormWidget> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _descripcionController = TextEditingController();
  final DatabaseHelper _dbHelper = DatabaseHelper();
  
  List<Materia> _materias = [];
  Materia? _materiaSeleccionada;
  DateTime _fechaCierre = DateTime.now().add(const Duration(days: 7));
  bool _isLoading = true;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _isEditing = widget.actividad != null;
    _cargarDatos();
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _descripcionController.dispose();
    super.dispose();
  }

  Future<void> _cargarDatos() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Cargar materias
      _materias = await _dbHelper.getMaterias();
      
      // Si estamos editando, cargar datos de la actividad
      if (_isEditing) {
        _nombreController.text = widget.actividad!.nombre;
        _descripcionController.text = widget.actividad!.descripcion;
        _fechaCierre = widget.actividad!.fechaCierre;
        
        // Buscar la materia seleccionada
        for (var materia in _materias) {
          if (materia.id == widget.actividad!.materiaId) {
            _materiaSeleccionada = materia;
            break;
          }
        }
      } else if (_materias.isNotEmpty) {
        // Si es una nueva actividad, seleccionar la primera materia por defecto
        _materiaSeleccionada = _materias.first;
      }
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

  Future<void> _seleccionarFecha() async {
    final DateTime? fechaSeleccionada = await showDatePicker(
      context: context,
      initialDate: _fechaCierre,
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    );

    if (fechaSeleccionada != null) {
      final TimeOfDay? horaSeleccionada = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_fechaCierre),
      );

      if (horaSeleccionada != null) {
        setState(() {
          _fechaCierre = DateTime(
            fechaSeleccionada.year,
            fechaSeleccionada.month,
            fechaSeleccionada.day,
            horaSeleccionada.hour,
            horaSeleccionada.minute,
          );
        });
      }
    }
  }

  Future<void> _guardarActividad() async {
    if (_formKey.currentState!.validate()) {
      if (_materiaSeleccionada == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Debes seleccionar una materia')),
        );
        return;
      }

      try {
        final actividad = _isEditing
            ? widget.actividad!.copyWith(
                materiaId: _materiaSeleccionada!.id!,
                nombre: _nombreController.text,
                descripcion: _descripcionController.text,
                fechaCierre: _fechaCierre,
              )
            : Actividad(
                materiaId: _materiaSeleccionada!.id!,
                nombre: _nombreController.text,
                descripcion: _descripcionController.text,
                fechaCreacion: DateTime.now(),
                fechaCierre: _fechaCierre,
                fechaCompletado: null,
                completada: false,
              );

        if (_isEditing) {
          await _dbHelper.updateActividad(actividad);
        } else {
          await _dbHelper.insertActividad(actividad);
        }

        if (mounted) {
          Navigator.pop(context, true); // Retornar true para indicar éxito
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al guardar: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Editar Actividad' : 'Nueva Actividad'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _materias.isEmpty
              ? const Center(
                  child: Text(
                    'No hay materias registradas. Debes crear al menos una materia.',
                    textAlign: TextAlign.center,
                  ),
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Selector de materia
                        DropdownButtonFormField<Materia>(
                          decoration: const InputDecoration(
                            labelText: 'Materia',
                            border: OutlineInputBorder(),
                          ),
                          value: _materiaSeleccionada,
                          items: _materias.map((materia) {
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
                            setState(() {
                              _materiaSeleccionada = value;
                            });
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
                          controller: _nombreController,
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
                          controller: _descripcionController,
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
                            DateFormat('dd/MM/yyyy - HH:mm').format(_fechaCierre),
                          ),
                          trailing: const Icon(Icons.calendar_today),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                            side: const BorderSide(color: Colors.grey),
                          ),
                          onTap: _seleccionarFecha,
                        ),
                        const SizedBox(height: 24),
                        
                        // Botón guardar
                        ElevatedButton(
                          onPressed: _guardarActividad,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: Text(
                            _isEditing ? 'Actualizar' : 'Guardar',
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
    );
  } // End of ActividadFormWidgetState
} // End of ActividadFormWidget
