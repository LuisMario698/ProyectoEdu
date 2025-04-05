class Materia {
  final String id;
  final String nombre;
  final String profesor;
  final String color;

  Materia({
    required this.id,
    required this.nombre,
    required this.profesor,
    required this.color,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'profesor': profesor,
      'color': color,
    };
  }

  factory Materia.fromJson(Map<String, dynamic> json) {
    return Materia(
      id: json['id'],
      nombre: json['nombre'],
      profesor: json['profesor'],
      color: json['color'],
    );
  }
}
