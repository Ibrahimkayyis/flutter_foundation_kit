import 'package:intl/intl.dart';

extension NumExt on num {
  String currencyFormat({String symbol = "Rp. ", String locale = "id_ID"}) {
    final currencyFormater = NumberFormat.currency(
      locale: locale,
      symbol: symbol,
      decimalDigits: 0,
    );
    return currencyFormater.format(this);
  }
}
