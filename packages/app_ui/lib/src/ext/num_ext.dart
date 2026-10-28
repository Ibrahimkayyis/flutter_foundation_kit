import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

extension NTIUINumExt on num {
  EdgeInsets get topPadding {
    return EdgeInsets.only(top: toDouble());
  }

  EdgeInsets get leftPadding {
    return EdgeInsets.only(left: toDouble());
  }

  EdgeInsets get rightPadding {
    return EdgeInsets.only(right: toDouble());
  }

  EdgeInsets get bottomPadding {
    return EdgeInsets.only(bottom: toDouble());
  }

  EdgeInsets get verticalPadding {
    return EdgeInsets.symmetric(vertical: toDouble());
  }

  EdgeInsets get horizontalPadding {
    return EdgeInsets.symmetric(horizontal: toDouble());
  }

  EdgeInsets get allPadding {
    return EdgeInsets.all(toDouble());
  }
}

extension NumTupleExt on (num, num) {
  EdgeInsets get padding {
    return EdgeInsets.symmetric(
      horizontal: $1.toDouble(),
      vertical: $2.toDouble(),
    );
  }

  Size get size => Size($1.toDouble(), $2.toDouble());
}

extension NumTripletExt on (num, num, num) {
  EdgeInsets get padding {
    return EdgeInsets.fromLTRB($1.toDouble(), $2.toDouble(), $3.toDouble(), 0);
  }
}

extension NumQuadrupleExt on (num, num, num, num) {
  EdgeInsets get padding {
    return EdgeInsets.fromLTRB(
      $1.toDouble(),
      $2.toDouble(),
      $3.toDouble(),
      $4.toDouble(),
    );
  }
}

extension CurrencyExt on num {
  String toCurrency({String locale = 'id_ID', String symbol = 'Rp'}) {
    final format = NumberFormat.currency(
      locale: locale,
      symbol: symbol,
      decimalDigits:
          toInt() == this
              ? 0
              : 1, // Use 0 decimals for whole numbers, 1 for decimals
    );
    return format.format(toDouble());
  }
}
