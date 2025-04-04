import 'package:flutter/material.dart';

class MyColors {
  // Paleta principal de la aplicación
  static const Color lightGrey = Color(0xFFE6E6E6);
  static const Color paleBlue = Color(0xFFDFEBF7);
  static const Color lightBlueGrey = Color(0xFFA9C7D7);
  static const Color mediumBlueGrey = Color(0xFF768B96);
  static const Color darkBlueGrey = Color(0xFF44576D);
  static const Color darkestBlue = Color(0xFF28353D);
  
  // Colores funcionales basados en la paleta
  static const Color background = lightGrey;
  static const Color surface = paleBlue;
  static const Color primary = darkBlueGrey;
  static const Color secondary = mediumBlueGrey;
  static const Color accent = lightBlueGrey;
  
  // Colores para texto
  static const Color textOnLight = darkestBlue;
  static const Color textOnDark = paleBlue;
  
  // Colores de estado
  static const Color success = Color(0xFF4CAF50);
  static const Color error = Color(0xFFF44336);
  static const Color warning = Color(0xFFFF9800);
  static const Color info = darkBlueGrey;
  
  // Mapa de colores para materias
  static const Map<String, Color> materiasColors = {
    'Matemáticas': darkBlueGrey,
    'Historia': Color(0xFF5D4037),
    'Ciencias': Color(0xFF2E7D32),
    'Inglés': Color(0xFF1565C0),
    'Física': Color(0xFF6A1B9A),
    'Química': Color(0xFF00695C),
    'Literatura': Color(0xFF6D4C41),
  };
  
  // Variantes de opacidad
  static Color withOpacity(Color color, double opacity) {
    return color.withOpacity(opacity);
  }
  
  // Gradientes comunes
  static LinearGradient get primaryGradient => LinearGradient(
    colors: [darkBlueGrey, darkestBlue],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static LinearGradient get secondaryGradient => LinearGradient(
    colors: [mediumBlueGrey, darkBlueGrey],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
