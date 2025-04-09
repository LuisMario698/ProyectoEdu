import 'package:flutter/material.dart';
import '../models/actividad_model.dart';
import '../conexion/db.dart';

class ActividadesDesktop extends StatelessWidget {
  final List<Actividad> actividades;

  const ActividadesDesktop({super.key, required this.actividades});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Actividades'),
      ),
      body: ListView.builder(
        itemCount: actividades.length,
        itemBuilder: (context, index) {
          final actividad = actividades[index];
          return ListTile(
            title: Text(actividad.nombre),
            onTap: () {
              // Navegar a la página de detalles de la actividad
            },
          );
        },
      ),
    );
  }
}