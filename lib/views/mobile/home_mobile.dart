import 'package:flutter/material.dart';
import 'package:proyectoeducativo/views/mobile/horario_page.dart';
import 'package:proyectoeducativo/views/mobile/grupotrabajo_page.dart'; // Import correcto
import 'package:proyectoeducativo/widgetsDesktop/grupos_trabajo.dart';
import 'package:proyectoeducativo/widgetsMobile/actividades.dart';
import '../../widgetsMobile/materias.dart'; // Importa el widget de materias
import '../../widgetsMobile/main_content.dart'; // Importa el widget de contenido principal
import '../../widgetsMobile/horario.dart'; // Importa el widget de horario
import '../../widgetsMobile/calendario.dart'; // Importa el widget de calendario
import '../../widgetsMobile/grupos_trabajo.dart'; // Importa el widget de grupos de trabajo
import '../../conexion/db.dart'; // Importa el DatabaseHelper
import 'package:proyectoeducativo/views/mobile/configuracion_page.dart'; // Importa la página de configuración

class HomeMobile extends StatefulWidget {
  const HomeMobile({super.key});

  @override
  HomeMobileState createState() => HomeMobileState();
}

class HomeMobileState extends State<HomeMobile> {
  Widget _currentBody = const MainContent(); // Contenido dinámico del body

  void _showMaterias() {
    setState(() {
      _currentBody = const MateriasWidget(); // Cambia al widget de materias de widgetsMobile
    });
  }

  void _showActividades() {
    setState(() {
      _currentBody = const ActividadesWidget(); // Cambia al widget de actividades de widgetsMobile
    });
  }

  void _showHorario() {
    setState(() {
      _currentBody = const HorarioPage(); // Cambia al widget de horario de widgetsMobile
    });
  }

  void _showCalendario() {
    setState(() {
      _currentBody = const CalendarioWidget(); // Cambia al widget de calendario de widgetsMobile
    });
  }

  void _showGruposTrabajo() {
    setState(() {
      _currentBody = const GrupoTrabajoPage();
    });
  }

  void _showMainContent() {
    setState(() {
      _currentBody = const MainContent(); // Cambia al contenido principal
    });
  }
  
  @override
  void initState() {
    super.initState();
    // Inicializar con el contenido principal
    _currentBody = const MainContent();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder:
              (context) => IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () {
                  setState(() {
                  });
                  Scaffold.of(context).openDrawer();
                },
              ),
        ),
        title: const Text('Inicio'),
      ),
      drawer: SizedBox(
        width: MediaQuery.of(context).size.width * 0.6,
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
                leading: const Icon(Icons.home),
                title: const Text('Inicio'),
                onTap: () {
                  _showMainContent(); // Cambia al contenido principal
                  Navigator.of(context).pop(); // Cierra el Drawer
                },
              ),
              ListTile(
                leading: const Icon(Icons.auto_stories_sharp),
                title: const Text('Materias'),
                onTap: () {
                  _showMaterias(); // Cambia al widget de materias
                  Navigator.of(context).pop(); // Cierra el Drawer
                },
              ),
              
              ListTile(
                leading: const Icon(Icons.home),
                title: const Text('Actividades'),
                onTap: () {
                  _showActividades(); // Cambia al contenido principal
                  Navigator.of(context).pop(); // Cierra el Drawer
                },
              ),
              ListTile(
                leading: const Icon(Icons.calendar_today),
                title: const Text('Horarios'),
                onTap: () {
                  _showHorario(); // Cambia al widget de horario
                  Navigator.of(context).pop(); // Cierra el Drawer
                },
              ),
              ListTile(
                leading: const Icon(Icons.calendar_month),
                title: const Text('Calendario'),
                onTap: () {
                  _showCalendario(); // Cambia al widget de calendario
                  Navigator.of(context).pop(); // Cierra el Drawer
                },
              ),
              ListTile(
                leading: const Icon(Icons.group),
                title: const Text('Grupos de trabajo'),
                onTap: () {
                  _showGruposTrabajo(); // Cambia al widget de grupos de trabajo
                  Navigator.of(context).pop(); // Cierra el Drawer
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
          Expanded(child: _currentBody),
        ],
      ),
    );
  }
}

// Fin de la clase HomeMobile
