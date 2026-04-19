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
    extends $AsyncNotifierProvider<LocalSongsNotifier, List<LocalSongModel>> {
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
}

String _$localSongsNotifierHash() =>
    r'a2bcfb87d6cace95ba4bb11370d6a71d59f9c926';

abstract class _$LocalSongsNotifier
    extends $AsyncNotifier<List<LocalSongModel>> {
  FutureOr<List<LocalSongModel>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref
            as $Ref<AsyncValue<List<LocalSongModel>>, List<LocalSongModel>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<List<LocalSongModel>>,
                List<LocalSongModel>
              >,
              AsyncValue<List<LocalSongModel>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
