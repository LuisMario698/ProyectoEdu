import 'package:flutter/material.dart';

class ColorUtils {
  // Lista de 15 colores predefinidos para asignar a materias
  static const List<Color> materiasColors = [
    Color(0xFFD32F2F), // Rojo más fuerte
    Color(0xFF388E3C), // Verde más fuerte
    Color(0xFF1976D2), // Azul más fuerte
    Color(0xFFFBC02D), // Amarillo más fuerte
    Color(0xFF7B1FA2), // Púrpura más fuerte
    Color(0xFF00796B), // Verde azulado más fuerte
    Color(0xFFF4511E), // Naranja más fuerte
    Color(0xFF512DA8), // Morado más fuerte
    Color(0xFF0288D1), // Azul cielo más fuerte
    Color(0xFF689F38), // Lima más fuerte
    Color(0xFFEF6C00), // Naranja ámbar más fuerte
    Color(0xFFC2185B), // Rosa más fuerte
    Color(0xFF303F9F), // Índigo más fuerte
    Color(0xFF0097A7), // Cian más fuerte
    Color(0xFFE64A19), // Naranja pálido más fuerte
  ];

  // Obtener un color por su índice
  static Color getColorByIndex(int index) {
    return materiasColors[index % materiasColors.length];
  }

  // Obtener el índice de un color en la lista
  static int getIndexOfColor(Color color) {
    for (int i = 0; i < materiasColors.length; i++) {
      if (materiasColors[i].value == color.value) {
        return i;
      }
    }
    return -1; // No encontrado
  }

  // Verificar si un color ya está en uso
  static bool isColorInUse(List<int> usedColorIndices, int colorIndex) {
    return usedColorIndices.contains(colorIndex);
  }

  // Obtener el siguiente color disponible
  static int getNextAvailableColorIndex(List<int> usedColorIndices) {
    for (int i = 0; i < materiasColors.length; i++) {
      if (!usedColorIndices.contains(i)) {
        return i;
      }
    }
    return 0; // Si todos están usados, volver al primero
  }

  // Convertir un color a su representación hexadecimal
  static String colorToHex(Color color) {
    return '#${color.value.toRadixString(16).substring(2).toUpperCase()}';
  }

  // Obtener un color contrastante para texto
  static Color getTextColorForBackground(Color backgroundColor) {
    // Calcular la luminancia (0.0 - 1.0)
    final double luminance = backgroundColor.computeLuminance();
    // Usar texto oscuro en fondos claros y texto claro en fondos oscuros
    return luminance > 0.5 ? Colors.black : Colors.white;
  }
}