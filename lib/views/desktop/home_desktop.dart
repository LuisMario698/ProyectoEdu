import 'package:flutter/material.dart';
import '../../widgetsDesktop/actividadess.dart';
import '../../widgetsDesktop/materiass.dart';
import '../../widgetsDesktop/calendarioss.dart';
import '../../widgetsDesktop/horario.dart';

class HomeDesktop extends StatefulWidget {
  const HomeDesktop({super.key});

  @override
  HomeDesktopState createState() => HomeDesktopState();
}

class HomeDesktopState extends State<HomeDesktop> {
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();
  Widget _currentBody = const MainContentDesktop();

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
      _currentBody = const HorarioWidget();
    });
  }

  void _showMainContent() {
    setState(() {
      _isSearching = false;
      _searchController.clear();
      _currentBody = const MainContentDesktop();
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

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
        title: const Text('Inicio', style: TextStyle(fontSize: 24)),
        actions: [
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching;
                if (!_isSearching) _searchController.clear();
              });
            },
          ),
        ],
      ),
      drawer: SizedBox(
        width: screenWidth * 0.25,
        child: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              const DrawerHeader(
                decoration: BoxDecoration(color: Colors.blue),
                child: Text(
                  'Menú de Navegación',
                  style: TextStyle(color: Colors.white, fontSize: 28),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.auto_stories_sharp),
                title: const Text('Materias', style: TextStyle(fontSize: 18)),
                onTap: () {
                  _showMaterias();
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: const Icon(Icons.home),
                title: const Text('Inicio', style: TextStyle(fontSize: 18)),
                onTap: () {
                  _showMainContent();
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: const Icon(Icons.task),
                title: const Text('Actividades', style: TextStyle(fontSize: 18)),
                onTap: () {
                  _showActividades();
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: const Icon(Icons.calendar_month),
                title: const Text('Calendario', style: TextStyle(fontSize: 18)),
                onTap: () {
                  _showCalendario();
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: const Icon(Icons.calendar_today),
                title: const Text('Horarios', style: TextStyle(fontSize: 18)),
                onTap: () {
                  _showHorario();
                  Navigator.of(context).pop();
                },
              ),
              const ListTile(
                leading: Icon(Icons.group),
                title: Text('Grupos de trabajo'),
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
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          if (_isSearching)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: SizedBox(
                  width: 600,
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
              ),
            ),
          Expanded(child: _currentBody),
        ],
      ),
    );
  }
}

class MainContentDesktop extends StatelessWidget {
  const MainContentDesktop({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 800,
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Actividades Pendientes',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 180,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: 10,
                  separatorBuilder: (_, __) => const SizedBox(width: 16),
                  itemBuilder: (context, index) {
                    return Container(
                      width: 160,
                      decoration: BoxDecoration(
                        color: Colors.blueAccent,
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: Center(
                        child: Text(
                          'Actividad ${index + 1}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 32),
              const Text(
                'Tareas Pendientes',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  itemCount: 20,
                  itemBuilder: (context, index) {
                    return Container(
                      height: 100,
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      decoration: BoxDecoration(
                        color: Colors.greenAccent,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Center(
                        child: Text(
                          'Elemento ${index + 1}',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
