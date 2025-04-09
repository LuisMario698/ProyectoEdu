import 'package:flutter/material.dart';
import '../models/calendario_model.dart';
import '../conexion/db.dart';

class CalendarioDesktop extends StatefulWidget {
  const CalendarioDesktop({super.key});

  @override
  State<CalendarioDesktop> createState() => _CalendarioDesktopState();
}

class _CalendarioDesktopState extends State<CalendarioDesktop> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  List<Calendario> _calendarios = [];
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
      _calendarios = await _dbHelper.getCalendarios();
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
        title: const Text('Calendario'),
      ),
      body: ListView.builder(
        itemCount: _calendarios.length,
        itemBuilder: (context, index) {
          final calendario = _calendarios[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: ListTile(
              title: Text(calendario.nombre),
              subtitle: Text('Fecha: ${calendario.fecha.day}/${calendario.fecha.month}/${calendario.fecha.year}'),
              onTap: () {
                // Lógica para mostrar detalles del calendario
              },
            ),
          );
        },
      ),
    );
  }
}