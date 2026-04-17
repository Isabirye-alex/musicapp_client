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
    extends $NotifierProvider<HomeViewmodel, AsyncValue<SongModel?>?> {
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
  Override overrideWithValue(AsyncValue<SongModel?>? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<SongModel?>?>(value),
    );
  }
}

String _$homeViewmodelHash() => r'ccd1a0dedd53da8e110f118912c6cef1f5502806';

abstract class _$HomeViewmodel extends $Notifier<AsyncValue<SongModel?>?> {
  AsyncValue<SongModel?>? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref as $Ref<AsyncValue<SongModel?>?, AsyncValue<SongModel?>?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<SongModel?>?, AsyncValue<SongModel?>?>,
              AsyncValue<SongModel?>?,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
