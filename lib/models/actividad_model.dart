import 'package:flutter/material.dart';

class Actividad {
  int? id;
  int materiaId; // ID de la materia asociada
  String nombre;
  String descripcion;
  DateTime fechaCreacion;
  DateTime fechaCierre;
  DateTime? fechaCompletado; // Null si no está completada
  bool completada;

  Actividad({
    this.id,
    required this.materiaId,
    required this.nombre,
    required this.descripcion,
    required this.fechaCreacion,
    required this.fechaCierre,
    this.fechaCompletado,
    this.completada = false,
  });

  // Convertir un objeto Actividad a un Map para guardar en la base de datos
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'materiaId': materiaId,
      'nombre': nombre,
      'descripcion': descripcion,
      'fechaCreacion': fechaCreacion.millisecondsSinceEpoch,
      'fechaCierre': fechaCierre.millisecondsSinceEpoch,
      'fechaCompletado': fechaCompletado?.millisecondsSinceEpoch,
      'completada': completada ? 1 : 0,
    };
  }

  // Crear un objeto Actividad desde un Map obtenido de la base de datos
  factory Actividad.fromMap(Map<String, dynamic> map) {
    return Actividad(
      id: map['id'],
      materiaId: map['materiaId'],
      nombre: map['nombre'],
      descripcion: map['descripcion'],
      fechaCreacion: DateTime.fromMillisecondsSinceEpoch(map['fechaCreacion']),
      fechaCierre: DateTime.fromMillisecondsSinceEpoch(map['fechaCierre']),
      fechaCompletado: map['fechaCompletado'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['fechaCompletado'])
          : null,
      completada: map['completada'] == 1,
    );
  }

  // Método para crear una copia de la actividad con algunos campos modificados
  Actividad copyWith({
    int? id,
    int? materiaId,
    String? nombre,
    String? descripcion,
    DateTime? fechaCreacion,
    DateTime? fechaCierre,
    DateTime? fechaCompletado,
    bool? completada,
  }) {
    return Actividad(
      id: id ?? this.id,
      materiaId: materiaId ?? this.materiaId,
      nombre: nombre ?? this.nombre,
      descripcion: descripcion ?? this.descripcion,
      fechaCreacion: fechaCreacion ?? this.fechaCreacion,
      fechaCierre: fechaCierre ?? this.fechaCierre,
      fechaCompletado: fechaCompletado ?? this.fechaCompletado,
      completada: completada ?? this.completada,
    );
  }

  // Método para marcar como completada
  void marcarComoCompletada() {
    completada = true;
    fechaCompletado = DateTime.now();
  }

  // Método para desmarcar como completada
  void desmarcarComoCompletada() {
    completada = false;
    fechaCompletado = null;
  }
}