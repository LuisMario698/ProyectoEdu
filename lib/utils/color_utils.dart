import 'package:flutter/material.dart';

class ColorUtils {
  // Lista de 15 colores predefinidos para asignar a materias
  static const List<Color> materiasColors = [
    Color(0xFFE57373), // Rojo claro
    Color(0xFF81C784), // Verde claro
    Color(0xFF64B5F6), // Azul claro
    Color(0xFFFFD54F), // Amarillo ámbar
    Color(0xFFBA68C8), // Púrpura claro
    Color(0xFF4DB6AC), // Verde azulado
    Color(0xFFFF8A65), // Naranja claro
    Color(0xFF9575CD), // Morado claro
    Color(0xFF4FC3F7), // Azul cielo
    Color(0xFFAED581), // Lima claro
    Color(0xFFFFB74D), // Naranja ámbar
    Color(0xFFF06292), // Rosa claro
    Color(0xFF7986CB), // Índigo claro
    Color(0xFF4DD0E1), // Cian claro
    Color(0xFFFFCC80), // Naranja pálido
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