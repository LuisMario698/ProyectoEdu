import 'package:flutter/material.dart';
// Ya no necesitamos importar materias_page.dart
import '../conexion/db.dart';
import '../models/materia_model.dart';

class MateriasWidget extends StatefulWidget {
  const MateriasWidget({super.key});

  @override
  State<MateriasWidget> createState() => _MateriasWidgetState();
}

class _MateriasWidgetState extends State<MateriasWidget> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  List<Materia> _materias = [];
  bool _isLoading = true;
  
  // Lista de colores para las materias
  final List<Color> _colores = const [
    Color(0xFFBBDEFB), // Azul claro
    Color(0xFFFFCDD2), // Rojo claro
    Color(0xFFC8E6C9), // Verde claro
    Color(0xFFD1C4E9), // Morado claro
    Color(0xFFFFF9C4), // Amarillo claro
    Color(0xFFFFF3E0), // Naranja claro
    Color(0xFFB2EBF2), // Cyan claro
  ];

  @override
  void initState() {
    super.initState();
    _loadMaterias();
  }

  Future<void> _loadMaterias() async {
    setState(() {
      _isLoading = true;
    });
    
    try {
      final materias = await _dbHelper.getMaterias();
      setState(() {
        _materias = materias;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _showErrorDialog('Error al cargar materias: $e');
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<void> _showFormDialog({Materia? materia}) async {
    final _formKey = GlobalKey<FormState>();
    final nombreController = TextEditingController(text: materia?.nombre ?? '');
    final descripcionController = TextEditingController(text: materia?.descripcion ?? '');
    final maestroController = TextEditingController(text: materia?.maestro ?? '');

    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(materia == null ? 'Agregar Materia' : 'Editar Materia'),
        content: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: nombreController,
                  decoration: const InputDecoration(labelText: 'Nombre'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese un nombre';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: descripcionController,
                  decoration: const InputDecoration(labelText: 'Descripción'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese una descripción';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: maestroController,
                  decoration: const InputDecoration(labelText: 'Maestro'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese el nombre del maestro';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                Navigator.of(context).pop();
                
                // Asignar un color predeterminado para nuevas materias
                final colorPredeterminado = materia == null
                    ? _colores[_materias.length % _colores.length].value // Usar un color basado en la cantidad de materias
                    : materia.color;
                
                final nuevaMateria = materia == null
                    ? Materia(
                        nombre: nombreController.text,
                        descripcion: descripcionController.text,
                        maestro: maestroController.text,
                        color: colorPredeterminado, // Asignar el color predeterminado
                      )
                    : materia.copyWith(
                        nombre: nombreController.text,
                        descripcion: descripcionController.text,
                        maestro: maestroController.text,
                      );

                try {
                  if (materia == null) {
                    await _dbHelper.insertMateria(nuevaMateria);
                  } else {
                    await _dbHelper.updateMateria(nuevaMateria);
                  }
                  _loadMaterias();
                } catch (e) {
                  _showErrorDialog('Error al guardar: $e');
                }
              }
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmarEliminar(Materia materia) async {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar eliminación'),
        content: Text('¿Está seguro que desea eliminar la materia ${materia.nombre}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              try {
                await _dbHelper.deleteMateria(materia.id!);
                _loadMaterias();
              } catch (e) {
                _showErrorDialog('Error al eliminar: $e');
              }
            },
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestión de Materias'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _materias.isEmpty
              ? const Center(child: Text('No hay materias registradas'))
              : GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.8,
                  ),
                  itemCount: _materias.length,
                  itemBuilder: (context, index) {
                    final materia = _materias[index];
                    final color = _colores[index % _colores.length];
                    
                    return GestureDetector(
                      onTap: () => _showFormDialog(materia: materia),
                      child: Card(
                        color: color,
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                materia.nombre,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Profesor: ${materia.maestro}',
                                style: const TextStyle(fontSize: 14),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const Spacer(),
                              Text(
                                materia.descripcion,
                                style: const TextStyle(fontSize: 12),
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.edit, size: 20),
                                    onPressed: () => _showFormDialog(materia: materia),
                                    tooltip: 'Editar',
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete, size: 20),
                                    onPressed: () => _confirmarEliminar(materia),
                                    tooltip: 'Eliminar',
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showFormDialog(),
        child: const Icon(Icons.add),
        tooltip: 'Agregar Materia',
      ),
    );
  }
}