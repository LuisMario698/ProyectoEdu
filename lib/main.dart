import 'package:flutter/material.dart';
import 'views/desktop/home_desktop.dart';
import 'package:proyectoeducativo/widgetsDesktop/login.dart';

// para actividades escritorio
// para materias escritorio




void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Equipos',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const LoginPage(),

    );
  }
}

class TeamsScreen extends StatelessWidget {
  const TeamsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    /*
    return ResponsiveBuilder(
      builder: (context, sizingInformation) {
        if (sizingInformation.deviceScreenType == DeviceScreenType.mobile) {
          return const HomeMobile();
        } else {
          return const HomeDesktop();
        }
      },
      */
    //return const HomeMobile();
    return const HomeDesktop();
  }
}
