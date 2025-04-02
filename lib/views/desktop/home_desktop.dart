import 'package:flutter/material.dart';

class HomeDesktop extends StatelessWidget {
  const HomeDesktop({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder:
              (context) => IconButton(
                icon: const Icon(Icons.menu), // Botón de navegación
                onPressed: () {
                  Scaffold.of(context).openDrawer(); // Abre el Drawer
                },
              ),
        ),
        title: const Text('Equipos - Vista de Escritorio'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: const [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text(
                'Menú de Navegación',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(leading: Icon(Icons.home), title: Text('Inicio')),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Configuración'),
            ),
            ListTile(leading: Icon(Icons.info), title: Text('Acerca de')),
          ],
        ),
      ),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Clases',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: ListView(
                      children: [
                        _buildClassItem('Fundamentos de Programación ISO-S1'),
                        _buildClassItem(
                          'Funciamientos de Investigación ISO-S1',
                        ),
                        _buildClassItem('Álgebra Lineal ISC2UM-24'),
                        _buildClassItem('Compatibilidad Financiera ISC2UM-24'),
                        _buildClassItem('Simulación ISIC4-U/2025'),
                        _buildClassItem(
                          'Tópicos avanzados de programación 2025-1',
                        ),
                        _buildClassItem('Procedimiento ISC 2023'),
                        _buildClassItem('Taller de Administración ISO-S1'),
                        _buildClassItem('Desarrollo Sustentable (Agc24-Ene23)'),
                        _buildClassItem('IISC-4-M 2025-1'),
                        _buildClassItem('XII Concurso de Programación ...'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const VerticalDivider(thickness: 2, width: 2),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Unirse a un equipo o crear uno',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: ListView(
                      children: [
                        _buildJoinableClassItem('Cálculo Diferencial ISC-S1'),
                        _buildJoinableClassItem(
                          'Estructura de Datos ISC2UM-24',
                        ),
                        _buildJoinableClassItem(
                          'Programación Orientada A Objetos (Agc)24 -',
                        ),
                        _buildJoinableClassItem(
                          'XII Concurso de Programación (Reto...)',
                        ),
                        _buildJoinableClassItem(
                          'Taller de Ética ISC-S1',
                          isBold: false,
                        ),
                        _buildJoinableClassItem(
                          'Probabilidad y Estadística ISC2UM-24',
                          isBold: true,
                        ),
                        _buildJoinableClassItem(
                          'Cultura Empresarial (Agc)24-Ene(25)',
                          isBold: false,
                        ),
                        _buildJoinableClassItem(
                          'Fundamentos de Base de Datos 2025-1',
                          isBold: true,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildClassItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          const Icon(Icons.circle, size: 8),
          const SizedBox(width: 12),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 18))),
        ],
      ),
    );
  }

  Widget _buildJoinableClassItem(String text, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 18,
          fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }
}
