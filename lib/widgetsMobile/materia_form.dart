import 'package:flutter/material.dart';
import '../models/materia_model.dart';
import '../conexion/db.dart';
import '../utils/color_utils.dart';

class MateriaFormWidget extends StatefulWidget {
  final Materia? materia; // Null para crear nueva, objeto para editar

  const MateriaFormWidget({super.key, this.materia});

  @override
  State<MateriaFormWidget> createState() => _MateriaFormWidgetState();
}

class _MateriaFormWidgetState extends State<MateriaFormWidget> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _descripcionController = TextEditingController();
  final _maestroController = TextEditingController();
  final DatabaseHelper _dbHelper = DatabaseHelper();
  
  int _colorSeleccionado = 0;
  List<int> _coloresEnUso = [];
  List<Color> _coloresDisponibles = ColorUtils.materiasColors;
  bool _isLoading = true;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _isEditing = widget.materia != null;
    _cargarDatos();
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _descripcionController.dispose();
    _maestroController.dispose();
    super.dispose();
  }

  Future<void> _cargarDatos() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Obtener colores en uso
      _coloresEnUso = await _dbHelper.getColoresEnUso();
      
      if (_isEditing) {
        // Si estamos editando, cargar los datos de la materia existente
        _nombreController.text = widget.materia!.nombre;
        _descripcionController.text = widget.materia!.descripcion;
        _maestroController.text = widget.materia!.maestro;
        
        // Obtener el índice del color actual de la materia
        _colorSeleccionado = ColorUtils.getIndexOfColor(Color(widget.materia!.color));
        
        // Si el color no se encuentra en la lista de colores disponibles,
        // asignar el primer color disponible
        if (_colorSeleccionado == -1) {
          _colorSeleccionado = ColorUtils.getNextAvailableColorIndex(_coloresEnUso);
        }
      } else {
        // Si es una nueva materia, seleccionar el primer color disponible
        _colorSeleccionado = ColorUtils.getNextAvailableColorIndex(_coloresEnUso);
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

  Future<void> _guardarMateria() async {
    if (_formKey.currentState!.validate()) {
      try {
        final colorValue = ColorUtils.materiasColors[_colorSeleccionado].value;
        
        // Crear o actualizar la materia
        final materia = _isEditing
            ? widget.materia!.copyWith(
                nombre: _nombreController.text,
                descripcion: _descripcionController.text,
                maestro: _maestroController.text,
                color: colorValue,
              )
            : Materia(
                nombre: _nombreController.text,
                descripcion: _descripcionController.text,
                maestro: _maestroController.text,
                color: colorValue,
              );

        if (_isEditing) {
          await _dbHelper.updateMateria(materia);
        } else {
          await _dbHelper.insertMateria(materia);
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
        title: Text(_isEditing ? 'Editar Materia' : 'Nueva Materia'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Nombre de la materia
                    TextFormField(
                      controller: _nombreController,
                      decoration: const InputDecoration(
                        labelText: 'Nombre de la materia',
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
                    
                    // Maestro
                    TextFormField(
                      controller: _maestroController,
                      decoration: const InputDecoration(
                        labelText: 'Maestro',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingrese el nombre del maestro';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
                    
                    // Selector de color
                    const Text(
                      'Color de la materia:',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 5,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                        ),
                        itemCount: _coloresDisponibles.length,
                        itemBuilder: (context, index) {
                          final color = ColorUtils.materiasColors[index];
                          final isSelected = index == _colorSeleccionado;
                          final isDisabled = _coloresEnUso.contains(index) && !(_isEditing && widget.materia?.color == color.value);
                          final textColor = ColorUtils.getTextColorForBackground(color);
                          
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: GestureDetector(
                              onTap: isDisabled
                                  ? () {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text('Este color ya está en uso'),
                                          duration: Duration(seconds: 1),
                                        ),
                                      );
                                    }
                                  : () {
                                      setState(() {
                                        _colorSeleccionado = index;
                                      });
                                    },
                              child: Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: color,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: isSelected
                                        ? Colors.black
                                        : Colors.transparent,
                                    width: 2,
                                  ),
                                  boxShadow: isSelected
                                      ? [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(0.3),
                                            blurRadius: 4,
                                            offset: const Offset(0, 2),
                                          ),
                                        ]
                                      : null,
                                ),
                                child: isDisabled
                                    ? const Icon(
                                        Icons.block,
                                        color: Colors.white,
                                        size: 20,
                                      )
                                    : isSelected
                                        ? const Icon(
                                            Icons.check,
                                            color: Colors.white,
                                            size: 20,
                                          )
                                        : null,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 24),
                    
                    // Botón guardar
                    ElevatedButton(
                      onPressed: _guardarMateria,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: ColorUtils.materiasColors[_colorSeleccionado],
                        foregroundColor: ColorUtils.getTextColorForBackground(
                          ColorUtils.materiasColors[_colorSeleccionado],
                        ),
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
  }
}