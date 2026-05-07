// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_viewmodel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

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

String _$homeViewmodelHash() => r'd31780eb76176905a2f264f0de9ce665018c0680';

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
