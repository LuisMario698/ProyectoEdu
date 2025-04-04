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

  @override
  void dispose() {
    _controller.dispose();
    _notaController.dispose();
    _chatController.dispose();
    super.dispose();
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Grupo de Trabajo'),
        actions: [
          IconButton(
            icon: const Icon(Icons.copy),
            onPressed: _copiarLink,
            tooltip: 'Copiar link del grupo',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Link del grupo
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: [
                    const Icon(Icons.link),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _linkGrupo,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.copy),
                      onPressed: _copiarLink,
                      tooltip: 'Copiar link',
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            
            // Pestañas para navegar entre secciones
            DefaultTabController(
              length: 3,
              child: Expanded(
                child: Column(
                  children: [
                    const TabBar(
                      labelColor: Colors.blue,
                      tabs: [
                        Tab(text: 'Miembros', icon: Icon(Icons.people)),
                        Tab(text: 'Notas', icon: Icon(Icons.note)),
                        Tab(text: 'Chat', icon: Icon(Icons.chat)),
                      ],
                    ),
                    Expanded(
                      child: TabBarView(
                        children: [
                          // Pestaña de Miembros
                          _buildMiembrosTab(),
                          
                          // Pestaña de Notas
                          _buildNotasTab(),
                          
                          // Pestaña de Chat
                          _buildChatTab(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMiembrosTab() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: ElevatedButton.icon(
            onPressed: () {
              final nombreCtrl = TextEditingController();
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text('Agregar miembro'),
                  content: TextField(
                    controller: nombreCtrl,
                    decoration: const InputDecoration(labelText: 'Nombre'),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancelar'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (nombreCtrl.text.isNotEmpty) {
                          _agregarMiembro(nombreCtrl.text);
                          Navigator.pop(context);
                        }
                      },
                      child: const Text('Agregar'),
                    ),
                  ],
                ),
              );
            },
            icon: const Icon(Icons.person_add),
            label: const Text('Agregar Miembro'),
          ),
        ),
        Expanded(
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
      ],
    );
  }

  Widget _buildNotasTab() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _notaController,
                  decoration: const InputDecoration(
                    hintText: 'Nueva nota...',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: _agregarNota,
              ),
            ],
          ),
        ),
        Expanded(
          child: _notas.isEmpty
              ? const Center(child: Text('No hay notas'))
              : ListView.builder(
                  itemCount: _notas.length,
                  itemBuilder: (context, index) {
                    return ScaleTransition(
                      scale: _scaleAnimation,
                      child: Card(
                        margin: const EdgeInsets.symmetric(vertical: 4.0),
                        child: ListTile(
                          title: Text(_notas[index]['titulo'] ?? ''),
                          subtitle: Text(_notas[index]['descripcion'] ?? ''),
                          trailing: IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () => _editarNota(index),
                          ),
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildChatTab() {
    return Column(
      children: [
        Expanded(
          child: _mensajes.isEmpty
              ? const Center(child: Text('No hay mensajes'))
              : ListView.builder(
                  itemCount: _mensajes.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const CircleAvatar(
                            child: Icon(Icons.person),
                          ),
                          const SizedBox(width: 8),
                          Flexible(
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.blue.shade100,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(_mensajes[index]),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _chatController,
                  decoration: const InputDecoration(
                    hintText: 'Escribe un mensaje...',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.send),
                onPressed: _enviarMensaje,
              ),
            ],
          ),
        ),
      ],
    );
  }
}