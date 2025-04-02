import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'views/mobile/home_mobile.dart';
import 'views/desktop/home_desktop.dart';

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
      home: const TeamsScreen(),
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
    return const HomeMobile();
  }
}
