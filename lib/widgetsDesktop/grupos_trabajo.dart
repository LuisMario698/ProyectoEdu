import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math';

class GruposTrabajoPage extends StatefulWidget {
  const GruposTrabajoPage({super.key});

  @override
  State<GruposTrabajoPage> createState() => _GruposTrabajoPageState();
}

class _GruposTrabajoPageState extends State<GruposTrabajoPage>
    with TickerProviderStateMixin {
  final List<String> _miembros = [];
  final List<Map<String, String>> _notas = [];
  final List<String> _mensajes = [];
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;
  String _linkGrupo = '';
  final TextEditingController _notaController = TextEditingController();
  final TextEditingController _chatController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _generarLinkGrupo();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _scaleAnimation = CurvedAnimation(parent: _controller, curve: Curves.elasticOut);
  }

  void _generarLinkGrupo() {
    final random = Random();
    final id = List.generate(6, (_) => random.nextInt(9)).join();
    _linkGrupo = 'grupo://$id';
  }

  void _copiarLink() {
    Clipboard.setData(ClipboardData(text: _linkGrupo));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('¡Link copiado al portapapeles!')),
    );
  }

  void _agregarMiembro(String nombre) {
    setState(() {
      _miembros.add(nombre);
    });
  }

  void _agregarNota() {
    if (_notaController.text.isNotEmpty) {
      setState(() {
        _notas.add({
          'titulo': _notaController.text,
          'descripcion': '',
        });
        _notaController.clear();
        _controller.forward(from: 0);
      });
    }
  }

  void _editarNota(int index) {
    final tituloCtrl = TextEditingController(text: _notas[index]['titulo']);
    final descripcionCtrl = TextEditingController(text: _notas[index]['descripcion']);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Editar nota'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: tituloCtrl,
              decoration: const InputDecoration(labelText: 'Título'),
            ),
            TextField(
              controller: descripcionCtrl,
              decoration: const InputDecoration(labelText: 'Descripción'),
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
                _notas[index] = {
                  'titulo': tituloCtrl.text,
                  'descripcion': descripcionCtrl.text,
                };
              });
              Navigator.pop(context);
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }

  void _verNota(int index) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 100, vertical: 80),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _notas[index]['titulo'] ?? '',
                style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 30),
              Text(
                _notas[index]['descripcion'] ?? '',
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 30),
              Align(
                alignment: Alignment.bottomRight,
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cerrar'),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _eliminarNota(int index) {
    setState(() {
      _notas.removeAt(index);
    });
  }

  void _enviarMensaje() {
    if (_chatController.text.isNotEmpty) {
      setState(() {
        _mensajes.add(_chatController.text);
        _chatController.clear();
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _notaController.dispose();
    _chatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Grupos de Trabajo', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          Row(
            children: [
              const Icon(Icons.link, color: Colors.blue),
              const SizedBox(width: 8),
              Text(_linkGrupo, style: const TextStyle(fontSize: 16, color: Colors.blue)),
              const SizedBox(width: 10),
              ElevatedButton.icon(
                onPressed: _copiarLink,
                icon: const Icon(Icons.copy),
                label: const Text('Copiar'),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Text('Miembros del Grupo:', style: TextStyle(fontSize: 18)),
          const SizedBox(height: 10),
          Wrap(
            spacing: 10,
            children: _miembros.map((nombre) => Chip(label: Text(nombre))).toList(),
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text('Agregar miembro'),
                  content: TextField(
                    onSubmitted: (value) {
                      if (value.isNotEmpty) {
                        _agregarMiembro(value);
                        Navigator.pop(context);
                      }
                    },
                    decoration: const InputDecoration(hintText: 'Nombre del compañero'),
                  ),
                ),
              );
            },
            icon: const Icon(Icons.person_add),
            label: const Text('Agregar Compañero'),
          ),
          const SizedBox(height: 30),
          const Text('Notas del grupo:', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _notaController,
                  decoration: const InputDecoration(hintText: 'Escribe una nota en equipo...'),
                ),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: _agregarNota,
                child: const Text('Agregar'),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              itemCount: _notas.length,
              itemBuilder: (context, index) {
                return Dismissible(
                  key: Key(_notas[index]['titulo']!),
                  direction: DismissDirection.endToStart,
                  onDismissed: (_) => _eliminarNota(index),
                  background: Container(
                    alignment: Alignment.centerRight,
                    color: Colors.red,
                    padding: const EdgeInsets.only(right: 20),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  child: ScaleTransition(
                    scale: _scaleAnimation,
                    child: Card(
                      elevation: 3,
                      color: Colors.grey[100],
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: ListTile(
                        onTap: () => _verNota(index),
                        leading: const Icon(Icons.note, color: Colors.indigo),
                        title: Text(_notas[index]['titulo'] ?? ''),
                        subtitle: Text(_notas[index]['descripcion'] ?? ''),
                        trailing: IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () => _editarNota(index),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 30),
          const Text('Chat del grupo:', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: _mensajes.length,
              itemBuilder: (context, index) => ListTile(
                leading: const Icon(Icons.chat_bubble_outline, color: Colors.teal),
                title: Text(_mensajes[index]),
              ),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _chatController,
                  decoration: const InputDecoration(hintText: 'Escribe un mensaje...'),
                  onSubmitted: (_) => _enviarMensaje(),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.send, color: Colors.teal),
                onPressed: _enviarMensaje,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
