import 'package:flutter/material.dart';

class Materia {
  int? id;
  String nombre;
  String descripcion;
  String maestro;
  int color;

  Materia({
    this.id,
    required this.nombre,
    this.descripcion = "",
    this.maestro = "",
    this.color = 0xFF81C784, // Color verde predeterminado
  });

  // Método copyWith para crear una copia con algunas propiedades modificadas
  Materia copyWith({
    int? id,
    String? nombre,
    String? descripcion,
    String? maestro,
    int? color,
  }) {
    return Materia(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      descripcion: descripcion ?? this.descripcion,
      maestro: maestro ?? this.maestro,
      color: color ?? this.color,
    );
  }

  // Convertir un Materia en Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombre': nombre,
      'descripcion': descripcion,
      'maestro': maestro,
      'color': color,
    };
  }

  // Convertir Map en un Materia
  factory Materia.fromMap(Map<String, dynamic> map) {
    return Materia(
      id: map['id'],
      nombre: map['nombre'],
      descripcion: map['descripcion'] ?? "",
      maestro: map['maestro'] ?? "",
      color: map['color'] ?? 0xFF81C784,
    );
  }

  // Método para obtener el objeto Color a partir del valor entero
  Color getColor() {
    return Color(color);
  }
}