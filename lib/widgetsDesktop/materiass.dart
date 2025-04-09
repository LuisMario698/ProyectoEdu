import 'package:flutter/material.dart';
import 'package:proyectoeducativo/widgetsDesktop/materia_model.dart';

final List<Color> coloresDisponibles = [
  Colors.redAccent,
  Colors.green,
  Colors.blue,
  Colors.orange,
  Colors.purple,
  Colors.teal,
  Colors.brown,
];

class MateriasWidget extends StatefulWidget {
  const MateriasWidget({super.key});

  @override
  State<MateriasWidget> createState() => _MateriasWidgetState();
}

class _MateriasWidgetState extends State<MateriasWidget> {
  void _agregarOModificarMateria({Materia? materiaExistente}) {
    final nombreCtrl = TextEditingController(text: materiaExistente?.nombre ?? '');
    Color colorSel = materiaExistente?.color ?? Colors.blue;

    showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (context, setModalState) => AlertDialog(
          title: Text(materiaExistente != null ? 'Editar Materia' : 'Agregar Materia'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nombreCtrl,
                decoration: const InputDecoration(labelText: 'Nombre de la materia'),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                children: coloresDisponibles.map((c) {
                  return GestureDetector(
                    onTap: () => setModalState(() => colorSel = c),
                    child: Container(
                      width: 30,
                      height: 30,
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
              )
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
            ElevatedButton(
              onPressed: () {
                if (nombreCtrl.text.isNotEmpty) {
                  setState(() {
                    if (materiaExistente != null) {
                      final i = listaMaterias.indexOf(materiaExistente);
                      listaMaterias[i] = Materia(nombre: nombreCtrl.text, color: colorSel);
                    } else {
                      listaMaterias.add(Materia(nombre: nombreCtrl.text, color: colorSel));
                    }
                  });
                  Navigator.pop(context);
                }
              },
              child: const Text('Guardar'),
            ),
          ],
        ),
      ),
    );
  }

  void _eliminarMateria(Materia materia) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Eliminar Materia'),
        content: Text('¿Deseas eliminar "${materia.nombre}"?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
          ElevatedButton(
            onPressed: () {
              setState(() => listaMaterias.remove(materia));
              Navigator.pop(context);
            },
            child: const Text('Eliminar'),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Materias'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _agregarOModificarMateria(),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: ListView.builder(
          itemCount: listaMaterias.length,
          itemBuilder: (context, index) {
            final materia = listaMaterias[index];
            return Card(
              color: materia.color,
              margin: const EdgeInsets.symmetric(vertical: 10),
              child: ListTile(
                title: Text(
                  materia.nombre,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.white),
                      onPressed: () => _agregarOModificarMateria(materiaExistente: materia),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.white),
                      onPressed: () => _eliminarMateria(materia),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
