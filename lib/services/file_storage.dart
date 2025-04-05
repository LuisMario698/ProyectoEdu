import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import '../models/materia.dart';
import '../models/actividad.dart';

class FileStorage {
  static final FileStorage _instance = FileStorage._internal();
  factory FileStorage() => _instance;
  FileStorage._internal();

  final Uuid _uuid = Uuid();
  static const String MATERIAS_FILENAME = 'materias.json';
  static const String ACTIVIDADES_FILENAME = 'actividades.json';

  // Flag para saber si está inicializado
  bool _isInitialized = false;
  Directory? _appDirectory;

  // Método para inicializar
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      _appDirectory = await getApplicationDocumentsDirectory();
      debugPrint('📂 Directorio de la aplicación: ${_appDirectory!.path}');

      // Crear archivos si no existen
      final materiasFile = await _materiasFile;
      final actividadesFile = await _actividadesFile;

      if (!await materiasFile.exists()) {
        await materiasFile.create(recursive: true);
        await materiasFile.writeAsString('[]');
        debugPrint('📂 Archivo de materias creado');
      }

      if (!await actividadesFile.exists()) {
        await actividadesFile.create(recursive: true);
        await actividadesFile.writeAsString('[]');
        debugPrint('📂 Archivo de actividades creado');
      }

      _isInitialized = true;
      debugPrint('✅ FileStorage inicializado correctamente');

      // Verificar si hay datos
      final materias = await getMaterias();
      if (materias.isEmpty) {
        debugPrint('📂 No hay materias, creando datos de ejemplo');
        _crearDatosEjemplo();
      }
    } catch (e) {
      debugPrint('❌ Error al inicializar FileStorage: $e');
      rethrow;
    }
  }

  // Crea algunos datos de ejemplo para comenzar
  Future<void> _crearDatosEjemplo() async {
    try {
      // Crear algunas materias de ejemplo
      final matematicas = await saveMateria('Matemáticas', 'Prof. García', 'FF2196F3'); // Azul
      final historia = await saveMateria('Historia', 'Prof. Rodríguez', 'FFF44336'); // Rojo
      final literatura = await saveMateria('Literatura', 'Prof. Sánchez', 'FF4CAF50'); // Verde

      // Crear algunas actividades
      await saveActividad(
        'Tarea de ecuaciones',
        'Resolver ejercicios 1-10 de la página 45',
        matematicas.id,
        DateTime.now().add(Duration(days: 2)),
      );

      await saveActividad(
        'Ensayo sobre la Revolución Francesa',
        'Escribir un ensayo de 3 páginas sobre las causas y consecuencias de la Revolución Francesa',
        historia.id,
        DateTime.now().add(Duration(days: 5)),
      );

      await saveActividad(
        'Análisis de "Cien años de soledad"',
        'Analizar los personajes principales y temas de la obra',
        literatura.id,
        DateTime.now().add(Duration(days: 7)),
      );

      debugPrint('✅ Datos de ejemplo creados exitosamente');
    } catch (e) {
      debugPrint('❌ Error al crear datos de ejemplo: $e');
    }
  }

  // Obtener archivo de materias
  Future<File> get _materiasFile async {
    if (_appDirectory == null) {
      _appDirectory = await getApplicationDocumentsDirectory();
    }
    return File('${_appDirectory!.path}/$MATERIAS_FILENAME');
  }

  // Obtener archivo de actividades
  Future<File> get _actividadesFile async {
    if (_appDirectory == null) {
      _appDirectory = await getApplicationDocumentsDirectory();
    }
    return File('${_appDirectory!.path}/$ACTIVIDADES_FILENAME');
  }

  // MATERIAS

  // Obtener todas las materias
  Future<List<Materia>> getMaterias() async {
    try {
      final file = await _materiasFile;

      if (!await file.exists()) {
        return [];
      }

      final content = await file.readAsString();
      if (content.isEmpty) {
        return [];
      }

      List<dynamic> decoded = jsonDecode(content);
      final materias = decoded.map((item) => Materia.fromJson(item)).toList();
      return materias;
    } catch (e) {
      debugPrint('❌ Error al leer materias desde archivo: $e');
      return [];
    }
  }

  // Guardar una nueva materia
  Future<Materia> saveMateria(String nombre, String profesor, String color) async {
    try {
      final materias = await getMaterias();
      final file = await _materiasFile;

      final newMateria = Materia(
        id: _uuid.v4(),
        nombre: nombre,
        profesor: profesor,
        color: color,
      );

      materias.add(newMateria);
      final jsonString = jsonEncode(materias.map((m) => m.toJson()).toList());

      await file.writeAsString(jsonString);
      debugPrint('💾 Materia guardada: ${newMateria.nombre}');

      return newMateria;
    } catch (e) {
      debugPrint('❌ Error al guardar materia: $e');
      rethrow;
    }
  }

  // Eliminar una materia
  Future<bool> deleteMateria(String id) async {
    try {
      List<Materia> materias = await getMaterias();
      final existia = materias.any((m) => m.id == id);

      materias.removeWhere((materia) => materia.id == id);

      final file = await _materiasFile;
      await file.writeAsString(jsonEncode(materias.map((m) => m.toJson()).toList()));

      // También eliminar actividades asociadas
      await _deleteActividadesByMateriaId(id);

      return existia;
    } catch (e) {
      debugPrint('❌ Error al eliminar materia: $e');
      return false;
    }
  }

  // ACTIVIDADES

  // Obtener todas las actividades
  Future<List<Actividad>> getActividades() async {
    try {
      final file = await _actividadesFile;

      if (!await file.exists()) {
        return [];
      }

      final content = await file.readAsString();
      if (content.isEmpty) {
        return [];
      }

      List<dynamic> decoded = jsonDecode(content);
      return decoded.map((item) => Actividad.fromJson(item)).toList();
    } catch (e) {
      debugPrint('❌ Error al leer actividades: $e');
      return [];
    }
  }

  // Obtener actividades por materia
  Future<List<Actividad>> getActividadesPorMateria(String materiaId) async {
    final actividades = await getActividades();
    return actividades.where((actividad) => actividad.materiaId == materiaId).toList();
  }

  // Guardar una nueva actividad
  Future<Actividad> saveActividad(String titulo, String descripcion, String materiaId, DateTime fechaEntrega) async {
    try {
      final actividades = await getActividades();
      final file = await _actividadesFile;

      final newActividad = Actividad(
        id: _uuid.v4(),
        titulo: titulo,
        descripcion: descripcion,
        materiaId: materiaId,
        fechaEntrega: fechaEntrega,
      );

      actividades.add(newActividad);
      await file.writeAsString(jsonEncode(actividades.map((a) => a.toJson()).toList()));

      debugPrint('💾 Actividad guardada: ${newActividad.titulo}');
      return newActividad;
    } catch (e) {
      debugPrint('❌ Error al guardar actividad: $e');
      rethrow;
    }
  }

  // Actualizar una actividad
  Future<bool> updateActividad(Actividad actividad) async {
    try {
      List<Actividad> actividades = await getActividades();

      final index = actividades.indexWhere((a) => a.id == actividad.id);
      if (index != -1) {
        actividades[index] = actividad;

        final file = await _actividadesFile;
        await file.writeAsString(jsonEncode(actividades.map((a) => a.toJson()).toList()));
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('❌ Error al actualizar actividad: $e');
      return false;
    }
  }

  // Eliminar una actividad
  Future<bool> deleteActividad(String id) async {
    try {
      List<Actividad> actividades = await getActividades();
      final existia = actividades.any((a) => a.id == id);

      actividades.removeWhere((actividad) => actividad.id == id);

      final file = await _actividadesFile;
      await file.writeAsString(jsonEncode(actividades.map((a) => a.toJson()).toList()));

      return existia;
    } catch (e) {
      debugPrint('❌ Error al eliminar actividad: $e');
      return false;
    }
  }

  // Eliminar actividades por materia
  Future<bool> _deleteActividadesByMateriaId(String materiaId) async {
    try {
      List<Actividad> actividades = await getActividades();
      actividades.removeWhere((actividad) => actividad.materiaId == materiaId);

      final file = await _actividadesFile;
      await file.writeAsString(jsonEncode(actividades.map((a) => a.toJson()).toList()));

      return true;
    } catch (e) {
      debugPrint('❌ Error al eliminar actividades de materia: $e');
      return false;
    }
  }

  // Marcar una actividad como completada
  Future<bool> marcarActividadCompletada(String id, bool completada) async {
    try {
      List<Actividad> actividades = await getActividades();

      final index = actividades.indexWhere((a) => a.id == id);
      if (index != -1) {
        actividades[index] = actividades[index].copyWith(completada: completada);

        final file = await _actividadesFile;
        await file.writeAsString(jsonEncode(actividades.map((a) => a.toJson()).toList()));
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('❌ Error al marcar actividad: $e');
      return false;
    }
  }

  // Método para obtener información de diagnóstico
  Future<Map<String, dynamic>> diagnosticoAlmacenamiento() async {
    try {
      final materias = await getMaterias();
      final actividades = await getActividades();

      return {
        "tipo_almacenamiento": "Archivo (FileStorage)",
        "inicializado": _isInitialized,
        "directorio": _appDirectory?.path ?? "No disponible",
        "materias_almacenadas": materias.length,
        "actividades_almacenadas": actividades.length,
        "duracion": "Permanente (entre sesiones)"
      };
    } catch (e) {
      return {
        "tipo_almacenamiento": "Archivo (FileStorage)",
        "error": e.toString(),
        "inicializado": _isInitialized,
      };
    }
  }
}
