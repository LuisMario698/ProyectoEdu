import 'package:flutter/material.dart';

class ConfiguracionPage extends StatefulWidget {
  final Function(ThemeData) onThemeChanged;
  final Function(String) onNameChanged;
  final String currentName;

  const ConfiguracionPage({
    super.key,
    required this.onThemeChanged,
    required this.onNameChanged,
    required this.currentName,
  });

  @override
  State<ConfiguracionPage> createState() => _ConfiguracionPageState();
}

class _ConfiguracionPageState extends State<ConfiguracionPage> {
  late TextEditingController _nameController;
  int _selectedThemeIndex = 0;

  final List<Map<String, dynamic>> _themes = [
    {
      'name': 'Claro (Azul)',
      'theme': ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
      ),
    },
    {
      'name': 'Oscuro (Gris)',
      'theme': ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.grey,
        scaffoldBackgroundColor: Colors.black,
      ),
    },
    {
      'name': 'Verde Pastel',
      'theme': ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.green,
        scaffoldBackgroundColor: const Color(0xFFEFFFEF),
        appBarTheme: const AppBarTheme(backgroundColor: Color(0xFFB3E5B4)),
      ),
    },
    {
      'name': 'Morado y Rosa',
      'theme': ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.purple,
        scaffoldBackgroundColor: const Color(0xFFFFF0FF),
        appBarTheme: const AppBarTheme(backgroundColor: Color(0xFFE1BEE7)),
      ),
    },
  ];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.currentName);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _guardarCambios() {
    widget.onNameChanged(_nameController.text);
    widget.onThemeChanged(_themes[_selectedThemeIndex]['theme']);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Configuración actualizada')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Configuración')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Cambiar nombre de usuario', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Escribe tu nombre...',
              ),
            ),
            const SizedBox(height: 24),
            const Text('Elegir tema de la app', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: List.generate(_themes.length, (index) {
                final isSelected = index == _selectedThemeIndex;
                return GestureDetector(
                  onTap: () => setState(() => _selectedThemeIndex = index),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.blueAccent.withOpacity(0.1) : Colors.grey[200],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected ? Colors.blue : Colors.transparent,
                        width: 2,
                      ),
                    ),
                    child: Text(_themes[index]['name']),
                  ),
                );
              }),
            ),
            const SizedBox(height: 40),
            Center(
              child: ElevatedButton.icon(
                onPressed: _guardarCambios,
                icon: const Icon(Icons.save),
                label: const Text('Guardar cambios'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
