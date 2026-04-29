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
        isAutoDispose: false,
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

String _$getAllSongsHash() => r'031d07064381e2406332cecc002d7192804eb6a8';

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
        isAutoDispose: false,
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

String _$homeViewmodelHash() => r'825d323387297402c6ddb56f72fbef5f8b942601';

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
