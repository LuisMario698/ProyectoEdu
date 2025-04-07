import 'package:flutter/material.dart';
import 'package:proyectoeducativo/views/desktop/home_desktop.dart';
import 'package:proyectoeducativo/views/mobile/home_mobile.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:proyectoeducativo/views/mobile/configuracion_page.dart';
import 'package:proyectoeducativo/utils/mycolorplantilla.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Plataforma Educativa',
      theme: themeProvider.themeData,
      home: const TeamsScreen(),
    );
  }
}

class TeamsScreen extends StatelessWidget {
  const TeamsScreen({Key? key}) : super(key: key);

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
