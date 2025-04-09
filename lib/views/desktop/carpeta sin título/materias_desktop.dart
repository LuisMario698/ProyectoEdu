import 'package:flutter/material.dart';
import '../../models/materia_model.dart';
import '../../conexion/db.dart';

class MateriasDesktop extends StatefulWidget {
  final Materia? materiaSeleccionada;
  
  const MateriasDesktop({super.key, this.materiaSeleccionada});

  @override
  State<MateriasDesktop> createState() => _MateriasDesktopState();
}

class _MateriasDesktopState extends State<MateriasDesktop> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Materias'),
      ),
      body: Center(
        child: _isLoading
            ? const CircularProgressIndicator()
            : ListView.builder(
                itemCount: _materias.length,
                itemBuilder: (context, index) {
                  final materia = _materias[index];
                  return ListTile(
                    title: Text(materia.nombre),
                    onTap: () => _showFormDialog(materia: materia),
                  );
                },
              ),
      ),
    );
  }

  void _showFormDialog({Materia? materia}) {
    // Implementar el diálogo de formulario
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}