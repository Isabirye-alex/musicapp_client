
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:fpdart/fpdart.dart';

Future<File?> pickAudio() async {
  try {
    final filePickerResults = await FilePicker.pickFiles(
      type: FileType.audio
    );
    if (filePickerResults != null){
      return File(filePickerResults.files.first.xFile.path);
    }
    return null;
  } catch (e) {
    rethrow;
  }
}


Future<File?> pickImage() async {
  try {
    final filePickerResults = await FilePicker.pickFiles(
        type: FileType.image
    );
    if (filePickerResults != null){
      return File(filePickerResults.files.first.xFile.path);
    }
    return null;
  } catch (e) {
    rethrow;
  }
}