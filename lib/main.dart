import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'services/file_storage.dart';
import 'views/mobile/home_mobile.dart';
import 'views/desktop/home_desktop.dart';

// La instancia global del almacenamiento
late FileStorage fileStorage;

void main() async {
  // Asegurarse de que las dependencias de Flutter estén inicializadas
  WidgetsFlutterBinding.ensureInitialized();
  
  // Configurar la orientación de la pantalla
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  
  // Inicializar el almacenamiento
  fileStorage = FileStorage();
  
  try {
    // Inicializar el servicio
    await fileStorage.initialize();
    debugPrint('✅ Archivo de almacenamiento inicializado correctamente');
  } catch (e) {
    debugPrint('❌ Error al inicializar almacenamiento: $e');
  }
  
  // Ahora podemos ejecutar la aplicación
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
