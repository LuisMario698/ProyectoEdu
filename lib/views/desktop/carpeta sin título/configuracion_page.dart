import 'package:flutter/material.dart';
import 'package:proyectoeducativo/utils/mycolorplantilla.dart';
import 'package:provider/provider.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeData _themeData =
      MyColorThemes.modernTheme; // Tema moderno como predeterminado

  ThemeData get themeData => _themeData;

  set themeData(ThemeData theme) {
    _themeData = theme;
    notifyListeners();
  }
}

class ConfiguracionPage extends StatelessWidget {
  const ConfiguracionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Configuración')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Selecciona un tema:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ListTile(
              title: const Text('Tema Claro'),
              leading: Radio<ThemeData>(
                value: MyColorThemes.lightTheme,
                groupValue: themeProvider.themeData,
                onChanged: (ThemeData? value) {
                  if (value != null) {
                    themeProvider.themeData = value;
                  }
                },
              ),
            ),
            ListTile(
              title: const Text('Tema Oscuro'),
              leading: Radio<ThemeData>(
                value: MyColorThemes.darkTheme,
                groupValue: themeProvider.themeData,
                onChanged: (ThemeData? value) {
                  if (value != null) {
                    themeProvider.themeData = value;
                  }
                },
              ),
            ),
            ListTile(
              title: const Text('Tema Vibrante'),
              leading: Radio<ThemeData>(
                value: MyColorThemes.vibrantTheme,
                groupValue: themeProvider.themeData,
                onChanged: (ThemeData? value) {
                  if (value != null) {
                    themeProvider.themeData = value;
                  }
                },
              ),
            ),
            ListTile(
              title: const Text('Tema Moderno'),
              leading: Radio<ThemeData>(
                value: MyColorThemes.modernTheme,
                groupValue: themeProvider.themeData,
                onChanged: (ThemeData? value) {
                  if (value != null) {
                    themeProvider.themeData = value;
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
