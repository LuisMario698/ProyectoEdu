import 'package:flutter/material.dart';
import '../../models/actividad_model.dart';
import '../../conexion/db.dart';

class ActividadesDesktop extends StatefulWidget {
  const ActividadesDesktop({super.key});

  @override
  State<ActividadesDesktop> createState() => _ActividadesDesktopState();
}

class _ActividadesDesktopState extends State<ActividadesDesktop> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  List<Actividad> _actividadesPendientes = [];
  List<Actividad> _actividadesCompletadas = [];
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
      final actividades = await _dbHelper.getActividades();

      _actividadesPendientes = [];
      _actividadesCompletadas = [];

      for (var actividad in actividades) {
        if (actividad.completada) {
          _actividadesCompletadas.add(actividad);
        } else {
          _actividadesPendientes.add(actividad);
        }
      }

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _showErrorDialog('Error al cargar actividades: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Actividades'),
      ),
      body: Center(
        child: _isLoading
            ? const CircularProgressIndicator()
            : ListView.builder(
                itemCount: _actividadesPendientes.length,
                itemBuilder: (context, index) {
                  final actividad = _actividadesPendientes[index];
                  return ListTile(
                    title: Text(actividad.nombre),
                    onTap: () => _showFormDialog(actividad: actividad),
                  );
                },
              ),
      ),
    );
  }

  void _showFormDialog({Actividad? actividad}) {
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