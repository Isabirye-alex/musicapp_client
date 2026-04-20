import 'package:file_picker/file_picker.dart';
import 'package:little_music/features/home/models/local_song_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'local_songs_repository.g.dart';

@riverpod
LocalSongsRepository localSongsRepository(Ref ref) {
  return LocalSongsRepository();
}

class LocalSongsRepository {
  Future<List<LocalSongModel>> pickSongs() async {
    final result = await FilePicker.pickFiles(
      // ✅ no .platform
      type: FileType.audio,
      allowMultiple: true,
    );

    if (result == null) return [];

    return result.files
        .where((f) => f.path != null)
        .map(
          (f) => LocalSongModel(
            id: f.identifier ?? f.name,
            title: f.name.replaceAll(RegExp(r'\.[^.]+$'), ''),
            artist: 'Unknown Artist',
            path: f.path!,
            duration: 0,
          ),
        )
        .toList();
  }
}
