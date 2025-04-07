class Materia {
  int? id;
  String nombre;
  String descripcion;
  String maestro;
  int color; // Código de color en formato entero (0xFFRRGGBB)

  Materia({
    this.id,
    required this.nombre,
    required this.descripcion,
    required this.maestro,
    required this.color,
  });

  // Convertir un objeto Materia a un Map para guardar en la base de datos
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombre': nombre,
      'descripcion': descripcion,
      'maestro': maestro,
      'color': color,
    };
  }

  // Crear un objeto Materia desde un Map obtenido de la base de datos
  factory Materia.fromMap(Map<String, dynamic> map) {
    return Materia(
      id: map['id'],
      nombre: map['nombre'],
      descripcion: map['descripcion'],
      maestro: map['maestro'],
      color: map['color'],
    );
  }

  // Método para crear una copia de la materia con algunos campos modificados
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
}