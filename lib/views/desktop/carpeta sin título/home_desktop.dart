import 'package:flutter/material.dart';
import 'package:proyectoeducativo/views/desktop/horario_page.dart';
import 'package:proyectoeducativo/views/desktop/grupotrabajo_page.dart';
import 'package:proyectoeducativo/widgetsDesktop/actividades_desktop.dart';
import 'package:proyectoeducativo/widgetsDesktop/materiass.dart';
import 'package:proyectoeducativo/widgetsDesktop/actividadess.dart';
import 'package:proyectoeducativo/widgetsDesktop/main_content.dart';
import 'package:proyectoeducativo/widgetsDesktop/horario.dart';
import 'package:proyectoeducativo/widgetsDesktop/calendarioss.dart';
import 'package:proyectoeducativo/widgetsDesktop/grupos_trabajo.dart';
import '../../conexion/db.dart';
import 'package:proyectoeducativo/views/desktop/configuracion_page.dart';

class HomeDesktop extends StatefulWidget {
  const HomeDesktop({super.key});

  @override
  HomeDesktopState createState() => HomeDesktopState();
}

class HomeDesktopState extends State<HomeDesktop> {
  Widget _currentBody = const MainContentDesktop();

  void _showMaterias() {
    setState(() {
      _currentBody = const MateriasWidget();
    });
  }

  void _showActividades() {
    setState(() {
      _currentBody = const ActividadesWidget();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home Desktop')),
      body: _currentBody,
    );
  }
}
