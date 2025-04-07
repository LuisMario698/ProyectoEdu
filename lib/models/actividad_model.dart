import 'package:flutter/material.dart';

class Actividad {
  int? id;
  int? materiaId;
  String nombre;
  String descripcion;
  DateTime fechaCreacion;
  DateTime fechaCierre;
  DateTime? fechaCompletado;
  bool completada;

  Actividad({
    this.id,
    this.materiaId,
    required this.nombre,
    this.descripcion = "",
    DateTime? fechaCreacion,
    required this.fechaCierre,
    this.fechaCompletado,
    this.completada = false,
  }) : fechaCreacion = fechaCreacion ?? DateTime.now();

  // Método copyWith para crear una copia con algunas propiedades modificadas
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

  // Convertir un Actividad en Map
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

  // Convertir Map en un Actividad
  factory Actividad.fromMap(Map<String, dynamic> map) {
    return Actividad(
      id: map['id'],
      materiaId: map['materiaId'],
      nombre: map['nombre'],
      descripcion: map['descripcion'] ?? "",
      fechaCreacion: DateTime.fromMillisecondsSinceEpoch(map['fechaCreacion']),
      fechaCierre: DateTime.fromMillisecondsSinceEpoch(map['fechaCierre']),
      fechaCompletado: map['fechaCompletado'] != null 
          ? DateTime.fromMillisecondsSinceEpoch(map['fechaCompletado']) 
          : null,
      completada: map['completada'] == 1,
    );
  }
}
