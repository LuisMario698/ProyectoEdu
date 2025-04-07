import 'package:flutter/material.dart';
import 'views/desktop/home_desktop.dart';
import 'views/mobile/home_mobile.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:proyectoeducativo/conexion/db.dart'; // Importar DatabaseHelper

void main() async {
  // Asegurar que los widgets Flutter estén inicializados
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializar la base de datos y cargar datos de ejemplo si es necesario
  final dbHelper = DatabaseHelper();
  try {
    await dbHelper.inicializarDatosEjemplo();
  } catch (e) {
    print("Error al inicializar la base de datos: $e");
    // No detenemos la aplicación si hay un error, pero lo registramos
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Equipos',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const TeamsScreen(),
    );
  }
}

class TeamsScreen extends StatelessWidget {
  const TeamsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, sizingInformation) {
        if (sizingInformation.deviceScreenType == DeviceScreenType.mobile) {
          return const HomeMobile();
        } else {
          return const HomeDesktop();
        }
      },
    );
  }
}
