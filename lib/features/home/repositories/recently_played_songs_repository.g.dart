// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recently_played_songs_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(recentlyPlayedSongsRespostory)
const recentlyPlayedSongsRespostoryProvider =
    RecentlyPlayedSongsRespostoryProvider._();

final class RecentlyPlayedSongsRespostoryProvider
    extends
        $FunctionalProvider<
          RecentlyPlayedSongsRepository,
          RecentlyPlayedSongsRepository,
          RecentlyPlayedSongsRepository
        >
    with $Provider<RecentlyPlayedSongsRepository> {
  const RecentlyPlayedSongsRespostoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'recentlyPlayedSongsRespostoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$recentlyPlayedSongsRespostoryHash();

  @$internal
  @override
  $ProviderElement<RecentlyPlayedSongsRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  RecentlyPlayedSongsRepository create(Ref ref) {
    return recentlyPlayedSongsRespostory(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RecentlyPlayedSongsRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RecentlyPlayedSongsRepository>(
        value,
      ),
    );
  }
}

String _$recentlyPlayedSongsRespostoryHash() =>
    r'2b2a969f11c4a88bee2c6a38b6433e4cbe9fac26';
