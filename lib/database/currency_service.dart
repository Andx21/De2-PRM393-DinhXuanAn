import 'package:shared_preferences/shared_preferences.dart';

class CurrencyService {
  static const String currencyKey = 'currency';
  Future<String> getCurrency() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getString(currencyKey) ?? 'VND';
  }
  Future<void> saveCurrency(String currency) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(currencyKey, currency);
  }
}