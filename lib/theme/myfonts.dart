import 'package:flutter/material.dart';

class MyFonts {
  // Nombres de las fuentes
  static const String primaryFont = 'Roboto';
  static const String secondaryFont = 'Montserrat';
  static const String accentFont = 'Poppins';
  static const String logoFont = 'RobotoSlab';
  
  // Estilos de texto para encabezados
  static const TextStyle heading1 = TextStyle(
    fontFamily: primaryFont,
    fontSize: 32.0,
    fontWeight: FontWeight.bold,
    letterSpacing: -1.5,
  );
  
  static const TextStyle heading2 = TextStyle(
    fontFamily: primaryFont,
    fontSize: 26.0,
    fontWeight: FontWeight.bold,
    letterSpacing: -0.5,
  );
  
  static const TextStyle heading3 = TextStyle(
    fontFamily: primaryFont,
    fontSize: 22.0,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.0,
  );
  
  static const TextStyle heading4 = TextStyle(
    fontFamily: secondaryFont,
    fontSize: 20.0,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.25,
  );
  
  // Estilos de texto para el cuerpo
  static const TextStyle bodyLarge = TextStyle(
    fontFamily: primaryFont,
    fontSize: 16.0,
    fontWeight: FontWeight.normal,
    letterSpacing: 0.5,
  );
  
  static const TextStyle bodyMedium = TextStyle(
    fontFamily: primaryFont,
    fontSize: 14.0,
    fontWeight: FontWeight.normal,
    letterSpacing: 0.25,
  );
  
  static const TextStyle bodySmall = TextStyle(
    fontFamily: primaryFont,
    fontSize: 12.0,
    fontWeight: FontWeight.normal,
    letterSpacing: 0.4,
  );
  
  // Estilos para botones y labels
  static const TextStyle buttonText = TextStyle(
    fontFamily: secondaryFont,
    fontSize: 14.0,
    fontWeight: FontWeight.w500,
    letterSpacing: 1.25,
  );
  
  static const TextStyle captionText = TextStyle(
    fontFamily: primaryFont,
    fontSize: 12.0,
    fontWeight: FontWeight.normal,
    letterSpacing: 0.4,
  );
  
  static const TextStyle overlineText = TextStyle(
    fontFamily: primaryFont,
    fontSize: 10.0,
    fontWeight: FontWeight.normal,
    letterSpacing: 1.5,
  );
  
  // Estilos para tarjetas de materias
  static const TextStyle cardTitle = TextStyle(
    fontFamily: secondaryFont,
    fontSize: 18.0,
    fontWeight: FontWeight.bold,
    letterSpacing: 0.15,
  );
  
  static const TextStyle cardSubtitle = TextStyle(
    fontFamily: secondaryFont,
    fontSize: 14.0,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.1,
  );
  
  // Estilos para la interfaz de calendario
  static const TextStyle calendarHeader = TextStyle(
    fontFamily: accentFont,
    fontSize: 16.0,
    fontWeight: FontWeight.bold,
    letterSpacing: 0.2,
  );
  
  static const TextStyle calendarDay = TextStyle(
    fontFamily: accentFont,
    fontSize: 14.0,
    fontWeight: FontWeight.normal,
  );
  
  // Método para obtener la fuente con peso dinámico
  static TextStyle getFont({
    String fontFamily = primaryFont,
    double fontSize = 14.0,
    FontWeight fontWeight = FontWeight.normal,
    double letterSpacing = 0.0,
    Color color = Colors.black,
  }) {
    return TextStyle(
      fontFamily: fontFamily,
      fontSize: fontSize,
      fontWeight: fontWeight,
      letterSpacing: letterSpacing,
      color: color,
    );
  }
}
