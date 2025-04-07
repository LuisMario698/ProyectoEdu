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
  late TextEditingController _cuerpoController;
  final DatabaseHelper _dbHelper = DatabaseHelper();
  bool _isLoading = false;
  bool _isEdited = false;

  @override
  void initState() {
    super.initState();
    _tituloController = TextEditingController(text: widget.nota.title);
    _cuerpoController = TextEditingController(text: widget.nota.body);

    // Detectar cambios en los campos
    _tituloController.addListener(_verificarCambios);
    _cuerpoController.addListener(_verificarCambios);
  }

  @override
  void dispose() {
    _tituloController.dispose();
    _cuerpoController.dispose();
    super.dispose();
  }

  void _verificarCambios() {
    final tituloModificado = _tituloController.text != widget.nota.title;
    final cuerpoModificado = _cuerpoController.text != widget.nota.body;

    if ((tituloModificado || cuerpoModificado) && !_isEdited) {
      setState(() {
        _isEdited = true;
      });
    }
  }

  Future<void> _guardarNota() async {
    if (_tituloController.text.isEmpty || _cuerpoController.text.isEmpty) {
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
        body: _cuerpoController.text,
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
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _tituloController,
              decoration: const InputDecoration(labelText: 'Título'),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: TextField(
                controller: _cuerpoController,
                decoration: const InputDecoration(labelText: 'Cuerpo'),
                maxLines: null,
                expands: true,
                keyboardType: TextInputType.multiline,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
