import '../models/materia.dart';
import '../models/actividad.dart';
import 'package:uuid/uuid.dart';

class InMemoryStorage {
  static final InMemoryStorage _instance = InMemoryStorage._internal();
  factory InMemoryStorage() => _instance;
  InMemoryStorage._internal();

  final List<Materia> _materias = [];
  final List<Actividad> _actividades = [];
  final Uuid _uuid = Uuid();

  // Materias
  List<Materia> getMaterias() {
    return List.from(_materias);
  }

  Materia saveMateria(String nombre, String profesor, String color) {
    final newMateria = Materia(
      id: _uuid.v4(),
      nombre: nombre,
      profesor: profesor,
      color: color,
    );
    
    _materias.add(newMateria);
    return newMateria;
  }

  bool deleteMateria(String id) {
    _materias.removeWhere((materia) => materia.id == id);
    _actividades.removeWhere((actividad) => actividad.materiaId == id);
    return true;
  }

  // Actividades
  List<Actividad> getActividades() {
    return List.from(_actividades);
  }

  List<Actividad> getActividadesPorMateria(String materiaId) {
    return _actividades.where((actividad) => actividad.materiaId == materiaId).toList();
  }

  Actividad saveActividad(String titulo, String descripcion, String materiaId, DateTime fechaEntrega) {
    final newActividad = Actividad(
      id: _uuid.v4(),
      titulo: titulo,
      descripcion: descripcion,
      materiaId: materiaId,
      fechaEntrega: fechaEntrega,
    );
    
    _actividades.add(newActividad);
    return newActividad;
  }

  bool updateActividad(Actividad actividad) {
    final index = _actividades.indexWhere((a) => a.id == actividad.id);
    if (index != -1) {
      _actividades[index] = actividad;
      return true;
    }
    return false;
  }

  bool deleteActividad(String id) {
    _actividades.removeWhere((actividad) => actividad.id == id);
    return true;
  }

  bool marcarActividadCompletada(String id, bool completada) {
    final index = _actividades.indexWhere((a) => a.id == id);
    if (index != -1) {
      _actividades[index] = _actividades[index].copyWith(completada: completada);
      return true;
    }
    return false;
  }
}
