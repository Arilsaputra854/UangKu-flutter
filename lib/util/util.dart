import 'dart:ui';

import 'package:intl/intl.dart';

class Type {
  static const int TYPE_PEMASUKAN = 1;
  static const int TYPE_PENGELUARAN = 2;
}

class CustomColor {
  static const Yellow = Color(0xFFE600);
}

String konversiKeIDR(String amount) {
  double parsedAmount = double.parse(amount);

  NumberFormat formatter = NumberFormat.currency(locale: 'id', symbol: 'Rp');
  String formattedAmount = formatter.format(parsedAmount);

  return formattedAmount;
}
