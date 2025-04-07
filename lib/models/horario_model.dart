import 'package:flutter/material.dart';

class HorarioClase {
  int? id;
  int? materiaId;
  String materia;
  String dia; // 'Lunes', 'Martes', etc.
  int horaInicio;  // Minutos desde medianoche (7:00 = 420)
  int horaFin;     // Minutos desde medianoche (8:30 = 510)
  int color;

  HorarioClase({
    this.id,
    this.materiaId,
    required this.materia,
    required this.dia,
    required this.horaInicio,
    required this.horaFin,
    this.color = 0xFFB2EBF2, // Color predeterminado
  });

  // Métodos auxiliares para convertir entre TimeOfDay y minutos
  static int timeOfDayToMinutes(TimeOfDay time) {
    return time.hour * 60 + time.minute;
  }

  static TimeOfDay minutesToTimeOfDay(int minutes) {
    return TimeOfDay(hour: minutes ~/ 60, minute: minutes % 60);
  }

  // Getters para obtener TimeOfDay
  TimeOfDay get timeInicio => minutesToTimeOfDay(horaInicio);
  TimeOfDay get timeFin => minutesToTimeOfDay(horaFin);

  // Método copyWith
  HorarioClase copyWith({
    int? id,
    int? materiaId,
    String? materia,
    String? dia,
    int? horaInicio,
    int? horaFin,
    int? color,
  }) {
    return HorarioClase(
      id: id ?? this.id,
      materiaId: materiaId ?? this.materiaId,
      materia: materia ?? this.materia,
      dia: dia ?? this.dia,
      horaInicio: horaInicio ?? this.horaInicio,
      horaFin: horaFin ?? this.horaFin,
      color: color ?? this.color,
    );
  }

  // Convertir a Map para base de datos
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'materiaId': materiaId,
      'materia': materia,
      'dia': dia,
      'horaInicio': horaInicio,
      'horaFin': horaFin,
      'color': color,
    };
  }

  // Crear desde Map de base de datos
  factory HorarioClase.fromMap(Map<String, dynamic> map) {
    return HorarioClase(
      id: map['id'],
      materiaId: map['materiaId'],
      materia: map['materia'],
      dia: map['dia'],
      horaInicio: map['horaInicio'],
      horaFin: map['horaFin'],
      color: map['color'] ?? 0xFFB2EBF2,
    );
  }
}
