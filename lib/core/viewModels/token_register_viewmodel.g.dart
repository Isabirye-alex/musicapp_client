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
    extends $NotifierProvider<TokenRegisterViewmodel, AsyncValue<TokenModel?>> {
  const TokenRegisterViewmodelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'tokenRegisterViewmodelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$tokenRegisterViewmodelHash();

  @$internal
  @override
  TokenRegisterViewmodel create() => TokenRegisterViewmodel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<TokenModel?> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<TokenModel?>>(value),
    );
  }
}

String _$tokenRegisterViewmodelHash() =>
    r'0d61bdbd02a2824658d1c595149f7d22d1706e31';

abstract class _$TokenRegisterViewmodel
    extends $Notifier<AsyncValue<TokenModel?>> {
  AsyncValue<TokenModel?> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref as $Ref<AsyncValue<TokenModel?>, AsyncValue<TokenModel?>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<TokenModel?>, AsyncValue<TokenModel?>>,
              AsyncValue<TokenModel?>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
