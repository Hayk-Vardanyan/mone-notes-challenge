import 'dart:core';

import 'extensions.dart';

extension NumExtension on num {
  bool get isEven => this % 2 == 0;

  bool get isOdd => this % 2 != 0;

  String toCurrency({String symbol = '', String locale = 'en_US'}) {
    return NumberFormat.currency(symbol: symbol, locale: locale).format(this);
  }

  String get formatCount {
    if (this < 1000) return toString();
    if (this < 1000000) {
      final v = this / 1000.0;
      return '${v.toStringAsFixed(v < 10 ? 1 : 0)}K';
    }
    if (this < 1000000000) {
      final v = this / 1000000.0;
      return '${v.toStringAsFixed(v < 10 ? 1 : 0)}M';
    }
    final v = this / 1000000000.0;
    return '${v.toStringAsFixed(v < 10 ? 1 : 0)}B';
  }
}
