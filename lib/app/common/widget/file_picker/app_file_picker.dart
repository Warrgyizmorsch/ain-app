import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class AppFilePickerHelper {
  AppFilePickerHelper._();

  /// Supported file extensions
  static const List<String> _defaultExtensions = [
    // Documents
    'pdf',
    'doc',
    'docx',
    'xls',
    'xlsx',
    'ppt',
    'pptx',
    'txt',
    'rtf',
    'csv',

    // Images
    'jpg',
    'jpeg',
    'png',
    'gif',
    'webp',
    'bmp',
    'heic',

    // Archives
    'zip',
    'rar',
    '7z',
    'tar',
    'gz',
  ];

  /// Pick multiple files
  static Future<List<File>> pickMultipleFiles({
    List<String>? customExtensions,
  }) async {
    try {
      final FilePickerResult? result = await FilePicker.pickFiles(
        allowMultiple: true,
        type: FileType.custom,
        allowedExtensions: customExtensions ?? _defaultExtensions,
      );

      if (result == null || result.files.isEmpty) {
        debugPrint(
          'ℹ️ [AppFilePickerHelper] User cancelled file selection.',
        );
        return [];
      }

      return result.files
          .where((file) => file.path != null)
          .map((file) => File(file.path!))
          .toList();
    } catch (e, stackTrace) {
      debugPrint(
        '❌ [AppFilePickerHelper] Error picking files: $e',
      );
      debugPrintStack(stackTrace: stackTrace);
      return [];
    }
  }

  /// Pick a single file
  static Future<File?> pickSingleFile({
    List<String>? customExtensions,
  }) async {
    try {
      final FilePickerResult? result = await FilePicker.pickFiles(
        allowMultiple: false,
        type: FileType.custom,
        allowedExtensions: customExtensions ?? _defaultExtensions,
      );

      if (result == null ||
          result.files.isEmpty ||
          result.files.first.path == null) {
        return null;
      }

      return File(result.files.first.path!);
    } catch (e, stackTrace) {
      debugPrint(
        '❌ [AppFilePickerHelper] Error picking file: $e',
      );
      debugPrintStack(stackTrace: stackTrace);
      return null;
    }
  }
}