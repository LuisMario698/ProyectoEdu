import 'package:flutter/material.dart';
import 'package:proyectoeducativo/widgetsDesktop/actividadess.dart';
import 'package:proyectoeducativo/widgetsDesktop/calendarioss.dart';
import 'package:proyectoeducativo/widgetsDesktop/materiass.dart';
import 'package:proyectoeducativo/widgetsDesktop/horario.dart';
import 'package:proyectoeducativo/widgetsDesktop/grupos_trabajo.dart';
import 'package:proyectoeducativo/widgetsDesktop/bienvenida_widget.dart';
import 'package:proyectoeducativo/widgetsDesktop/configuracion.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeDesktop extends StatefulWidget {
  const HomeDesktop({super.key});

  @override
  State<HomeDesktop> createState() => _HomeDesktopState();
}

class _HomeDesktopState extends State<HomeDesktop> {
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();
  late Widget _currentBody;
  ThemeData _currentTheme = ThemeData.light();
  String _nombreUsuario = "Estudiante";

  @override
  void initState() {
    super.initState();
    _cargarPreferencias();
    _currentBody = BienvenidaWidget(onEmpezar: _showMaterias);
  }

  Future<void> _cargarPreferencias() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _nombreUsuario = prefs.getString('nombreUsuario') ?? 'Estudiante';
      final temaIndex = prefs.getInt('temaIndex') ?? 0;
      _currentTheme = _temasDisponibles[temaIndex];
    });
  }

  Future<void> _guardarNombre(String nombre) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('nombreUsuario', nombre);
  }

  Future<void> _guardarTema(int index) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('temaIndex', index);
  }

  final List<ThemeData> _temasDisponibles = [
    ThemeData.light(),
    ThemeData.dark(),
    ThemeData(primarySwatch: Colors.green),
    ThemeData(primarySwatch: Colors.purple),
  ];

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
      _currentBody = BienvenidaWidget(onEmpezar: _showMaterias);
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

  void _showGruposTrabajo() {
    setState(() {
      _isSearching = false;
      _searchController.clear();
      _currentBody = const GruposTrabajoPage();
    });
  }

  void _showConfiguracion() {
    setState(() {
      _isSearching = false;
      _searchController.clear();
      _currentBody = ConfiguracionPage(
        currentName: _nombreUsuario,
        onNameChanged: (nuevoNombre) {
          setState(() => _nombreUsuario = nuevoNombre);
          _guardarNombre(nuevoNombre);
        },
        onThemeChanged: (nuevoTema) {
          final index = _temasDisponibles.indexOf(nuevoTema);
          if (index != -1) _guardarTema(index);
          setState(() => _currentTheme = nuevoTema);
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: _currentTheme,
      child: Scaffold(
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
          title: Text('Inicio - $_nombreUsuario'),
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
                ListTile(
                  leading: const Icon(Icons.settings),
                  title: const Text('Configuración'),
                  onTap: () {
                    _showConfiguracion();
                    Navigator.of(context).pop();
                  },
                ),
                const ListTile(
                  leading: Icon(Icons.chat),
                  title: Text('Chats'),
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
                    print('Buscando: \$value');
                  },
                ),
              ),
            Expanded(child: _currentBody),
          ],
        ),
      ),
    );
  }
}
