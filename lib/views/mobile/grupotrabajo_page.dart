import 'package:flutter/material.dart';
import 'package:proyectoeducativo/conexion/db.dart';
import 'package:proyectoeducativo/models/grupotrabajo_model.dart';
import 'package:intl/intl.dart';
import 'package:proyectoeducativo/views/mobile/nota_detalle_page.dart';

class GrupoTrabajoPage extends StatefulWidget {
  const GrupoTrabajoPage({super.key});

  @override
  State<GrupoTrabajoPage> createState() => _GrupoTrabajoPageState();
}

class _GrupoTrabajoPageState extends State<GrupoTrabajoPage> {
  final TextEditingController _memberCtrl = TextEditingController();
  final TextEditingController _noteTitleCtrl = TextEditingController();
  final TextEditingController _noteBodyCtrl = TextEditingController();
  final TextEditingController _msgCtrl = TextEditingController();
  final DatabaseHelper _dbHelper = DatabaseHelper();

  GroupWork? _grupo;
  List<GroupMember> _miembros = [];
  List<GroupNote> _notas = [];
  List<GroupMessage> _mensajes = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _cargarGrupo();
  }

  Future<void> _cargarGrupo() async {
    setState(() => _isLoading = true);
    try {
      final grupos = await _dbHelper.getGroupWorks();
      if (grupos.isEmpty) {
        await _crearGrupoPorDefecto();
      } else {
        _grupo = grupos.first;
      }
      await _cargarDatosGrupo();
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error al cargar grupo: $e')));
    }
  }

  Future<void> _crearGrupoPorDefecto() async {
    final nuevoGrupo = GroupWork(
      name: 'Grupo de Trabajo',
      invitationLink:
          'https://grupotrabajo.app/invitar/${DateTime.now().millisecondsSinceEpoch}',
    );
    final id = await _dbHelper.insertGroupWork(nuevoGrupo);
    setState(() {
      _grupo = GroupWork(
        id: id,
        name: nuevoGrupo.name,
        invitationLink: nuevoGrupo.invitationLink,
      );
    });
  }

  Future<void> _cargarDatosGrupo() async {
    if (_grupo == null) return;

    try {
      final miembros = await _dbHelper.getGroupMembers(_grupo!.id!);
      final notas = await _dbHelper.getGroupNotes(_grupo!.id!);
      final mensajes = await _dbHelper.getGroupMessages(_grupo!.id!);

      setState(() {
        _miembros = miembros;
        _notas = notas;
        _mensajes = mensajes;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cargar datos del grupo: $e')),
      );
    }
  }

  Future<void> _agregarMiembro() async {
    if (_memberCtrl.text.isEmpty || _grupo == null) return;

    await _dbHelper.insertGroupMember(
      GroupMember(groupId: _grupo!.id!, memberName: _memberCtrl.text),
    );
    _memberCtrl.clear();
    _cargarDatosGrupo();
  }

  Future<void> _eliminarMiembro(int memberId) async {
    try {
      await _dbHelper.deleteGroupMember(memberId);
      _cargarDatosGrupo();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al eliminar el miembro: $e')),
      );
    }
  }

  Future<void> _agregarNota() async {
    if (_noteTitleCtrl.text.isEmpty ||
        _noteBodyCtrl.text.isEmpty ||
        _grupo == null)
      return;

    await _dbHelper.insertGroupNote(
      GroupNote(
        groupId: _grupo!.id!,
        title: _noteTitleCtrl.text,
        body: _noteBodyCtrl.text,
      ),
    );
    _noteTitleCtrl.clear();
    _noteBodyCtrl.clear();
    _cargarDatosGrupo();
  }

  Future<void> _eliminarNota(int noteId) async {
    try {
      await _dbHelper.deleteGroupNote(noteId);
      _cargarDatosGrupo();
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error al eliminar la nota: $e')));
    }
  }

  Future<void> _editarNota(GroupNote nota) async {
    final notaActualizada =
        await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => NotaDetallePage(nota: nota),
              ),
            )
            as GroupNote?;

    if (notaActualizada != null) {
      setState(() {
        int index = _notas.indexWhere(
          (element) => element.id == notaActualizada.id,
        );
        if (index != -1) {
          _notas[index] = notaActualizada;
        }
      });
      _cargarDatosGrupo();
    }
  }

  Future<void> _agregarMensaje() async {
    if (_msgCtrl.text.isEmpty || _grupo == null) return;

    final now = DateTime.now().millisecondsSinceEpoch;
    await _dbHelper.insertGroupMessage(
      GroupMessage(
        groupId: _grupo!.id!,
        message: _msgCtrl.text,
        timestamp: now,
      ),
    );
    _msgCtrl.clear();
    _cargarDatosGrupo();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Grupo de Trabajo')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(_grupo!.name)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Enlace de invitación:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(_grupo!.invitationLink),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Miembros',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    if (_miembros.isEmpty)
                      const Text('No hay miembros en este grupo.')
                    else
                      ..._miembros.map(
                        (m) => ListTile(
                          title: Text(m.memberName),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _eliminarMiembro(m.id!),
                          ),
                        ),
                      ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _memberCtrl,
                            decoration: const InputDecoration(
                              labelText: 'Nombre del miembro',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          icon: const Icon(Icons.person_add),
                          onPressed: _agregarMiembro,
                          tooltip: 'Agregar miembro',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Notas compartidas',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    if (_notas.isEmpty)
                      const Text('No hay notas compartidas.')
                    else
                      ..._notas.map(
                        (n) => ListTile(
                          title: Text(n.title),
                          subtitle: Text(
                            n.body,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _eliminarNota(n.id!),
                          ),
                          onTap: () => _editarNota(n),
                        ),
                      ),
                    const SizedBox(height: 12),
                    ExpansionTile(
                      title: const Text('Agregar nota'),
                      children: [
                        TextField(
                          controller: _noteTitleCtrl,
                          decoration: const InputDecoration(
                            labelText: 'Título',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextField(
                          controller: _noteBodyCtrl,
                          maxLines: 3,
                          decoration: const InputDecoration(
                            labelText: 'Contenido',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 12),
                        ElevatedButton.icon(
                          onPressed: _agregarNota,
                          icon: const Icon(Icons.save),
                          label: const Text('Guardar nota'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Chat del grupo',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      height: 200,
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.all(12),
                      child:
                          _mensajes.isEmpty
                              ? const Center(child: Text('No hay mensajes.'))
                              : ListView.builder(
                                itemCount: _mensajes.length,
                                itemBuilder: (context, index) {
                                  final msg = _mensajes[index];
                                  final time = DateFormat('HH:mm').format(
                                    DateTime.fromMillisecondsSinceEpoch(
                                      msg.timestamp,
                                    ),
                                  );
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 4,
                                    ),
                                    child: Text('[$time] ${msg.message}'),
                                  );
                                },
                              ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _msgCtrl,
                            decoration: const InputDecoration(
                              labelText: 'Mensaje',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          icon: const Icon(Icons.send),
                          onPressed: _agregarMensaje,
                          color: Colors.blue,
                        ),
                      ],
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
}
