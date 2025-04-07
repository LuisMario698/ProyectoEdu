import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

/// Servicio para seleccionar archivos de imagen usando image_picker
/// Reemplaza la funcionalidad de file_picker para evitar problemas de compatibilidad
class FileService {
  static final FileService _instance = FileService._internal();
  final ImagePicker _picker = ImagePicker();

  factory FileService() {
    return _instance;
  }

  FileService._internal();

  /// Selecciona una imagen de la galería
  /// Retorna el archivo seleccionado o null si se canceló la selección
  Future<File?> pickImage({bool fromCamera = false}) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: fromCamera ? ImageSource.camera : ImageSource.gallery,
      );
      
      if (image != null) {
        return File(image.path);
      }
      return null;
    } catch (e) {
      debugPrint('Error al seleccionar imagen: $e');
      return null;
    }
  }

  /// Selecciona múltiples imágenes de la galería
  /// Retorna una lista de archivos seleccionados o una lista vacía si se canceló
  Future<List<File>> pickMultipleImages() async {
    try {
      final List<XFile> images = await _picker.pickMultiImage();
      return images.map((image) => File(image.path)).toList();
    } catch (e) {
      debugPrint('Error al seleccionar múltiples imágenes: $e');
      return [];
    }
  }

  /// Selecciona un video de la galería
  /// Retorna el archivo seleccionado o null si se canceló la selección
  Future<File?> pickVideo({bool fromCamera = false}) async {
    try {
      final XFile? video = await _picker.pickVideo(
        source: fromCamera ? ImageSource.camera : ImageSource.gallery,
      );
      
      if (video != null) {
        return File(video.path);
      }
      return null;
    } catch (e) {
      debugPrint('Error al seleccionar video: $e');
      return null;
    }
  }
}