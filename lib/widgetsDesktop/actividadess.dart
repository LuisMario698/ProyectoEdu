import 'package:flutter/material.dart';
import 'package:proyectoeducativo/widgetsDesktop/materia_model.dart';
import 'package:proyectoeducativo/widgetsDesktop/actividad_modelo.dart';

class ActividadesWidget extends StatefulWidget {
  const ActividadesWidget({super.key});

  @override
  State<ActividadesWidget> createState() => _ActividadesWidgetState();
}

class _ActividadesWidgetState extends State<ActividadesWidget> {
  void _agregarOEditar({Actividad? actividadExistente}) {
    final tituloCtrl = TextEditingController(text: actividadExistente?.titulo ?? '');
    final descripcionCtrl = TextEditingController(text: actividadExistente?.descripcion ?? '');
    String materiaSel = actividadExistente?.materia ?? listaMaterias.first.nombre;
    final maestroCtrl = TextEditingController(text: actividadExistente?.maestro ?? '');
    DateTime fechaSel = actividadExistente?.fecha ?? DateTime.now();

    showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (context, setModalState) => AlertDialog(
          title: Text(actividadExistente != null ? 'Editar actividad' : 'Nueva actividad'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: tituloCtrl,
                  decoration: const InputDecoration(labelText: 'Título'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: descripcionCtrl,
                  maxLines: 2,
                  decoration: const InputDecoration(labelText: 'Descripción'),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: materiaSel,
                  items: listaMaterias
                      .map((m) => DropdownMenuItem(value: m.nombre, child: Text(m.nombre)))
                      .toList(),
                  onChanged: (v) => setModalState(() => materiaSel = v!),
                  decoration: const InputDecoration(labelText: 'Materia'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: maestroCtrl,
                  decoration: const InputDecoration(labelText: 'Maestro'),
                ),
                const SizedBox(height: 12),
                ListTile(
                  title: const Text('Fecha de entrega'),
                  subtitle: Text('${fechaSel.toLocal()}'.split(' ')[0]),
                  trailing: const Icon(Icons.calendar_today),
                  onTap: () async {
                    final DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: fechaSel,
                      firstDate: DateTime.now().subtract(const Duration(days: 365)),
                      lastDate: DateTime.now().add(const Duration(days: 730)),
                    );
                    if (picked != null) {
                      setModalState(() => fechaSel = picked);
                    }
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
            ElevatedButton(
              onPressed: () {
                final nueva = Actividad(
                  titulo: tituloCtrl.text,
                  descripcion: descripcionCtrl.text,
                  materia: materiaSel,
                  maestro: maestroCtrl.text,
                  fecha: fechaSel,
                  entregada: false,
                );

                setState(() {
                  if (actividadExistente != null) {
                    final i = listaActividades.indexOf(actividadExistente);
                    listaActividades[i] = nueva;
                  } else {
                    listaActividades.add(nueva);
                  }
                });
                Navigator.pop(context);
              },
              child: const Text('Guardar'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Actividades')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _agregarOEditar(),
        icon: const Icon(Icons.add),
        label: const Text('Nueva actividad'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: ListView.builder(
          itemCount: listaActividades.length,
          itemBuilder: (context, index) {
            final act = listaActividades[index];
            final color = colorDeMateria(act.materia);
            return GestureDetector(
              onTap: () => _agregarOEditar(actividadExistente: act),
              child: Card(
                color: color,
                elevation: 4,
                margin: const EdgeInsets.symmetric(vertical: 10),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: ListTile(
                  title: Text(
                    act.titulo,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  subtitle: Text(
                    '${act.materia}  •  ${act.maestro}  •  ${act.fecha.toLocal().toString().split(" ")[0]}',
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
 