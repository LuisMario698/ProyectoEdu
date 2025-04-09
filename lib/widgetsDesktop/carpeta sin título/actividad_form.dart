import 'package:flutter/material.dart';

class ActividadFormDesktop extends StatelessWidget {
  const ActividadFormDesktop({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Formulario de Actividad para escritorio'),
      ),
      body: Center(
        child: const Text('Contenido del formulario de actividad para escritorio'),
      ),
    );
  }
}