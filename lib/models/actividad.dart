class Actividad {
  final String id;
  final String titulo;
  final String descripcion;
  final String materiaId;
  final DateTime fechaEntrega;
  final bool completada;

  Actividad({
    required this.id,
    required this.titulo,
    required this.descripcion,
    required this.materiaId,
    required this.fechaEntrega,
    this.completada = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'titulo': titulo,
      'descripcion': descripcion,
      'materiaId': materiaId,
      'fechaEntrega': fechaEntrega.toIso8601String(),
      'completada': completada,
    };
  }

  factory Actividad.fromJson(Map<String, dynamic> json) {
    return Actividad(
      id: json['id'],
      titulo: json['titulo'],
      descripcion: json['descripcion'],
      materiaId: json['materiaId'],
      fechaEntrega: DateTime.parse(json['fechaEntrega']),
      completada: json['completada'] ?? false,
    );
  }

  Actividad copyWith({
    String? id,
    String? titulo,
    String? descripcion,
    String? materiaId,
    DateTime? fechaEntrega,
    bool? completada,
  }) {
    return Actividad(
      id: id ?? this.id,
      titulo: titulo ?? this.titulo,
      descripcion: descripcion ?? this.descripcion,
      materiaId: materiaId ?? this.materiaId,
      fechaEntrega: fechaEntrega ?? this.fechaEntrega,
      completada: completada ?? this.completada,
    );
  }
}
