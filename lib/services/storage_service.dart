import 'package:flutter/material.dart';
import '../models/materia.dart';
import '../models/actividad.dart';
import 'file_storage.dart';

/// Este servicio actúa como un proxy hacia FileStorage
/// Proporcionado para mantener compatibilidad con código existente
class StorageService {
  final FileStorage _fileStorage = FileStorage();
  
  // Inicializar
  Future<void> initialize() {
    return _fileStorage.initialize();
  }
  
  // MATERIAS
  Future<List<Materia>> getMaterias() {
    return _fileStorage.getMaterias();
  }
  
  Future<Materia?> saveMateria(String nombre, String profesor, String color) {
    return _fileStorage.saveMateria(nombre, profesor, color);
  }
  
  Future<bool> deleteMateria(String id) {
    return _fileStorage.deleteMateria(id);
  }
  
  // ACTIVIDADES
  Future<List<Actividad>> getActividades() {
    return _fileStorage.getActividades();
  }
  
  Future<List<Actividad>> getActividadesPorMateria(String materiaId) {
    return _fileStorage.getActividadesPorMateria(materiaId);
  }
  
  Future<Actividad?> saveActividad(String titulo, String descripcion, String materiaId, DateTime fechaEntrega) {
    return _fileStorage.saveActividad(titulo, descripcion, materiaId, fechaEntrega);
  }
  
  Future<bool> updateActividad(Actividad actividad) {
    return _fileStorage.updateActividad(actividad);
  }
  
  Future<bool> deleteActividad(String id) {
    return _fileStorage.deleteActividad(id);
  }
  
  Future<bool> marcarActividadCompletada(String id, bool completada) {
    return _fileStorage.marcarActividadCompletada(id, completada);
  }
  
  Future<Map<String, dynamic>> diagnosticoAlmacenamiento() {
    return _fileStorage.diagnosticoAlmacenamiento();
  }
}
