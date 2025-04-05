import 'package:flutter/material.dart';
import '../models/materia.dart';
import '../services/file_storage.dart';
import 'dart:math';

class MateriasWidget extends StatefulWidget {
  const MateriasWidget({Key? key}) : super(key: key);

  @override
  _MateriasWidgetState createState() => _MateriasWidgetState();
}

class _MateriasWidgetState extends State<MateriasWidget> {
  final FileStorage _storage = FileStorage();
  List<Materia> _materias = [];
  bool _isLoading = true;
  bool _hasError = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    debugPrint('📚 Inicializando MateriasWidget');
    _cargarMaterias();
  }

  Future<void> _cargarMaterias() async {
    try {
      debugPrint('🔄 Cargando materias...');
      setState(() {
        _isLoading = true;
        _hasError = false;
        _errorMessage = '';
      });

      final materias = await _storage.getMaterias();
      debugPrint('📚 Materias cargadas: ${materias.length}');

      setState(() {
        _materias = materias;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('❌ Error al cargar materias: $e');
      setState(() {
        _isLoading = false;
        _hasError = true;
        _errorMessage = 'Error al cargar materias: $e';
      });
    }
  }

  void _mostrarDialogoNuevaMateria() {
    debugPrint('🆕 Abriendo diálogo para nueva materia');
    final nombreController = TextEditingController();
    final profesorController = TextEditingController();

    // Lista de colores disponibles
    final List<Color> colores = [
      Colors.red,
      Colors.green,
      Colors.blue,
      Colors.yellow,
      Colors.purple,
      Colors.orange,
      Colors.teal,
      Colors.pink,
    ];

    Color colorSeleccionado = colores[Random().nextInt(colores.length)];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Nueva Materia'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nombreController,
                decoration: InputDecoration(
                  labelText: 'Nombre de la materia',
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: profesorController,
                decoration: InputDecoration(
                  labelText: 'Nombre del profesor',
                ),
              ),
              SizedBox(height: 16),
              Text('Selecciona un color:'),
              SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: colores.map((color) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        colorSeleccionado = color;
                      });
                      Navigator.pop(context);
                      _mostrarDialogoNuevaMateria();
                    },
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: colorSeleccionado == color
                              ? Colors.black
                              : Colors.transparent,
                          width: 2,
                        ),
                      ),
                    ),
                  );
                }).toList(),
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
              if (nombreController.text.isNotEmpty &&
                  profesorController.text.isNotEmpty) {
                debugPrint('💾 Guardando materia: ${nombreController.text}');
                // Convertir el color a string para almacenar
                final colorString = colorSeleccionado.value.toRadixString(16);

                _storage.saveMateria(
                  nombreController.text,
                  profesorController.text,
                  colorString,
                );

                Navigator.pop(context);
                debugPrint('🔄 Recargando materias después de guardar');
                _cargarMaterias();

                // Mostrar mensaje de éxito
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Materia "${nombreController.text}" agregada correctamente',
                    ),
                  ),
                );
              }
            },
            child: Text('Guardar'),
          ),
        ],
      ),
    );
  }

  Future<void> _eliminarMateria(String id) async {
    try {
      final confirmacion = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Eliminar materia'),
          content: Text(
            '¿Estás seguro que deseas eliminar esta materia? También se eliminarán todas las actividades asociadas.',
          ),
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
        final success = await _storage.deleteMateria(id);
        if (success) {
          _cargarMaterias();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Materia eliminada correctamente'))
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('No se pudo eliminar la materia'))
          );
        }
      }
    } catch (e) {
      debugPrint('❌ Error al eliminar materia: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e'))
      );
    }
  }

  void _mostrarDiagnostico() async {
    debugPrint('🔍 Ejecutando diagnóstico de almacenamiento');
    final diagnostico = await _storage.diagnosticoAlmacenamiento();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Diagnóstico de Almacenamiento'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Tipo: ${diagnostico["tipo_almacenamiento"]}'),
              Text('Inicializado: ${diagnostico["inicializado"]}'),
              Text('Directorio: ${diagnostico["directorio"]}'),
              Divider(),
              Text('Materias almacenadas: ${diagnostico["materias_almacenadas"]}'),
              Text('Actividades almacenadas: ${diagnostico["actividades_almacenadas"]}'),
              Text('Duración: ${diagnostico["duracion"]}'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cerrar'),
          ),
        ],
      ),
    );
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
            Text('Ha ocurrido un error al cargar las materias'),
            SizedBox(height: 8),
            Text(
              _errorMessage,
              style: TextStyle(fontSize: 12, color: Colors.red),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _cargarMaterias,
              child: Text('Reintentar'),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      body: Column(
        children: [
          // Cabecera informativa
          Container(
            padding: EdgeInsets.all(8),
            color: Colors.blue.withOpacity(0.1),
            child: Row(
              children: [
                Icon(Icons.info_outline, size: 20),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Materias cargadas: ${_materias.length}',
                    style: TextStyle(fontSize: 14),
                  ),
                ),
                TextButton(
                  onPressed: _cargarMaterias,
                  child: Text('Actualizar'),
                ),
                IconButton(
                  icon: Icon(Icons.bug_report, size: 20),
                  onPressed: _mostrarDiagnostico,
                  tooltip: 'Diagnóstico',
                ),
              ],
            ),
          ),

          // Lista de materias
          Expanded(
            child: _materias.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.school_outlined,
                          size: 64,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'No hay materias agregadas',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Presiona el botón "+" para agregar una nueva materia.',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      ],
                    ),
                  )
                : GridView.builder(
                    padding: EdgeInsets.all(16),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 1.0,
                    ),
                    itemCount: _materias.length,
                    itemBuilder: (context, index) {
                      final materia = _materias[index];
                      final color = Color(int.parse('0xFF${materia.color}'));

                      return GestureDetector(
                        onTap: () {
                          // Mostrar detalles
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Materia: ${materia.nombre}'),
                            ),
                          );
                        },
                        child: Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              color: color.withOpacity(0.7),
                            ),
                            child: Stack(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        materia.nombre,
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        'Prof. ${materia.profesor}',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.white,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                                Positioned(
                                  top: 8,
                                  right: 8,
                                  child: IconButton(
                                    icon: Icon(
                                      Icons.delete,
                                      color: Colors.white,
                                    ),
                                    onPressed: () =>
                                        _eliminarMateria(materia.id),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _mostrarDialogoNuevaMateria,
        child: Icon(Icons.add),
        tooltip: 'Agregar nueva materia',
      ),
    );
  }
}
