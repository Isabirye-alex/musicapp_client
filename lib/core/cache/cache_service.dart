import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:little_music/features/auth/model/user_model.dart';
import 'package:little_music/features/home/models/sealed_model_class.dart';

class CacheService {
  static SharedPreferences? _prefs;

  static const _songsKey = 'cached_songs';
  static const _userKey = 'cached_user';
  static const _userSongsKey = 'cached_user_songs';

  // ── Call once in main.dart before runApp ──
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  SharedPreferences get _p {
    if (_prefs == null) {
      throw Exception('CacheService.init() must be called before use');
    }
    return _prefs!;
  }

  // ─── Platform Songs ───────────────────────
  void cacheSongs(List<RemoteSongModel> songs) {
    final encoded = jsonEncode(songs.map((s) => s.toJson()).toList());
    _p.setString(_songsKey, encoded);
  }

  List<RemoteSongModel> getCachedSongs() {
    final raw = _p.getString(_songsKey);
    if (raw == null) return [];
    final List decoded = jsonDecode(raw);
    return decoded
        .map((s) => RemoteSongModel.fromJson(s as Map<String, dynamic>))
        .toList();
  }

  // ─── User Songs ───────────────────────────
  void cacheUserSongs(List<RemoteSongModel> songs) {
    final encoded = jsonEncode(songs.map((s) => s.toJson()).toList());
    _p.setString(_userSongsKey, encoded);
  }

  List<RemoteSongModel> getCachedUserSongs() {
    final raw = _p.getString(_userSongsKey);
    if (raw == null) return [];
    final List decoded = jsonDecode(raw);
    return decoded
        .map((s) => RemoteSongModel.fromJson(s as Map<String, dynamic>))
        .toList();
  }

  //User
  void cacheUser(UserModel user) {
    _p.setString(_userKey, jsonEncode(user.toJson()));
  }

  UserModel? getCachedUser() {
    final raw = _p.getString(_userKey);
    if (raw == null) return null;
    return UserModel.fromJson(jsonDecode(raw));
  }

  void clearAll() {
    _p.remove(_songsKey);
    _p.remove(_userKey);
    _p.remove(_userSongsKey);
  }
}