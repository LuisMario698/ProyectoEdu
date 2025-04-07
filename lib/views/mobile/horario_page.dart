import 'package:flutter/material.dart';
import 'package:proyectoeducativo/models/materia_model.dart';
import 'package:proyectoeducativo/models/horario_model.dart';
import 'package:proyectoeducativo/conexion/db.dart';

// Definición de la clase ClaseHorario para usarla en la interfaz
class ClaseHorario {
  final String id;
  final String materia;
  final int? materiaId;
  final TimeOfDay horaInicio;
  final TimeOfDay horaFin;
  final Color color;

  ClaseHorario({
    String? id,
    required this.materia,
    this.materiaId,
    required this.horaInicio,
    required this.horaFin,
    required this.color,
  }) : id = id ?? 'clase_${DateTime.now().millisecondsSinceEpoch}';
}

class HorarioPage extends StatefulWidget {
  const HorarioPage({super.key});

  @override
  State<HorarioPage> createState() => _HorarioPageState();
}

class _HorarioPageState extends State<HorarioPage> {
  // Días de la semana
  final List<String> dias = [
    'Lunes', 'Martes', 'Miércoles', 'Jueves', 'Viernes', 'Sábado', 'Domingo'
  ];

  // Mapa para almacenar clases por día
  final Map<String, List<ClaseHorario>> _clasesHorario = {
    'Lunes': [],
    'Martes': [],
    'Miércoles': [],
    'Jueves': [],
    'Viernes': [],
    'Sábado': [],
    'Domingo': [],
  };

  // Día seleccionado actualmente
  String _diaSeleccionado = 'Lunes';

  // Lista de materias disponibles
  List<Materia> _materias = [];

  // Map para almacenar el color de cada materia
  Map<String, Color> _coloresMaterias = {};

  // Controladores para los campos del formulario
  late DatabaseHelper _dbHelper;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _dbHelper = DatabaseHelper();
    _verificarTablas(); // Añadir este método para diagnóstico
    _cargarMaterias();
    _cargarHorario();
  }

  // Método de diagnóstico
  Future<void> _verificarTablas() async {
    try {
      final tablas = await _dbHelper.verificarTablasExistentes();
      print("Tablas existentes en la base de datos: $tablas");
    } catch (e) {
      print("Error al verificar tablas: $e");
    }
  }

  // Cargar materias desde la base de datos
  Future<void> _cargarMaterias() async {
    setState(() {
      _isLoading = true;
    });

    try {
      _materias = await _dbHelper.getMaterias();

      // Crear un mapa de nombres de materias a colores
      _coloresMaterias = {};
      for (var materia in _materias) {
        _coloresMaterias[materia.nombre] = Color(materia.color);
      }

      // Si no hay materias, mostrar un mensaje
      if (_materias.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No hay materias disponibles. Por favor, crea materias primero.'),
            duration: Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      print('Error al cargar materias: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cargar materias: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Cargar el horario desde la base de datos
  Future<void> _cargarHorario() async {
    try {
      setState(() {
        _isLoading = true;
      });

      // Inicializar el mapa de clases por día
      for (var dia in dias) {
        _clasesHorario[dia] = [];
      }

      // Verificar que la tabla horario existe
      final tablas = await _dbHelper.verificarTablasExistentes();
      if (!tablas.contains('horario')) {
        print("ADVERTENCIA: La tabla 'horario' no existe en la base de datos");

        // Intentamos forzar la creación de la tabla horario
        try {
          // Cerramos y volvemos a abrir la base de datos para forzar la actualización
          await _dbHelper.inicializarDatosEjemplo();

          // Verificamos de nuevo
          final tablasActualizadas = await _dbHelper.verificarTablasExistentes();
          print("Tablas después de intentar forzar actualización: $tablasActualizadas");

          if (!tablasActualizadas.contains('horario')) {
            setState(() {
              _isLoading = false;
            });
            return;
          }
        } catch (e) {
          print("Error al intentar forzar la creación de la tabla: $e");
          setState(() {
            _isLoading = false;
          });
          return;
        }
      }

      // Cargar las clases del horario
      final clases = await _dbHelper.getHorarioClases();

      setState(() {
        for (var clase in clases) {
          if (_clasesHorario.containsKey(clase.dia)) {
            _clasesHorario[clase.dia]!.add(
              ClaseHorario(
                id: clase.id.toString(),
                materia: clase.materia,
                materiaId: clase.materiaId,
                horaInicio: clase.timeInicio,
                horaFin: clase.timeFin,
                color: Color(clase.color),
              ),
            );
          }
        }

        // Ordenar clases por hora
        for (var dia in dias) {
          _clasesHorario[dia]!.sort((a, b) {
            if (a.horaInicio.hour != b.horaInicio.hour) {
              return a.horaInicio.hour - b.horaInicio.hour;
            }
            return a.horaInicio.minute - b.horaInicio.minute;
          });
        }

        _isLoading = false;
      });
    } catch (e) {
      print('Error al cargar horario: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cargar horario: $e')),
      );
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Guardar una clase en la base de datos
  Future<void> _guardarClase(ClaseHorario clase, String dia) async {
    try {
      // Convertir la clase a formato para DB
      final horarioClase = HorarioClase(
        materiaId: clase.materiaId,
        materia: clase.materia,
        dia: dia,
        horaInicio: HorarioClase.timeOfDayToMinutes(clase.horaInicio),
        horaFin: HorarioClase.timeOfDayToMinutes(clase.horaFin),
        color: clase.color.value,
      );

      // Guardar en la base de datos
      int id = await _dbHelper.insertHorarioClase(horarioClase);

      // Actualizar el ID en memoria
      setState(() {
        int index = _clasesHorario[dia]!.indexOf(clase);
        if (index >= 0) {
          _clasesHorario[dia]![index] = ClaseHorario(
            id: id.toString(),
            materia: clase.materia,
            materiaId: clase.materiaId,
            horaInicio: clase.horaInicio,
            horaFin: clase.horaFin,
            color: clase.color,
          );
        }
      });

      // Mostrar confirmación
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Clase guardada en horario')),
      );
    } catch (e) {
      print('Error al guardar clase en horario: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al guardar: $e')),
      );
    }
  }

  // Método para verificar si hay conflicto de horario con otras clases
  bool _verificarConflictoHorario(ClaseHorario nuevaClase, String dia) {
    // Solo verificar conflictos en el día específico
    List<ClaseHorario> clasesDelDia = _clasesHorario[dia] ?? [];

    // Si estamos editando, excluir la clase actual de la verificación
    if (nuevaClase.id.isNotEmpty) {
      clasesDelDia = clasesDelDia.where((c) => c.id != nuevaClase.id).toList();
    }

    // Convertir horas a minutos para comparación más fácil
    int inicioNueva = HorarioClase.timeOfDayToMinutes(nuevaClase.horaInicio);
    int finNueva = HorarioClase.timeOfDayToMinutes(nuevaClase.horaFin);

    // Verificar si hay alguna clase que se superponga con la nueva
    for (var claseExistente in clasesDelDia) {
      int inicioExistente = HorarioClase.timeOfDayToMinutes(claseExistente.horaInicio);
      int finExistente = HorarioClase.timeOfDayToMinutes(claseExistente.horaFin);

      // Verificar superposición
      // Caso 1: La nueva clase comienza durante una clase existente
      // Caso 2: La nueva clase termina durante una clase existente
      // Caso 3: La nueva clase encierra completamente a una existente
      bool hayConflicto =
          (inicioNueva >= inicioExistente && inicioNueva < finExistente) ||
          (finNueva > inicioExistente && finNueva <= finExistente) ||
          (inicioNueva <= inicioExistente && finNueva >= finExistente);

      if (hayConflicto) {
        return true;
      }
    }

    return false; // No hay conflicto
  }

  // Eliminar una clase de la base de datos
  Future<void> _eliminarClaseDB(int index) async {
    final clase = _clasesHorario[_diaSeleccionado]![index];

    try {
      if (clase.id.isNotEmpty) {
        final id = int.tryParse(clase.id);
        if (id != null) {
          await _dbHelper.deleteHorarioClase(id);
        }
      }

      setState(() {
        _clasesHorario[_diaSeleccionado]!.removeAt(index);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Clase eliminada correctamente')),
      );
    } catch (e) {
      print('Error al eliminar clase: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al eliminar: $e')),
      );
    }
  }

  void _agregarClase() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _FormularioClase(
        dia: _diaSeleccionado,
        materias: _materias,
        onGuardar: (clase) {
          // Verificar si hay conflicto antes de añadir la clase al estado
          bool hayConflicto = _verificarConflictoHorario(clase, _diaSeleccionado);
          if (hayConflicto) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Error: Ya existe una materia en ese horario'),
                backgroundColor: Colors.red,
              ),
            );
            return; // No continuar si hay conflicto
          }

          setState(() {
            _clasesHorario[_diaSeleccionado]!.add(clase);
            // Ordenar clases por hora de inicio
            _clasesHorario[_diaSeleccionado]!.sort((a, b) {
              if (a.horaInicio.hour != b.horaInicio.hour) {
                return a.horaInicio.hour - b.horaInicio.hour;
              }
              return a.horaInicio.minute - b.horaInicio.minute;
            });
          });

          // Guardar en la base de datos
          _guardarClase(clase, _diaSeleccionado);
        }
      ),
    );
  }

  void _editarClase(int index) {
    final clase = _clasesHorario[_diaSeleccionado]![index];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _FormularioClase(
        dia: _diaSeleccionado,
        materias: _materias,
        claseExistente: clase,
        onGuardar: (claseActualizada) async {
          // Verificar conflicto antes de eliminar la clase antigua
          if (_verificarConflictoHorario(claseActualizada, _diaSeleccionado)) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Error: Ya existe una materia en ese horario'),
                backgroundColor: Colors.red,
              ),
            );
            return;
          }

          // Primero eliminar la clase antigua si tiene ID
          if (clase.id.isNotEmpty) {
            final id = int.tryParse(clase.id);
            if (id != null) {
              await _dbHelper.deleteHorarioClase(id);
            }
          }

          // Luego guardar la nueva versión
          await _guardarClase(claseActualizada, _diaSeleccionado);

          setState(() {
            _clasesHorario[_diaSeleccionado]![index] = claseActualizada;
            // Ordenar clases por hora de inicio
            _clasesHorario[_diaSeleccionado]!.sort((a, b) {
              if (a.horaInicio.hour != b.horaInicio.hour) {
                return a.horaInicio.hour - b.horaInicio.hour;
              }
              return a.horaInicio.minute - b.horaInicio.minute;
            });
          });
        }
      ),
    );
  }

  void _eliminarClase(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar eliminación'),
          content: Text('¿Estás seguro de que deseas eliminar esta clase de "${_clasesHorario[_diaSeleccionado]![index].materia}"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                _eliminarClaseDB(index);
                Navigator.of(context).pop();
              },
              child: const Text('Eliminar', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  void _mostrarAyuda() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Ayuda del Horario'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text('• Pulsa + para añadir una nueva clase al horario.', style: TextStyle(fontSize: 14)),
              SizedBox(height: 8),
              Text('• Pulsa el icono de lápiz para editar una clase.', style: TextStyle(fontSize: 14)),
              SizedBox(height: 8),
              Text('• Pulsa el icono de papelera para eliminar una clase.', style: TextStyle(fontSize: 14)),
              SizedBox(height: 8),
              Text('• Desliza una clase hacia la izquierda para eliminarla rápidamente.', style: TextStyle(fontSize: 14)),
              SizedBox(height: 8),
              Text('• Cambia entre días usando las pestañas superiores.', style: TextStyle(fontSize: 14)),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Entendido'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi Horario'),
        actions: [
          // Botón de ayuda
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: _mostrarAyuda,
            tooltip: 'Ayuda',
          ),
          // Botón para recargar
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              _cargarMaterias();
              _cargarHorario();
            },
            tooltip: 'Recargar',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Selector de día
                Container(
                  height: 60,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: dias.length,
                    itemBuilder: (context, index) {
                      final dia = dias[index];
                      final isSelected = dia == _diaSeleccionado;
                      final tieneClases = _clasesHorario[dia]!.isNotEmpty;

                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: ChoiceChip(
                          label: Row(
                            children: [
                              Text(dia),
                              if (tieneClases)
                                const Padding(
                                  padding: EdgeInsets.only(left: 4),
                                  child: Icon(Icons.circle, size: 8, color: Colors.red),
                                ),
                            ],
                          ),
                          selected: isSelected,
                          onSelected: (selected) {
                            if (selected) {
                              setState(() {
                                _diaSeleccionado = dia;
                              });
                            }
                          },
                          selectedColor: Colors.blue[100],
                          labelStyle: TextStyle(
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // Clases del día
                Expanded(
                  child: _clasesHorario[_diaSeleccionado]!.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.free_breakfast, size: 80, color: Colors.grey[400]),
                              const SizedBox(height: 16),
                              Text(
                                'No hay clases el ${_diaSeleccionado.toLowerCase()}',
                                style: const TextStyle(fontSize: 18, color: Colors.grey),
                              ),
                              const SizedBox(height: 24),
                              ElevatedButton.icon(
                                onPressed: _agregarClase,
                                icon: const Icon(Icons.add),
                                label: const Text('Agregar clase'),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: _clasesHorario[_diaSeleccionado]!.length,
                          itemBuilder: (context, index) {
                            final clase = _clasesHorario[_diaSeleccionado]![index];

                            return Dismissible(
                              key: Key(clase.id),
                              direction: DismissDirection.endToStart,
                              background: Container(
                                alignment: Alignment.centerRight,
                                padding: const EdgeInsets.only(right: 20.0),
                                color: Colors.red,
                                child: const Icon(Icons.delete, color: Colors.white),
                              ),
                              confirmDismiss: (direction) async {
                                // Mostrar diálogo de confirmación al deslizar
                                return await showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text('Confirmar eliminación'),
                                      content: Text('¿Estás seguro de que deseas eliminar la clase "${clase.materia}"?'),
                                      actions: [
                                        TextButton(
                                          onPressed: () => Navigator.of(context).pop(false), // No eliminar
                                          child: const Text('Cancelar'),
                                        ),
                                        TextButton(
                                          onPressed: () => Navigator.of(context).pop(true), // Sí eliminar
                                          child: const Text('Eliminar', style: TextStyle(color: Colors.red)),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              onDismissed: (direction) {
                                _eliminarClaseDB(index);
                              },
                              child: Card(
                                elevation: 2,
                                margin: const EdgeInsets.symmetric(vertical: 8),
                                color: clase.color.withOpacity(0.7),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: ListTile(
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                  title: Text(
                                    clase.materia,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  subtitle: Text(
                                    '${_formatHora(clase.horaInicio)} - ${_formatHora(clase.horaFin)}',
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.edit),
                                        onPressed: () => _editarClase(index),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.delete_outline),
                                        onPressed: () => _eliminarClase(index),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
      floatingActionButton: _isLoading
          ? null
          : FloatingActionButton(
              onPressed: _agregarClase,
              child: const Icon(Icons.add),
            ),
    );
  }

  String _formatHora(TimeOfDay hora) {
    final hour = hora.hour.toString().padLeft(2, '0');
    final minute = hora.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  // Método para obtener el color de una materia por su nombre
  Color _obtenerColorMateria(String nombreMateria) {
    // Buscar el color en el mapa de colores de materias
    if (_coloresMaterias.containsKey(nombreMateria)) {
      return _coloresMaterias[nombreMateria]!;
    }

    // Si no se encuentra, usar un color predeterminado
    return Colors.blue[100]!;
  }
}

class _FormularioClase extends StatefulWidget {
  final String dia;
  final List<Materia> materias;
  final ClaseHorario? claseExistente;
  final Function(ClaseHorario) onGuardar;

  const _FormularioClase({
    required this.dia,
    required this.materias,
    required this.onGuardar,
    this.claseExistente,
  });

  @override
  State<_FormularioClase> createState() => _FormularioClaseState();
}

class _FormularioClaseState extends State<_FormularioClase> {
  late TimeOfDay _horaInicio;
  late TimeOfDay _horaFin;
  Materia? _materiaSeleccionada;
  late Color _colorSeleccionado;

  @override
  void initState() {
    super.initState();

    if (widget.claseExistente != null) {
      // Edición: inicializar con valores existentes
      _horaInicio = widget.claseExistente!.horaInicio;
      _horaFin = widget.claseExistente!.horaFin;

      // Buscar la materia por su ID o nombre
      if (widget.claseExistente!.materiaId != null) {
        try {
          _materiaSeleccionada = widget.materias.firstWhere(
            (m) => m.id == widget.claseExistente!.materiaId,
            orElse: () => throw Exception('No se encontró la materia'),
          );
        } catch (e) {
          _materiaSeleccionada = null;
        }
      }

      // Si no se encontró por ID, buscar por nombre
      if (_materiaSeleccionada == null && widget.materias.isNotEmpty) {
        try {
          _materiaSeleccionada = widget.materias.firstWhere(
            (m) => m.nombre == widget.claseExistente!.materia,
            orElse: () => widget.materias.first,
          );
        } catch (e) {
          _materiaSeleccionada = widget.materias.first;
        }
      }

      _colorSeleccionado = widget.claseExistente!.color;
    } else {
      // Nueva clase: valores por defecto
      _horaInicio = const TimeOfDay(hour: 8, minute: 0);
      _horaFin = const TimeOfDay(hour: 9, minute: 0);
      _materiaSeleccionada = widget.materias.isNotEmpty ? widget.materias[0] : null;
      _colorSeleccionado = _materiaSeleccionada != null
          ? Color(_materiaSeleccionada!.color)
          : Colors.blue[100]!;
    }
  }

  Future<void> _seleccionarHoraInicio() async {
    final TimeOfDay? hora = await showTimePicker(
      context: context,
      initialTime: _horaInicio,
    );
    if (hora != null) {
      setState(() {
        _horaInicio = hora;

        // Asegurar que la hora de fin sea posterior a la hora de inicio
        if (_compareTimeOfDay(_horaInicio, _horaFin) >= 0) {
          // Añadir una hora a la hora de inicio
          _horaFin = TimeOfDay(
            hour: (_horaInicio.hour + 1) % 24,
            minute: _horaInicio.minute,
          );
        }
      });
    }
  }

  Future<void> _seleccionarHoraFin() async {
    final TimeOfDay? hora = await showTimePicker(
      context: context,
      initialTime: _horaFin,
    );
    if (hora != null) {
      if (_compareTimeOfDay(_horaInicio, hora) >= 0) {
        // Mostrar error si la hora de fin es anterior a la hora de inicio
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('La hora de fin debe ser posterior a la hora de inicio'),
          ),
        );
      } else {
        setState(() {
          _horaFin = hora;
        });
      }
    }
  }

  // Método para comparar dos TimeOfDay
  int _compareTimeOfDay(TimeOfDay time1, TimeOfDay time2) {
    if (time1.hour != time2.hour) {
      return time1.hour - time2.hour;
    }
    return time1.minute - time2.minute;
  }

  String _formatHora(TimeOfDay hora) {
    final hour = hora.hour.toString().padLeft(2, '0');
    final minute = hora.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: 20,
        left: 20,
        right: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.claseExistente != null ? 'Editar Clase - ${widget.dia}' : 'Nueva Clase - ${widget.dia}',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),

          // Selector de materia
          const Text('Materia:', style: TextStyle(fontSize: 16)),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
            child: widget.materias.isEmpty
                ? const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Text('No hay materias disponibles'),
                  )
                : DropdownButtonHideUnderline(
                    child: DropdownButton<Materia>(
                      isExpanded: true,
                      value: _materiaSeleccionada,
                      hint: const Text('Selecciona una materia'),
                      onChanged: (Materia? newValue) {
                        if (newValue != null) {
                          setState(() {
                            _materiaSeleccionada = newValue;
                            // Actualizar el color basado en la materia
                            _colorSeleccionado = Color(newValue.color);
                          });
                        }
                      },
                      items: widget.materias
                          .map<DropdownMenuItem<Materia>>((materia) {
                        return DropdownMenuItem<Materia>(
                          value: materia,
                          child: Row(
                            children: [
                              // Mostrar el color de la materia
                              Container(
                                width: 16,
                                height: 16,
                                margin: const EdgeInsets.only(right: 8),
                                decoration: BoxDecoration(
                                  color: Color(materia.color),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                              // Nombre de la materia
                              Expanded(
                                child: Text(materia.nombre),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
          ),
          const SizedBox(height: 16),

          // Horario simplificado para el móvil
          const Text('Horario:', style: TextStyle(fontSize: 16)),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: _seleccionarHoraInicio,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(_formatHora(_horaInicio), style: const TextStyle(fontSize: 16)),
                        const Icon(Icons.access_time),
                      ],
                    ),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: Text('a', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              Expanded(
                child: InkWell(
                  onTap: _seleccionarHoraFin,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(_formatHora(_horaFin), style: const TextStyle(fontSize: 16)),
                        const Icon(Icons.access_time),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Botones
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancelar'),
              ),
              const SizedBox(width: 16),
              ElevatedButton(
                onPressed: () {
                  if (_materiaSeleccionada != null) {
                    final nuevaClase = ClaseHorario(
                      id: widget.claseExistente?.id ?? '',
                      materia: _materiaSeleccionada!.nombre,
                      materiaId: _materiaSeleccionada!.id,
                      horaInicio: _horaInicio,
                      horaFin: _horaFin,
                      color: _colorSeleccionado,
                    );

                    widget.onGuardar(nuevaClase);
                    Navigator.pop(context);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Por favor, selecciona una materia'),
                      ),
                    );
                  }
                },
                child: const Text('Guardar'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

