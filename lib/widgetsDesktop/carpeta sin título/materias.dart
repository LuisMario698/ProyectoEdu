import 'package:flutter/material.dart';
import '../models/materia_model.dart';
import '../conexion/db.dart';

class MateriasDesktop extends StatefulWidget {
  const MateriasDesktop({super.key});

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
    _cargarDatos();
  }

  Future<void> _cargarDatos() async {
    setState(() {
      _isLoading = true;
    });

    try {
      _materias = await _dbHelper.getMaterias();
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

    return Scaffold(
      appBar: AppBar(
        title: const Text('Materias'),
      ),
      body: ListView.builder(
        itemCount: _materias.length,
        itemBuilder: (context, index) {
          final materia = _materias[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: ListTile(
              title: Text(materia.nombre),
              onTap: () {
                // Lógica para mostrar detalles de la materia
              },
            ),
          );
        },
      ),
    );
  }
}