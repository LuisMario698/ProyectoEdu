import 'package:flutter/material.dart';

class Actividad {
  final String titulo;
  final String descripcion;
  final String materia;
  final String maestro; // ← NUEVO
  final DateTime fecha;
  bool entregada;

  Actividad({
    required this.titulo,
    required this.descripcion,
    required this.materia,
    required this.maestro, // ← NUEVO
    required this.fecha,
    this.entregada = false,
  });

  Color get color => entregada ? Colors.greenAccent : Colors.redAccent;

  String get estado => entregada ? 'Entregada' : 'Pendiente';
}

List<Actividad> listaActividades = [
  Actividad(
    titulo: 'Proyecto POO',
    descripcion: 'Desarrolla un sistema con clases abstractas y herencia.',
    materia: 'Tópicos Avanzados de Programación',
    maestro: 'José María Gerónimo',
    fecha: DateTime(2025, 4, 7),
  ),
  Actividad(
    titulo: 'Tarea Interpolación',
    descripcion: 'Resolver ejercicios con el método de Lagrange.',
    materia: 'Métodos Numéricos',
    maestro: 'Anaís Burke',
    fecha: DateTime(2025, 4, 9),
  ),
  Actividad(
    titulo: 'Modelado de eventos discretos',
    descripcion: 'Investigar y representar un sistema discreto.',
    materia: 'Simulación',
    maestro: 'Brenda Dayana',
    fecha: DateTime(2025, 4, 11),
  ),
  Actividad(
    titulo: 'Ecuaciones de segundo orden',
    descripcion: 'Ejercicios del tema 4 del libro guía.',
    materia: 'Ecuaciones Diferenciales',
    maestro: 'Anaís Burke',
    fecha: DateTime(2025, 4, 10),
  ),
];
