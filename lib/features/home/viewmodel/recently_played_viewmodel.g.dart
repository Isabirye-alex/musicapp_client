// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recently_played_viewmodel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(RecentlyPlayedViewmodel)
const recentlyPlayedViewmodelProvider = RecentlyPlayedViewmodelProvider._();

final class RecentlyPlayedViewmodelProvider
    extends
        $NotifierProvider<
          RecentlyPlayedViewmodel,
          AsyncValue<List<RemoteSongModel>>
        > {
  const RecentlyPlayedViewmodelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'recentlyPlayedViewmodelProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$recentlyPlayedViewmodelHash();

  @$internal
  @override
  RecentlyPlayedViewmodel create() => RecentlyPlayedViewmodel();

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

String _$recentlyPlayedViewmodelHash() =>
    r'f19671e9d320aefe5fc9188d38757b3eec599f16';

abstract class _$RecentlyPlayedViewmodel
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
