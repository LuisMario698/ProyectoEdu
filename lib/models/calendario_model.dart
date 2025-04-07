import 'package:flutter/material.dart';

class CalendarioEvento {
  int? id;
  String titulo;
  String descripcion;
  DateTime fecha;
  int color;
  bool esActividad; // Para distinguir entre eventos y actividades
  int? actividadId; // Referencia a una actividad si es relevante

  CalendarioEvento({
    this.id,
    required this.titulo,
    this.descripcion = "",
    required this.fecha,
    this.color = 0xFF2196F3, // Color azul predeterminado
    this.esActividad = false,
    this.actividadId,
  });

  // Métodos para convertir a y desde Map para la base de datos
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'titulo': titulo,
      'descripcion': descripcion,
      'fecha': fecha.millisecondsSinceEpoch,
      'color': color,
      'esActividad': esActividad ? 1 : 0,
      'actividadId': actividadId,
    };
  }

  factory CalendarioEvento.fromMap(Map<String, dynamic> map) {
    return CalendarioEvento(
      id: map['id'],
      titulo: map['titulo'],
      descripcion: map['descripcion'] ?? "",
      fecha: DateTime.fromMillisecondsSinceEpoch(map['fecha']),
      color: map['color'] ?? 0xFF2196F3,
      esActividad: map['esActividad'] == 1,
      actividadId: map['actividadId'],
    );
  }
}
