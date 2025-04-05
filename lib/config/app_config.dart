import 'package:flutter/material.dart';

/// Clase para configuración global de la aplicación
class AppConfig {
  // Singleton
  static final AppConfig _instance = AppConfig._internal();
  factory AppConfig() => _instance;
  AppConfig._internal();

  // Estado de la aplicación
  bool isStorageInitialized = false;
  String storageType = "No inicializado";

  // Modo depuración
  bool debugMode = true;

  // Mensajes de diagnóstico
  List<String> diagnosticMessages = [];

  // Añadir mensaje de diagnóstico
  void addDiagnosticMessage(String message) {
    if (debugMode) {
      debugPrint('🔍 $message');
      diagnosticMessages.add('[${DateTime.now().toIso8601String()}] $message');

      // Mantener una longitud máxima de 100 mensajes
      if (diagnosticMessages.length > 100) {
        diagnosticMessages.removeRange(0, diagnosticMessages.length - 100);
      }
    }
  }

  // Establecer el tipo de almacenamiento
  void setStorageType(String type) {
    storageType = type;
    addDiagnosticMessage('Tipo de almacenamiento establecido: $type');
  }

  // Inicializar la configuración
  Future<void> initialize(dynamic storageService) async {
    addDiagnosticMessage('Inicializando AppConfig');
    isStorageInitialized = true;
    setStorageType('SimpleStorage');
  }

  // Obtener información de diagnóstico
  String getDiagnosticSummary() {
    return '''
    🔍 Diagnóstico de la Aplicación:
    - Almacenamiento inicializado: $isStorageInitialized
    - Tipo de almacenamiento: $storageType
    - Modo depuración: $debugMode
    - Últimos mensajes: 
      ${diagnosticMessages.reversed.take(5).map((m) => '\n      $m').join('')}
    ''';
  }
}
