import 'package:flutter/material.dart';
import 'package:proyectoeducativo/widgetsDesktop/materia_model.dart';


class ActividadesWidget extends StatefulWidget {
  const ActividadesWidget({super.key});

  @override
  State<ActividadesWidget> createState() => _ActividadesWidgetState();
}

class _ActividadesWidgetState extends State<ActividadesWidget> {
  final List<Map<String, dynamic>> _actividades = [
    {
      'materia': 'Tópicos Avanzados de Programación',
      'titulo': 'Proyecto POO',
      'maestro': 'José María Gerónimo',
      'color': Colors.blue,
    },
    {
      'materia': 'Métodos Numéricos',
      'titulo': 'Tarea Interpolación',
      'maestro': 'Anaís Burke',
      'color': Colors.green, 
    },
  ];

  final List<Color> _coloresDisponibles = [
    Colors.blue,
    Colors.green,
    Colors.red,
    Colors.purple,
    Colors.orange,
    Colors.teal,
    Colors.brown,
  ];

  void _agregarOEditarActividad({int? index}) {
    final tituloCtrl = TextEditingController(text: index != null ? _actividades[index]['titulo'] : '');
    final materiaCtrl = TextEditingController(text: index != null ? _actividades[index]['materia'] : '');
    final maestroCtrl = TextEditingController(text: index != null ? _actividades[index]['maestro'] : '');
    Color colorSel = index != null ? _actividades[index]['color'] : _coloresDisponibles.first;


    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(index != null ? 'Editar Actividad' : 'Nueva Actividad'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: tituloCtrl,
                decoration: const InputDecoration(labelText: 'Título de la actividad'),
              ),
              TextField(
                controller: materiaCtrl,
                decoration: const InputDecoration(labelText: 'Materia'),
              ),
              TextField(
                controller: maestroCtrl,
                decoration: const InputDecoration(labelText: 'Nombre del maestro'),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                children: _coloresDisponibles.map((c) {
                  return GestureDetector(
                    onTap: () => setState(() => colorSel = c),
                    child: Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: c,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: c == colorSel ? Colors.black : Colors.transparent,
                          width: 2,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
          ElevatedButton(
            onPressed: () {
              setState(() {
                if (index != null) {
                  _actividades[index] = {
                    'materia': materiaCtrl.text,
                    'titulo': tituloCtrl.text,
                    'maestro': maestroCtrl.text,
                    'color': colorSel,
                  };
                } else {
                  _actividades.add({
                    'materia': materiaCtrl.text,
                    'titulo': tituloCtrl.text,
                    'maestro': maestroCtrl.text,
                    'color': colorSel,
                  });
                }
              });
              Navigator.pop(context);
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _agregarOEditarActividad(),
        icon: const Icon(Icons.add),
        label: const Text('Nueva Actividad'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: ListView.builder(
          itemCount: _actividades.length,
          itemBuilder: (context, index) {
            final act = _actividades[index];
            return GestureDetector(
              onTap: () => _agregarOEditarActividad(index: index),
              child: Card(
                color: act['color'],
                elevation: 4,
                margin: const EdgeInsets.symmetric(vertical: 10),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: ListTile(
                  title: Text(
                    act['titulo'],
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  subtitle: Text(
                    '${act['materia']}  •  ${act['maestro']}',
                    style: const TextStyle(color: Colors.white70),
                  ),
                  trailing: const Icon(Icons.edit, color: Colors.white),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
