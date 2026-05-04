// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_songs_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(UserSongsNotifier)
const userSongsProvider = UserSongsNotifierProvider._();

final class UserSongsNotifierProvider
    extends
        $NotifierProvider<
          UserSongsNotifier,
          AsyncValue<List<RemoteSongModel>>
        > {
  const UserSongsNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'userSongsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$userSongsNotifierHash();

  @$internal
  @override
  UserSongsNotifier create() => UserSongsNotifier();

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

String _$userSongsNotifierHash() => r'a5ccecce18f043e1580d05a6472783b42e3e5624';

abstract class _$UserSongsNotifier
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
