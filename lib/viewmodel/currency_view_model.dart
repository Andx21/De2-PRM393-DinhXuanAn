import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../database//currency_service.dart';

part 'currency_view_model.g.dart';

@riverpod
CurrencyService currencyService(Ref ref) {
  return CurrencyService();
}

@Riverpod(keepAlive: true)
class CurrencyViewModel extends _$CurrencyViewModel {
  @override
  Future<String> build() async {
    final service = ref.watch(currencyServiceProvider);

    return service.getCurrency();
  }

  Future<void> changeCurrency(String currency) async {
    final service = ref.read(currencyServiceProvider);

    await service.saveCurrency(currency);

    state = AsyncData(currency);
  }
}