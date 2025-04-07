import 'package:flutter/material.dart';
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
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();
  Widget _currentBody = const MainContent();

  void _showMaterias() {
    setState(() {
      _isSearching = false;
      _searchController.clear();
      _currentBody = const MateriasWidget();
    });
  }

  void _showActividades() {
    setState(() {
      _isSearching = false;
      _searchController.clear();
      _currentBody = const ActividadesWidget();
    });
  }

  void _showMainContent() {
    setState(() {
      _isSearching = false;
      _searchController.clear();
      _currentBody = const MainContent();
    });
  }

  void _showCalendario() {
    setState(() {
      _isSearching = false;
      _searchController.clear();
      _currentBody = const CalendarioWidget();
    });
  }

  void _showHorario() {
    setState(() {
      _isSearching = false;
      _searchController.clear();
      _currentBody = const HorarioWidget(); // Mantener HorarioWidget para escritorio
    });
  }

  void _showGruposTrabajo() {
    setState(() {
      _isSearching = false;
      _searchController.clear();
      _currentBody = const GruposTrabajoPage();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              setState(() {
                _isSearching = false;
                _searchController.clear();
              });
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
        title: const Text('Inicio'),
        actions: [
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching;
                if (!_isSearching) {
                  _searchController.clear();
                }
              });
            },
          ),
        ],
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
                  'Menú de Navegación',
                  style: TextStyle(color: Colors.white, fontSize: 24),
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
              const ListTile(
                leading: Icon(Icons.chat),
                title: Text('Chats'),
              ),
              const ListTile(
                leading: Icon(Icons.settings),
                title: Text('Configuración'),
              ),
              const ListTile(
                leading: Icon(Icons.info),
                title: Text('Acerca de'),
              ),
              ListTile(
                leading: const Icon(Icons.cleaning_services),
                title: const Text('Limpiar Base de Datos'),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Esta funcionalidad estará disponible próximamente'),
                    ),
                  );
                  // Cuando estés listo para implementar la funcionalidad de la base de datos:
                  // final db = DatabaseHelper();
                  // await db.limpiarBaseDeDatos();
                  // ScaffoldMessenger.of(context).showSnackBar(
                  //   const SnackBar(content: Text('Base de datos limpiada correctamente')),
                  // );
                },
              ),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          if (_isSearching)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  hintText: 'Buscar...',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.search),
                ),
                autofocus: true,
                onSubmitted: (value) {
                  print('Buscando: $value');
                },
              ),
            ),
          Expanded(child: _currentBody),
        ],
      ),
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
