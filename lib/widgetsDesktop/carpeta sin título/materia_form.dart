import 'package:flutter/material.dart';
import '../models/materia_model.dart';
import '../conexion/db.dart';

class MateriaFormDesktop extends StatefulWidget {
  final Materia? materia; // Null para crear nueva, objeto para editar

  const MateriaFormDesktop({super.key, this.materia});

  @override
  State<MateriaFormDesktop> createState() => _MateriaFormDesktopState();
}

class _MateriaFormDesktopState extends State<MateriaFormDesktop> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final DatabaseHelper _dbHelper = DatabaseHelper();
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
    super.dispose();
  }

  Future<void> _cargarDatos() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Cargar datos de la materia si estamos editando
      if (_isEditing) {
        _nombreController.text = widget.materia!.nombre;
      }
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
        title: Text(_isEditing ? 'Editar Materia' : 'Nueva Materia'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nombreController,
                decoration: const InputDecoration(labelText: 'Nombre de la materia'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa un nombre';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    // Lógica para guardar o actualizar la materia
                  }
                },
                child: Text(_isEditing ? 'Actualizar' : 'Guardar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}