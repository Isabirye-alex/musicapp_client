// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_viewmodel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Riverpod notifier for authentication state management
/// Handles signup, signin, and session persistence

@ProviderFor(AuthViewmodel)
const authViewmodelProvider = AuthViewmodelProvider._();

/// Riverpod notifier for authentication state management
/// Handles signup, signin, and session persistence
final class AuthViewmodelProvider
    extends $NotifierProvider<AuthViewmodel, AsyncValue<UserModel?>?> {
  /// Riverpod notifier for authentication state management
  /// Handles signup, signin, and session persistence
  const AuthViewmodelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'authViewmodelProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$authViewmodelHash();

  @$internal
  @override
  AuthViewmodel create() => AuthViewmodel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<UserModel?>? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<UserModel?>?>(value),
    );
  }
}

String _$authViewmodelHash() => r'100e181953990a71addd3ecc62a277ee726ea6c9';

/// Riverpod notifier for authentication state management
/// Handles signup, signin, and session persistence

abstract class _$AuthViewmodel extends $Notifier<AsyncValue<UserModel?>?> {
  AsyncValue<UserModel?>? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref as $Ref<AsyncValue<UserModel?>?, AsyncValue<UserModel?>?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<UserModel?>?, AsyncValue<UserModel?>?>,
              AsyncValue<UserModel?>?,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
