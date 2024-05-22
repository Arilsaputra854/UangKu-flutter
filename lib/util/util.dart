import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class Type {
  static const int TYPE_PEMASUKAN = 1;
  static const int TYPE_PENGELUARAN = 2;
}

String konversiKeIDR(String amount) {
  double parsedAmount = double.parse(amount);

  NumberFormat formatter = NumberFormat.currency(locale: 'id', symbol: 'Rp');
  String formattedAmount = formatter.format(parsedAmount);

  return formattedAmount;
}

String konversiTimestamp(String timestamp) {
  String formattedDateTime = DateFormat('dd-MM-yyyy : HH:mm')
      .format(DateTime.fromMillisecondsSinceEpoch(int.parse(timestamp)));
  return formattedDateTime;
}
