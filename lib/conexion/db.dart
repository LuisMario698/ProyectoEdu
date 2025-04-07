import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/materia_model.dart';
import '../models/actividad_model.dart';
import '../models/horario_model.dart'; // Verifica que esta importación exista
import '../models/calendario_model.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'materias_database.db');
    
    // Incrementar la versión para actualizar la estructura
    return await openDatabase(
      path,
      version: 4, // Incrementado a 4 para agregar la tabla de calendario
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  // Método para actualizar la estructura de la base de datos cuando cambia la versión
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    print("Actualizando base de datos de versión $oldVersion a $newVersion");
    
    if (oldVersion < 2) {
      // Verificar si la tabla 'actividades' existe
      var tables = await db.rawQuery("SELECT name FROM sqlite_master WHERE type='table' AND name='actividades'");
      if (tables.isEmpty) {
        // Crear la tabla de actividades si no existe
        await db.execute(
          '''CREATE TABLE actividades(
            id INTEGER PRIMARY KEY AUTOINCREMENT, 
            materiaId INTEGER, 
            nombre TEXT, 
            descripcion TEXT, 
            fechaCreacion INTEGER, 
            fechaCierre INTEGER, 
            fechaCompletado INTEGER, 
            completada INTEGER,
            FOREIGN KEY (materiaId) REFERENCES materias (id) ON DELETE CASCADE
          )''',
        );
      }

      // Verificar si la columna 'color' ya existe en la tabla 'materias'
      var tableInfo = await db.rawQuery("PRAGMA table_info(materias)");
      bool colorColumnExists = false;
      
      for (var column in tableInfo) {
        if (column['name'] == 'color') {
          colorColumnExists = true;
          break;
        }
      }
      
      // Si la columna 'color' no existe, agregarla
      if (!colorColumnExists) {
        await db.execute('ALTER TABLE materias ADD COLUMN color INTEGER DEFAULT 0xFF81C784');
      }
    }

    // Cambiamos el if para que se ejecute siempre que la versión sea menor a 3
    if (oldVersion < 3) {
      // Verificar si la tabla 'horario' existe
      var tables = await db.rawQuery("SELECT name FROM sqlite_master WHERE type='table' AND name='horario'");
      if (tables.isEmpty) {
        print("Creando tabla horario...");
        // Crear la tabla de horario si no existe
        await db.execute(
          '''CREATE TABLE horario(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            materiaId INTEGER,
            materia TEXT,
            dia TEXT,
            horaInicio INTEGER,
            horaFin INTEGER,
            color INTEGER,
            FOREIGN KEY (materiaId) REFERENCES materias (id) ON DELETE CASCADE
          )''',
        );
        print("Tabla horario creada correctamente");
      }
    }

    // Actualización para agregar la tabla de eventos del calendario
    if (oldVersion < 4) {
      // Verificar si la tabla 'calendario_eventos' existe
      var tables = await db.rawQuery("SELECT name FROM sqlite_master WHERE type='table' AND name='calendario_eventos'");
      if (tables.isEmpty) {
        print("Creando tabla calendario_eventos...");
        // Crear la tabla de eventos del calendario si no existe
        await db.execute(
          '''CREATE TABLE calendario_eventos(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            titulo TEXT,
            descripcion TEXT,
            fecha INTEGER,
            color INTEGER,
            esActividad INTEGER DEFAULT 0,
            actividadId INTEGER
          )''',
        );
        print("Tabla calendario_eventos creada correctamente");
      }
    }
    
    print("Actualización de base de datos completada");
  }

  Future<void> _onCreate(Database db, int version) async {
    print("Creando tablas de base de datos desde cero");
    // Tabla de materias con campo de color
    await db.execute(
      'CREATE TABLE materias(id INTEGER PRIMARY KEY AUTOINCREMENT, nombre TEXT, descripcion TEXT, maestro TEXT, color INTEGER)',
    );
    
    // Tabla de actividades
    await db.execute(
      '''CREATE TABLE actividades(
        id INTEGER PRIMARY KEY AUTOINCREMENT, 
        materiaId INTEGER, 
        nombre TEXT, 
        descripcion TEXT, 
        fechaCreacion INTEGER, 
        fechaCierre INTEGER, 
        fechaCompletado INTEGER, 
        completada INTEGER,
        FOREIGN KEY (materiaId) REFERENCES materias (id) ON DELETE CASCADE
      )''',
    );

    // Tabla de horario
    await db.execute(
      '''CREATE TABLE horario(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        materiaId INTEGER,
        materia TEXT,
        dia TEXT,
        horaInicio INTEGER,
        horaFin INTEGER,
        color INTEGER,
        FOREIGN KEY (materiaId) REFERENCES materias (id) ON DELETE CASCADE
      )''',
    );

    // Tabla de eventos del calendario
    await db.execute(
      '''CREATE TABLE calendario_eventos(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        titulo TEXT,
        descripcion TEXT,
        fecha INTEGER,
        color INTEGER,
        esActividad INTEGER DEFAULT 0,
        actividadId INTEGER
      )''',
    );

    print("Tablas creadas correctamente");
  }

  // Métodos CRUD para Materias y Actividades

  // Insertar una nueva materia
  Future<int> insertMateria(Materia materia) async {
    final db = await database;
    return await db.insert('materias', materia.toMap());
  }

  // Obtener todas las materias
  Future<List<Materia>> getMaterias() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('materias');

    return List.generate(maps.length, (i) {
      return Materia.fromMap(maps[i]);
    });
  }

  // Actualizar una materia
  Future<int> updateMateria(Materia materia) async {
    final db = await database;
    return await db.update(
      'materias',
      materia.toMap(),
      where: 'id = ?',
      whereArgs: [materia.id],
    );
  }

  // Eliminar una materia
  Future<int> deleteMateria(int id) async {
    final db = await database;
    return await db.delete(
      'materias',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Limpiar todas las tablas de la base de datos
  Future<void> limpiarBaseDeDatos() async {
    final db = await database;
    try {
      // Verificar si las tablas existen antes de intentar eliminar
      var tables = await db.query('sqlite_master',
          where: 'type = ? AND (name = ? OR name = ?)',
          whereArgs: ['table', 'actividades', 'materias']);
      
      // Crear un mapa para verificar rápidamente la existencia de las tablas
      var existingTables = Map.fromIterable(tables,
          key: (table) => table['name'] as String);

      // Eliminar registros solo si las tablas existen
      if (existingTables.containsKey('actividades')) {
        await db.delete('actividades');
      }
      if (existingTables.containsKey('materias')) {
        await db.delete('materias');
      }
    } catch (e) {
      throw Exception('Error al limpiar la base de datos: $e');
    }
  }

  // Obtener una materia por su ID
  Future<Materia?> getMateria(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'materias',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Materia.fromMap(maps.first);
    }
    return null;
  }
  
  // Métodos CRUD para Actividades
  
  // Insertar una nueva actividad
  Future<int> insertActividad(Actividad actividad) async {
    final db = await database;
    return await db.insert('actividades', actividad.toMap());
  }
  
  // Obtener todas las actividades
  Future<List<Actividad>> getActividades() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('actividades');
    
    return List.generate(maps.length, (i) {
      return Actividad.fromMap(maps[i]);
    });
  }
  
  // Obtener actividades por estado (pendientes, no entregadas, completadas)
  Future<List<Actividad>> getActividadesPorEstado(bool completadas) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'actividades',
      where: 'completada = ?',
      whereArgs: [completadas ? 1 : 0],
    );
    
    return List.generate(maps.length, (i) {
      return Actividad.fromMap(maps[i]);
    });
  }
  
  // Obtener actividades no entregadas (fecha de cierre pasada y no completadas)
  Future<List<Actividad>> getActividadesNoEntregadas() async {
    final db = await database;
    final ahora = DateTime.now().millisecondsSinceEpoch;
    
    final List<Map<String, dynamic>> maps = await db.query(
      'actividades',
      where: 'fechaCierre < ? AND completada = 0',
      whereArgs: [ahora],
    );
    
    return List.generate(maps.length, (i) {
      return Actividad.fromMap(maps[i]);
    });
  }
  
  // Obtener actividades pendientes (fecha de cierre futura y no completadas)
  Future<List<Actividad>> getActividadesPendientes() async {
    final db = await database;
    final ahora = DateTime.now().millisecondsSinceEpoch;
    
    final List<Map<String, dynamic>> maps = await db.query(
      'actividades',
      where: 'fechaCierre >= ? AND completada = 0',
      whereArgs: [ahora],
    );
    
    return List.generate(maps.length, (i) {
      return Actividad.fromMap(maps[i]);
    });
  }
  
  // Actualizar una actividad
  Future<int> updateActividad(Actividad actividad) async {
    final db = await database;
    return await db.update(
      'actividades',
      actividad.toMap(),
      where: 'id = ?',
      whereArgs: [actividad.id],
    );
  }
  
  // Eliminar una actividad
  Future<int> deleteActividad(int id) async {
    final db = await database;
    return await db.delete(
      'actividades',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
  
  // Marcar actividad como completada
  Future<int> marcarActividadComoCompletada(int id) async {
    final db = await database;
    return await db.update(
      'actividades',
      {
        'completada': 1,
        'fechaCompletado': DateTime.now().millisecondsSinceEpoch,
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }
  
  // Desmarcar actividad como completada
  Future<int> desmarcarActividadComoCompletada(int id) async {
    final db = await database;
    return await db.update(
      'actividades',
      {
        'completada': 0,
        'fechaCompletado': null,
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }
  
  // Obtener colores en uso por las materias
  Future<List<int>> getColoresEnUso() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'materias',
      columns: ['color'],
    );
    
    return maps.map((map) => map['color'] as int).toList();
  }
    
  // Métodos CRUD para el Horario

  // Insertar una nueva clase en el horario
  Future<int> insertHorarioClase(HorarioClase clase) async {
    final db = await database;
    return await db.insert('horario', clase.toMap());
  }

  // Obtener todas las clases del horario
  Future<List<HorarioClase>> getHorarioClases() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('horario');
    
    return List.generate(maps.length, (i) {
      return HorarioClase.fromMap(maps[i]);
    });
  }

  // Obtener clases del horario para un día específico
  Future<List<HorarioClase>> getHorarioClasesPorDia(String dia) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'horario',
      where: 'dia = ?',
      whereArgs: [dia],
      orderBy: 'horaInicio ASC',  // Ordenar por hora de inicio
    );
    
    return List.generate(maps.length, (i) {
      return HorarioClase.fromMap(maps[i]);
    });
  }

  // Actualizar una clase del horario
  Future<int> updateHorarioClase(HorarioClase clase) async {
    final db = await database;
    return await db.update(
      'horario',
      clase.toMap(),
      where: 'id = ?',
      whereArgs: [clase.id],
    );
  }

  // Eliminar una clase del horario
  Future<int> deleteHorarioClase(int id) async {
    final db = await database;
    return await db.delete(
      'horario',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Métodos CRUD para el Calendario

  // Insertar un nuevo evento en el calendario
  Future<int> insertEventoCalendario(CalendarioEvento evento) async {
    final db = await database;
    return await db.insert('calendario_eventos', evento.toMap());
  }

  // Obtener todos los eventos del calendario
  Future<List<CalendarioEvento>> getEventosCalendario() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('calendario_eventos');
    
    return List.generate(maps.length, (i) {
      return CalendarioEvento.fromMap(maps[i]);
    });
  }

  // Obtener eventos del calendario para una fecha específica
  Future<List<CalendarioEvento>> getEventosCalendarioPorFecha(DateTime fecha) async {
    final db = await database;
    final inicioDia = DateTime(fecha.year, fecha.month, fecha.day).millisecondsSinceEpoch;
    final finDia = DateTime(fecha.year, fecha.month, fecha.day, 23, 59, 59).millisecondsSinceEpoch;
    
    final List<Map<String, dynamic>> maps = await db.query(
      'calendario_eventos',
      where: 'fecha >= ? AND fecha <= ?',
      whereArgs: [inicioDia, finDia],
    );
    
    return List.generate(maps.length, (i) {
      return CalendarioEvento.fromMap(maps[i]);
    });
  }

  // Actualizar un evento del calendario
  Future<int> updateEventoCalendario(CalendarioEvento evento) async {
    final db = await database;
    return await db.update(
      'calendario_eventos',
      evento.toMap(),
      where: 'id = ?',
      whereArgs: [evento.id],
    );
  }

  // Eliminar un evento del calendario
  Future<int> deleteEventoCalendario(int id) async {
    final db = await database;
    return await db.delete(
      'calendario_eventos',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Método para verificar tablas existentes (diagnóstico)
  Future<List<String>> verificarTablasExistentes() async {
    final db = await database;
    final List<Map<String, dynamic>> tables = await db.rawQuery(
      "SELECT name FROM sqlite_master WHERE type='table'",
    );
    
    return tables.map((t) => t['name'] as String).toList();
  }

  // Inicializar la base de datos - dejarlo vacío para no crear datos de ejemplo
  Future<void> inicializarDatosEjemplo() async {
    try {
      print("Verificando base de datos");
      
      // Simplemente verificar que la conexión funciona correctamente
      final db = await database;
      var tables = await db.query('sqlite_master',
          where: 'type = ? AND (name = ? OR name = ?)',
          whereArgs: ['table', 'actividades', 'materias']);
      
      print("Base de datos funciona correctamente. Tablas encontradas: ${tables.length}");
      
    } catch (e) {
      print("Error al verificar la base de datos: $e");
      // No lanzamos la excepción para evitar interrumpir el inicio
    }
  }
}
