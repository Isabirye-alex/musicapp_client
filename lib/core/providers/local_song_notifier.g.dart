// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'local_song_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(LocalSongsNotifier)
const localSongsProvider = LocalSongsNotifierProvider._();

final class LocalSongsNotifierProvider
    extends
        $NotifierProvider<
          LocalSongsNotifier,
          AsyncValue<List<LocalSongModel>>
        > {
  const LocalSongsNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'localSongsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$localSongsNotifierHash();

  @$internal
  @override
  LocalSongsNotifier create() => LocalSongsNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<List<LocalSongModel>> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<List<LocalSongModel>>>(
        value,
      ),
    );
  }
}

String _$localSongsNotifierHash() =>
    r'c6eb158b53b122e423fcee798bfb7a481e729ec4';

abstract class _$LocalSongsNotifier
    extends $Notifier<AsyncValue<List<LocalSongModel>>> {
  AsyncValue<List<LocalSongModel>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref
            as $Ref<
              AsyncValue<List<LocalSongModel>>,
              AsyncValue<List<LocalSongModel>>
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<List<LocalSongModel>>,
                AsyncValue<List<LocalSongModel>>
              >,
              AsyncValue<List<LocalSongModel>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
