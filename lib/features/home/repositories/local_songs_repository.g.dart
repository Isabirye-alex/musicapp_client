// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'local_songs_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(localSongsRepository)
const localSongsRepositoryProvider = LocalSongsRepositoryProvider._();

final class LocalSongsRepositoryProvider
    extends
        $FunctionalProvider<
          LocalSongsRepository,
          LocalSongsRepository,
          LocalSongsRepository
        >
    with $Provider<LocalSongsRepository> {
  const LocalSongsRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'localSongsRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$localSongsRepositoryHash();

  @$internal
  @override
  $ProviderElement<LocalSongsRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  LocalSongsRepository create(Ref ref) {
    return localSongsRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LocalSongsRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LocalSongsRepository>(value),
    );
  }
}

String _$localSongsRepositoryHash() =>
    r'd27b0d366c78a323a01761e48fb45f6d88fadb6a';
