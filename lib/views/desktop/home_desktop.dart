import 'package:flutter/material.dart';
import 'package:proyectoeducativo/views/mobile/configuracion_page.dart';
import 'package:proyectoeducativo/widgetsDesktop/actividadess.dart';
import 'package:proyectoeducativo/widgetsDesktop/calendarioss.dart';
import 'package:proyectoeducativo/widgetsDesktop/materiass.dart';
import 'package:proyectoeducativo/widgetsDesktop/horario.dart';
import 'package:proyectoeducativo/widgetsDesktop/grupos_trabajo.dart';
import 'package:proyectoeducativo/conexion/db.dart'; // Importación de DatabaseHelper

class HomeDesktop extends StatefulWidget {
  const HomeDesktop({super.key});

  @override
  State<HomeDesktop> createState() => _HomeDesktopState();
}

class _HomeDesktopState extends State<HomeDesktop> {
  Widget _currentBody = const MainContent();

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

  void _showMainContent() {
    setState(() {
      _currentBody = const MainContent();
    });
  }

  void _showCalendario() {
    setState(() {
      _currentBody = const CalendarioWidget();
    });
  }

  void _showHorario() {
    setState(() {
      _currentBody = const HorarioWidget(); // Mantener HorarioWidget para escritorio
    });
  }

  void _showGruposTrabajo() {
    setState(() {
      _currentBody = const GruposTrabajoPage();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inicio'),
      ),
      drawer: SizedBox(
        width: MediaQuery.of(context).size.width * 0.25,
        child: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              const DrawerHeader(
                decoration: BoxDecoration(color: Colors.blue),
                child: Text(
                  'Menú',
                  style: TextStyle(color: Colors.white, fontSize: 50),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.auto_stories_sharp),
                title: const Text('Materias'),
                onTap: () {
                  _showMaterias();
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: const Icon(Icons.home),
                title: const Text('Inicio'),
                onTap: () {
                  _showMainContent();
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: const Icon(Icons.assignment),
                title: const Text('Actividades'),
                onTap: () {
                  _showActividades();
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: const Icon(Icons.calendar_today),
                title: const Text('Horarios'),
                onTap: () {
                  _showHorario();
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: const Icon(Icons.calendar_month),
                title: const Text('Calendario'),
                onTap: () {
                  _showCalendario();
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: const Icon(Icons.group),
                title: const Text('Grupos de trabajo'),
                onTap: () {
                  _showGruposTrabajo();
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: const Icon(Icons.settings),
                title: const Text('Configuración'),
                onTap: () {
                  Navigator.of(context).pop(); // Cierra el Drawer
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ConfiguracionPage()),
                  );
                },
              ),
              
            ],
          ),
        ),
      ),
      body: _currentBody,
    );
  }
}

class MainContent extends StatelessWidget {
  const MainContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Bienvenido a tu escritorio educativo',
        style: Theme.of(context).textTheme.headlineMedium,
      ),
    );
  }
}
