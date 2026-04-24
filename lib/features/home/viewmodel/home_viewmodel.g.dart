// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_viewmodel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(getAllSongs)
const getAllSongsProvider = GetAllSongsProvider._();

final class GetAllSongsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<RemoteSongModel>>,
          List<RemoteSongModel>,
          FutureOr<List<RemoteSongModel>>
        >
    with
        $FutureModifier<List<RemoteSongModel>>,
        $FutureProvider<List<RemoteSongModel>> {
  const GetAllSongsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'getAllSongsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$getAllSongsHash();

  @$internal
  @override
  $FutureProviderElement<List<RemoteSongModel>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<RemoteSongModel>> create(Ref ref) {
    return getAllSongs(ref);
  }
}

String _$getAllSongsHash() => r'd7f804bfe6fc592ceaae285467a1386eb7fbb0c2';

@ProviderFor(getDeviceSongs)
const getDeviceSongsProvider = GetDeviceSongsProvider._();

final class GetDeviceSongsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<LocalSongModel>>,
          List<LocalSongModel>,
          FutureOr<List<LocalSongModel>>
        >
    with
        $FutureModifier<List<LocalSongModel>>,
        $FutureProvider<List<LocalSongModel>> {
  const GetDeviceSongsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'getDeviceSongsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$getDeviceSongsHash();

  @$internal
  @override
  $FutureProviderElement<List<LocalSongModel>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<LocalSongModel>> create(Ref ref) {
    return getDeviceSongs(ref);
  }
}

String _$getDeviceSongsHash() => r'5b5e35a807b1de5fcf36da95ae66cc38ab778810';

@ProviderFor(getAllPlatformSongs)
const getAllPlatformSongsProvider = GetAllPlatformSongsProvider._();

final class GetAllPlatformSongsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<RemoteSongModel>>,
          List<RemoteSongModel>,
          FutureOr<List<RemoteSongModel>>
        >
    with
        $FutureModifier<List<RemoteSongModel>>,
        $FutureProvider<List<RemoteSongModel>> {
  const GetAllPlatformSongsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'getAllPlatformSongsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$getAllPlatformSongsHash();

  @$internal
  @override
  $FutureProviderElement<List<RemoteSongModel>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<RemoteSongModel>> create(Ref ref) {
    return getAllPlatformSongs(ref);
  }
}

String _$getAllPlatformSongsHash() =>
    r'c0f40f3d57f3a23b99101e7b332e96134d3bbc31';

@ProviderFor(HomeViewmodel)
const homeViewmodelProvider = HomeViewmodelProvider._();

final class HomeViewmodelProvider
    extends
        $NotifierProvider<HomeViewmodel, AsyncValue<List<RemoteSongModel>>> {
  const HomeViewmodelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'homeViewmodelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$homeViewmodelHash();

  @$internal
  @override
  HomeViewmodel create() => HomeViewmodel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<List<RemoteSongModel>> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<List<RemoteSongModel>>>(
        value,
      ),
    );
  }
}

String _$homeViewmodelHash() => r'2e40564643178e7734669f496f4a25eea4fbcbae';

abstract class _$HomeViewmodel
    extends $Notifier<AsyncValue<List<RemoteSongModel>>> {
  AsyncValue<List<RemoteSongModel>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref
            as $Ref<
              AsyncValue<List<RemoteSongModel>>,
              AsyncValue<List<RemoteSongModel>>
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<List<RemoteSongModel>>,
                AsyncValue<List<RemoteSongModel>>
              >,
              AsyncValue<List<RemoteSongModel>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
