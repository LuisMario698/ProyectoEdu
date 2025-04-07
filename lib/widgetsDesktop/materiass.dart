import 'package:flutter/material.dart';
import 'package:proyectoeducativo/widgetsDesktop/materia_model.dart';


class MateriasWidget extends StatefulWidget {
  const MateriasWidget({super.key});

  @override
  State<MateriasWidget> createState() => _MateriasWidgetState();
}

class _MateriasWidgetState extends State<MateriasWidget> {
  final List<Map<String, dynamic>> _materias = [
    {'nombre': 'Tópicos Avanzados de Programación', 'color': Colors.purple},
    {'nombre': 'Principios eléctricos', 'color': Colors.blue},
    {'nombre': 'Ecuaciones Diferenciales', 'color': Colors.green},
    {'nombre': 'Inglés', 'color': Colors.orange},
    {'nombre': 'Métodos Numéricos', 'color': Colors.red},
    {'nombre': 'Bases de Datos', 'color': Colors.teal},
  ];

  void _agregarOModificarMateria({int? index}) {
    final TextEditingController controlador = TextEditingController(
      text: index != null ? _materias[index]['nombre'] : '',
    );
    Color colorSeleccionado = index != null ? _materias[index]['color'] : Colors.purple;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(index != null ? 'Editar Materia' : 'Agregar Materia'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: controlador,
              decoration: const InputDecoration(labelText: 'Nombre de la materia'),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Text('Color: '),
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: Colors.primaries.map((color) {
                        return GestureDetector(
                          onTap: () => setState(() => colorSeleccionado = color),
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: color,
                              border: Border.all(
                                width: 2,
                                color: color == colorSeleccionado ? Colors.black : Colors.transparent,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                if (index != null) {
                  _materias[index]['nombre'] = controlador.text;
                  _materias[index]['color'] = colorSeleccionado;
                } else {
                  _materias.add({
                    'nombre': controlador.text,
                    'color': colorSeleccionado,
                  });
                }
              });
              Navigator.pop(context);
            },
            child: Text(index != null ? 'Guardar' : 'Agregar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _agregarOModificarMateria(),
        icon: const Icon(Icons.add),
        label: const Text('Agregar Materia'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: GridView.builder(
          itemCount: _materias.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
            childAspectRatio: 2.8,
          ),
          itemBuilder: (context, index) {
            final materia = _materias[index];
            return GestureDetector(
              onTap: () => _agregarOModificarMateria(index: index),
              child: Container(
                decoration: BoxDecoration(
                  color: materia['color'],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    materia['nombre'],
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
