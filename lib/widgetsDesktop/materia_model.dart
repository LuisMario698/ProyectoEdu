import 'package:flutter/material.dart';

class Materia {
  final String nombre;
  final Color color;

  Materia({required this.nombre, required this.color});
}

List<Materia> listaMaterias = [
  Materia(nombre: 'Tópicos Avanzados de Programación', color: Colors.blue),
  Materia(nombre: 'Principios eléctricos', color: Colors.orange),
  Materia(nombre: 'Ecuaciones Diferenciales', color: Colors.green),
  Materia(nombre: 'Inglés', color: Colors.purple),
  Materia(nombre: 'Métodos numéricos', color: Colors.teal),
  Materia(nombre: 'Bases de Datos', color: Colors.redAccent),
  Materia(nombre: 'Simulación', color: Colors.brown),
];

Color colorDeMateria(String nombre) {
  return listaMaterias.firstWhere(
    (m) => m.nombre == nombre,
    orElse: () => Materia(nombre: nombre, color: Colors.grey),
  ).color;
}
 