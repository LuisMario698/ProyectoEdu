import 'package:flutter/material.dart';

class Actividad {
  final String titulo;
  final String descripcion;
  final String materia;
  final DateTime fecha;
  final String fechaLimiteStr; // Formato legible para mostrar
  String estado; // pendiente, no_entregada, entregada
  Color color;

  Actividad({
    required this.titulo,
    required this.descripcion,
    required this.materia,
    required this.fecha,
    required this.fechaLimiteStr,
    this.estado = 'pendiente',
    required this.color,
  });

  // Método para cambiar el estado de la actividad
  void marcarComoEntregada() {
    estado = 'entregada';
  }

  // Método para obtener el icono según el estado
  IconData get iconoEstado {
    switch (estado) {
      case 'entregada':
        return Icons.check_circle;
      case 'no_entregada':
        return Icons.warning_amber_rounded;
      default:
        return Icons.pending_actions;
    }
  }

  // Método para obtener el color del icono según el estado
  Color get colorEstado {
    switch (estado) {
      case 'entregada':
        return Colors.green;
      case 'no_entregada':
        return Colors.orange;
      default:
        return Colors.blue;
    }
  }
}

// Lista de actividades de ejemplo para usar en la aplicación
List<Actividad> listaActividades = [
  Actividad(
    titulo: 'Proyecto POO',
    descripcion: 'Desarrolla un sistema con clases abstractas y herencia.',
    materia: 'Tópicos Avanzados de Programación',
    fecha: DateTime(2025, 4, 7),
    fechaLimiteStr: '7 abril 2025 - 11:59 PM',
    color: const Color(0xFFBBDEFB),
  ),
  Actividad(
    titulo: 'Tarea Interpolación',
    descripcion: 'Resolver ejercicios con el método de Lagrange.',
    materia: 'Métodos Numéricos',
    fecha: DateTime(2025, 4, 9),
    fechaLimiteStr: '9 abril 2025 - 11:59 PM',
    color: const Color(0xFFFFF9C4),
  ),
  Actividad(
    titulo: 'Modelado de eventos discretos',
    descripcion: 'Investigar y representar un sistema discreto.',
    materia: 'Simulación',
    fecha: DateTime(2025, 4, 11),
    fechaLimiteStr: '11 abril 2025 - 11:59 PM',
    estado: 'no_entregada',
    color: const Color(0xFFB2EBF2),
  ),
  Actividad(
    titulo: 'Ecuaciones de segundo orden',
    descripcion: 'Ejercicios del tema 4 del libro guía.',
    materia: 'Ecuaciones Diferenciales',
    fecha: DateTime(2025, 4, 10),
    fechaLimiteStr: '10 abril 2025 - 11:59 PM',
    estado: 'entregada',
    color: const Color(0xFFC8E6C9),
  ),
  Actividad(
    titulo: 'Ensayo',
    descripcion: 'Redactar un ensayo sobre un tema de actualidad.',
    materia: 'Inglés 4',
    fecha: DateTime(2025, 4, 8),
    fechaLimiteStr: '8 abril 2025 - 11:59 PM',
    estado: 'entregada',
    color: const Color(0xFFD1C4E9),
  ),
];