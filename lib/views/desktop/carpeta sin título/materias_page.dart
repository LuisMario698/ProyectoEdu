import 'package:flutter/material.dart';
import '../../models/materia_model.dart';
import '../../conexion/db.dart';
import '../../utils/color_utils.dart'; // Importar utilidades de color

class MateriasPage extends StatefulWidget {
  final Materia? materiaSeleccionada;
  
  const MateriasPage({super.key, this.materiaSeleccionada});

  @override
  State<MateriasPage> createState() => _MateriasPageState();
}

class _MateriasPageState extends State<MateriasPage> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  List<Materia> _materias = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadMaterias();
    
    // Si hay una materia seleccionada, mostrar el formulario de edición
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.materiaSeleccionada != null) {
        _showFormDialog(materia: widget.materiaSeleccionada);
      }
    });
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
    
    // Color seleccionado inicialmente (usar el color de la materia o el primero de la lista)
    Color colorSeleccionado = materia != null 
        ? Color(materia.color) 
        : ColorUtils.materiasColors[0];

    return showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
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
                  const SizedBox(height: 16),
                  const Text('Color de la materia:', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  // Selector de colores
                  SizedBox(
                    height: 50,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: ColorUtils.materiasColors.length,
                      itemBuilder: (context, index) {
                        final color = ColorUtils.materiasColors[index];
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              colorSeleccionado = color;
                            });
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: color,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: colorSeleccionado.value == color.value 
                                    ? Colors.black 
                                    : Colors.transparent,
                                width: 2,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
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
                  
                  final nuevaMateria = materia == null
                    ? Materia(
                        nombre: nombreController.text,
                        descripcion: descripcionController.text,
                        maestro: maestroController.text,
                        color: colorSeleccionado.value, // Usar el color seleccionado
                      )
                    : materia.copyWith(
                        nombre: nombreController.text,
                        descripcion: descripcionController.text,
                        maestro: maestroController.text,
                        color: colorSeleccionado.value, // Actualizar el color
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
              : ListView.builder(
                  itemCount: _materias.length,
                  itemBuilder: (context, index) {
                    final materia = _materias[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      child: ListTile(
                        title: Text(materia.nombre),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Descripción: ${materia.descripcion}'),
                            Text('Maestro: ${materia.maestro}'),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () => _showFormDialog(materia: materia),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () => _confirmarEliminar(materia),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showFormDialog(),
        child: const Icon(Icons.add),
      ),
    );
  }
}