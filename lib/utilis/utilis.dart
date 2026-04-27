// Utility functions for file picking operations
// Provides helper methods to select audio and image files from the device
import 'dart:io';

import 'package:file_picker/file_picker.dart';

/// Opens the device file picker to select an audio file
/// Returns the selected File object or null if cancelled
Future<File?> pickAudio() async {
  try {
    final filePickerResults = await FilePicker.pickFiles(type: FileType.audio);
    if (filePickerResults != null) {
      return File(filePickerResults.files.first.xFile.path);
    }
    return null;
  } catch (e) {
    rethrow;
  }
}

/// Opens the device file picker to select an image file
/// Returns the selected File object or null if cancelled
Future<File?> pickImage() async {
  try {
    final filePickerResults = await FilePicker.pickFiles(type: FileType.image);
    if (filePickerResults != null) {
      return File(filePickerResults.files.first.xFile.path);
    }
    return null;
  } catch (e) {
    rethrow;
  }
}
