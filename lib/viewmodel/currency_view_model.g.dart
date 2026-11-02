// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'currency_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(currencyService)
final currencyServiceProvider = CurrencyServiceProvider._();

final class CurrencyServiceProvider
    extends
        $FunctionalProvider<CurrencyService, CurrencyService, CurrencyService>
    with $Provider<CurrencyService> {
  CurrencyServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currencyServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currencyServiceHash();

  @$internal
  @override
  $ProviderElement<CurrencyService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  CurrencyService create(Ref ref) {
    return currencyService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CurrencyService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CurrencyService>(value),
    );
  }
}

String _$currencyServiceHash() => r'270dc9d29d1ba050130107b38169df699371efa6';

@ProviderFor(CurrencyViewModel)
final currencyViewModelProvider = CurrencyViewModelProvider._();

final class CurrencyViewModelProvider
    extends $AsyncNotifierProvider<CurrencyViewModel, String> {
  CurrencyViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currencyViewModelProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currencyViewModelHash();

  @$internal
  @override
  CurrencyViewModel create() => CurrencyViewModel();
}

String _$currencyViewModelHash() => r'765897c89b4ccc4355d665632b8851276e6b80a7';

abstract class _$CurrencyViewModel extends $AsyncNotifier<String> {
  FutureOr<String> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<String>, String>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<String>, String>,
              AsyncValue<String>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
