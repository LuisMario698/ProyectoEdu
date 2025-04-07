import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math';

class GruposTrabajoWidget extends StatefulWidget {
  const GruposTrabajoWidget({super.key});

  @override
  State<GruposTrabajoWidget> createState() => _GruposTrabajoWidgetState();
}

class _GruposTrabajoWidgetState extends State<GruposTrabajoWidget>
    with TickerProviderStateMixin {
  final List<String> _miembros = [];
  final List<Map<String, String>> _notas = [];
  final List<String> _mensajes = [];
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;
  String _linkGrupo = '';
  final TextEditingController _notaController = TextEditingController();
  final TextEditingController _chatController = TextEditingController();
  final TextEditingController _miembroController = TextEditingController();

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
    if (nombre.isNotEmpty) {
      setState(() {
        _miembros.add(nombre);
        _miembroController.clear();
      });
    }
  }

  void _agregarNota() {
    if (_notaController.text.isNotEmpty) {
      setState(() {
        _notas.add({
          'texto': _notaController.text,
          'fecha': DateTime.now().toString().substring(0, 16),
        });
        _notaController.clear();
      });
    }
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
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Grupo de Trabajo',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Card(
            elevation: 3,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Enlace del grupo:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: Text(_linkGrupo),
                      ),
                      IconButton(
                        icon: const Icon(Icons.copy),
                        onPressed: _copiarLink,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Miembros',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _miembroController,
                  decoration: const InputDecoration(
                    hintText: 'Agregar miembro',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: () => _agregarMiembro(_miembroController.text),
                child: const Text('Agregar'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Expanded(
            flex: 2,
            child: _miembros.isEmpty
                ? const Center(child: Text('No hay miembros en el grupo'))
                : ListView.builder(
                    itemCount: _miembros.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: CircleAvatar(
                          child: Text(_miembros[index][0]),
                        ),
                        title: Text(_miembros[index]),
                      );
                    },
                  ),
          ),
          const Divider(),
          const Text(
            'Notas Compartidas',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _notaController,
                  decoration: const InputDecoration(
                    hintText: 'Agregar nota',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: _agregarNota,
                child: const Text('Guardar'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Expanded(
            flex: 2,
            child: _notas.isEmpty
                ? const Center(child: Text('No hay notas compartidas'))
                : ListView.builder(
                    itemCount: _notas.length,
                    itemBuilder: (context, index) {
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _notas[index]['texto']!,
                                style: const TextStyle(fontSize: 16),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Creada: ${_notas[index]['fecha']}',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
          const Divider(),
          const Text(
            'Chat del Grupo',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Expanded(
            flex: 3,
            child: _mensajes.isEmpty
                ? const Center(child: Text('No hay mensajes'))
                : ListView.builder(
                    itemCount: _mensajes.length,
                    itemBuilder: (context, index) {
                      return Align(
                        alignment: Alignment.centerRight,
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                            vertical: 4,
                            horizontal: 8,
                          ),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.blue[100],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(_mensajes[index]),
                        ),
                      );
                    },
                  ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _chatController,
                  decoration: const InputDecoration(
                    hintText: 'Escribe un mensaje',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.send),
                onPressed: _enviarMensaje,
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _notaController.dispose();
    _chatController.dispose();
    _miembroController.dispose();
    super.dispose();
  }
}