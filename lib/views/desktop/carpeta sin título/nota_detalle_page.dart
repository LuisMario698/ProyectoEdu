import 'package:flutter/material.dart';
import 'package:proyectoeducativo/conexion/db.dart';
import 'package:proyectoeducativo/models/grupotrabajo_model.dart';

class NotaDetallePage extends StatefulWidget {
  final GroupNote nota;

  const NotaDetallePage({Key? key, required this.nota}) : super(key: key);

  @override
  _NotaDetallePageState createState() => _NotaDetallePageState();
}

class _NotaDetallePageState extends State<NotaDetallePage> {
  late TextEditingController _tituloController;
  late TextEditingController _contenidoController;
  final DatabaseHelper _dbHelper = DatabaseHelper();
  bool _isLoading = false;
  bool _isEdited = false;

  @override
  void initState() {
    super.initState();
    _tituloController = TextEditingController(text: widget.nota.title);
    _contenidoController = TextEditingController(text: widget.nota.body);

    // Detectar cambios en los campos
    _tituloController.addListener(_verificarCambios);
    _contenidoController.addListener(_verificarCambios);
  }

  @override
  void dispose() {
    _tituloController.dispose();
    _contenidoController.dispose();
    super.dispose();
  }

  void _verificarCambios() {
    final tituloModificado = _tituloController.text != widget.nota.title;
    final contenidoModificado = _contenidoController.text != widget.nota.body;

    if ((tituloModificado || contenidoModificado) && !_isEdited) {
      setState(() {
        _isEdited = true;
      });
    }
  }

  Future<void> _guardarNota() async {
    if (_tituloController.text.isEmpty || _contenidoController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('El título y el cuerpo no pueden estar vacíos')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final notaActualizada = GroupNote(
        id: widget.nota.id,
        groupId: widget.nota.groupId,
        title: _tituloController.text,
        body: _contenidoController.text,
      );

      await _dbHelper.updateGroupNote(notaActualizada);

      if (mounted) {
        Navigator.pop(context, notaActualizada);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al guardar la nota: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Nota'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _isEdited ? _guardarNota : null,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0), // Aumenta el padding
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch, // Estira los elementos
          children: [
            // TextField para el título
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: TextField(
                  controller: _tituloController,
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold), // Aumenta el tamaño de la fuente
                  decoration: const InputDecoration(
                    labelText: 'Título',
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20), // Aumenta el espaciado
            // TextField para el cuerpo
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: TextField(
                    controller: _contenidoController,
                    maxLines: null,
                    expands: true,
                    keyboardType: TextInputType.multiline,
                    style: const TextStyle(fontSize: 18), // Aumenta el tamaño de la fuente
                    decoration: const InputDecoration(
                      labelText: 'Cuerpo',
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
