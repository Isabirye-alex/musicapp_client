// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'token_register_viewmodel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(TokenRegisterViewmodel)
const tokenRegisterViewmodelProvider = TokenRegisterViewmodelProvider._();

final class TokenRegisterViewmodelProvider
    extends $NotifierProvider<TokenRegisterViewmodel, AsyncValue<bool>> {
  const TokenRegisterViewmodelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'tokenRegisterViewmodelProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$tokenRegisterViewmodelHash();

  @$internal
  @override
  TokenRegisterViewmodel create() => TokenRegisterViewmodel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<bool> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<bool>>(value),
    );
  }
}

String _$tokenRegisterViewmodelHash() =>
    r'afbb66c5df5db90b31d551fefbd5db643c6b7b7b';

abstract class _$TokenRegisterViewmodel extends $Notifier<AsyncValue<bool>> {
  AsyncValue<bool> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<bool>, AsyncValue<bool>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<bool>, AsyncValue<bool>>,
              AsyncValue<bool>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
