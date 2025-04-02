import 'package:flutter/material.dart';
import 'package:proyectoeducativo/widgets/actividades.dart';
import '../../widgets/materias.dart'; // Importa el widget de materias

class HomeMobile extends StatefulWidget {
  const HomeMobile({super.key});

  @override
  HomeMobileState createState() => HomeMobileState();
}

class HomeMobileState extends State<HomeMobile> {
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();
  Widget _currentBody = const MainContent(); // Contenido dinámico del body

  void _showMaterias() {
    setState(() {
      _isSearching = false;
      _searchController.clear();
      _currentBody = const MateriasWidget(); // Cambia al widget de materias
    });
  }

  void _showActividades() {
    setState(() {
      _isSearching = false;
      _searchController.clear();
      _currentBody = ActividadesWidget(); // Cambia al widget de materias
    });
  }

  void _showMainContent() {
    setState(() {
      _isSearching = false;
      _searchController.clear();
      _currentBody = const MainContent(); // Cambia al contenido principal
    });
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
        width: MediaQuery.of(context).size.width * 0.6,
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
                  _showMaterias(); // Cambia al widget de materias
                  Navigator.of(context).pop(); // Cierra el Drawer
                },
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
                leading: const Icon(Icons.home),
                title: const Text('Actividades'),
                onTap: () {
                  _showActividades(); // Cambia al contenido principal
                  Navigator.of(context).pop(); // Cierra el Drawer
                },
              ),
              const ListTile(
                leading: Icon(Icons.calendar_today),
                title: Text('Horarios'),
              ),
              const ListTile(
                leading: Icon(Icons.calendar_month),
                title: Text('Calendario'),
              ),
              const ListTile(
                leading: Icon(Icons.group),
                title: Text('Grupos de trabajo'),
              ),
              const ListTile(leading: Icon(Icons.chat), title: Text('Chats')),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            'Actividades Pendientes',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          height: 150,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(10, (index) {
                return Container(
                  width: 120,
                  margin: const EdgeInsets.symmetric(horizontal: 8.0),
                  decoration: BoxDecoration(
                    color: Colors.blueAccent,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Center(
                    child: Text(
                      'Actividad ${index + 1}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            'Tareas Pendientes',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(
              right: 8,
              left: 8,
              top: 10,
              bottom: 30,
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(30)),
              child: ListView.builder(
                itemCount: 20,
                itemBuilder: (context, index) {
                  return Container(
                    height: 80,
                    margin: const EdgeInsets.symmetric(
                      horizontal: 8.0,
                      vertical: 4.0,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.greenAccent,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Center(
                      child: Text(
                        'Elemento ${index + 1}',
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}
