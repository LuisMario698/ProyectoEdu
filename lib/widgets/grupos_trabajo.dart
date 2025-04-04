import 'package:flutter/material.dart';

class GruposTrabajoWidget extends StatefulWidget {
  const GruposTrabajoWidget({super.key});

  @override
  _GruposTrabajoWidgetState createState() => _GruposTrabajoWidgetState();
}

class _GruposTrabajoWidgetState extends State<GruposTrabajoWidget> {
  final List<Map<String, dynamic>> grupos = [
    {
      "materia": "Matemáticas",
      "descripcion": "Grupo para resolver problemas de cálculo.",
      "notas": ["Nota 1: Resolver ecuaciones", "Nota 2: Integrales"],
      "imagenes": []
    },
    {
      "materia": "Historia",
      "descripcion": "Grupo para discutir eventos históricos.",
      "notas": ["Nota 1: Revolución Francesa", "Nota 2: Segunda Guerra Mundial"],
      "imagenes": []
    },
  ];

  void _crearGrupo() {
    showDialog(
      context: context,
      builder: (context) {
        final TextEditingController materiaController = TextEditingController();
        final TextEditingController descripcionController =
            TextEditingController();

        return AlertDialog(
          title: const Text("Crear Grupo de Trabajo"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: materiaController,
                decoration: const InputDecoration(labelText: "Materia"),
              ),
              TextField(
                controller: descripcionController,
                decoration: const InputDecoration(labelText: "Descripción"),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancelar"),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  grupos.add({
                    "materia": materiaController.text,
                    "descripcion": descripcionController.text,
                    "notas": [],
                    "imagenes": []
                  });
                });
                Navigator.pop(context);
              },
              child: const Text("Crear"),
            ),
          ],
        );
      },
    );
  }

  void _unirseAGrupo(Map<String, dynamic> grupo) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetalleGrupoWidget(grupo: grupo),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Grupos de Trabajo"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _crearGrupo,
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: grupos.length,
        itemBuilder: (context, index) {
          final grupo = grupos[index];
          return ListTile(
            leading: const Icon(Icons.group),
            title: Text(grupo["materia"]),
            subtitle: Text(grupo["descripcion"]),
            onTap: () => _unirseAGrupo(grupo),
          );
        },
      ),
    );
  }
}

class DetalleGrupoWidget extends StatelessWidget {
  final Map<String, dynamic> grupo;

  const DetalleGrupoWidget({super.key, required this.grupo});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Grupo: ${grupo["materia"]}"),
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              "Notas",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: grupo["notas"].length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: const Icon(Icons.note),
                  title: Text(grupo["notas"][index]),
                );
              },
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              "Imágenes",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: grupo["imagenes"].isEmpty
                ? const Center(child: Text("No hay imágenes"))
                : ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: grupo["imagenes"].length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.asset(grupo["imagenes"][index]),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
