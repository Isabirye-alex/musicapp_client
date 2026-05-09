import 'dart:io';
import 'dart:isolate';
import 'dart:ui';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:media_scanner/media_scanner.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

@pragma('vm:entry-point')
void downloadCallback(String id, int status, int progress) {
  // status 3 = complete
  if (status == 3) {
    // send to main isolate via port — don't touch any plugin here
    IsolateNameServer.lookupPortByName('downloader_port')?.send(id);
  }
}

class DownloadService {
  static final ReceivePort _port = ReceivePort();

  static Future<void> init() async {
    await FlutterDownloader.initialize(debug: false);

    // register the port so callback can find it
    IsolateNameServer.registerPortWithName(_port.sendPort, 'downloader_port');

    // listen on main isolate — safe to use plugins here
    _port.listen((taskId) async {
      final tasks = await FlutterDownloader.loadTasksWithRawQuery(
        query: "SELECT * FROM task WHERE task_id='$taskId'",
      );
      if (tasks != null && tasks.isNotEmpty) {
        final task = tasks.first;
        final filePath = '${task.savedDir}/${task.filename}';
        await MediaScanner.loadMedia(path: filePath);
      }
    });

    FlutterDownloader.registerCallback(downloadCallback);
  }

  static Future<String> get _downloadDir async {
    if (Platform.isAndroid) {
      final dir = Directory('/storage/emulated/0/Music');
      if (!await dir.exists()) await dir.create(recursive: true);
      return dir.path;
    }
    final dir = await getApplicationDocumentsDirectory();
    return dir.path;
  }

  static Future<bool> _requestPermission() async {
    if (Platform.isAndroid) {
      // Android 13+
      if (await Permission.audio.isGranted) return true;
      final audio = await Permission.audio.request();
      if (audio.isGranted) return true;

      // Android < 13
      final storage = await Permission.storage.request();
      return storage.isGranted;
    }
    return true;
  }

  static String _safeName(String songName) =>
      songName.replaceAll(RegExp(r'[\\/:*?"<>|]'), '_');

  static Future<bool> downloadSong({
    required String songId,
    required String songUrl,
    required String songName,
  }) async {
    final hasPermission = await _requestPermission();
    if (!hasPermission) return false;

    final dir = await _downloadDir;
    final taskId = await FlutterDownloader.enqueue(
      url: songUrl,
      savedDir: dir,
      fileName: '${_safeName(songName)}.mp3',
      showNotification: true,
      openFileFromNotification: false,
      saveInPublicStorage: true,
    );
    return taskId != null;
  }

  static Future<bool> isSongDownloaded(String songName) async {
    final dir = await _downloadDir;
    return File('$dir/${_safeName(songName)}.mp3').exists();
  }

  static Future<void> deleteSong(String songName) async {
    final dir = await _downloadDir;
    final file = File('$dir/${_safeName(songName)}.mp3');
    if (await file.exists()) await file.delete();
  }

  // call this when app is disposed to clean up
  static void dispose() {
    IsolateNameServer.removePortNameMapping('downloader_port');
    _port.close();
  }
}
