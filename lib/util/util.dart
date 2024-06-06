import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
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

void loadingUangku(BuildContext context) {
  bool _isLoading = true;

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return Dialog(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(Colors.black),
              ),
              SizedBox(width: 20.0),
              Text("Memproses"),
            ],
          ),
        ),
      );
    },
  ).then((value) {
    _isLoading = false;
  });
}

class UangkuNotification {
  static Future initialize(
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
    var androidInitialize =
        new AndroidInitializationSettings('mipmap/ic_launcher');
    var initializationSettings =
        new InitializationSettings(android: androidInitialize);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  static Future showTextNotification(
      {var id = 0,
      required String title,
      required String body,
      var payload,
      required FlutterLocalNotificationsPlugin fln}) async {
    AndroidNotificationDetails _androidNotificationDetails =
        new AndroidNotificationDetails("reminder", "reminder_channel",
            playSound: true,
            importance: Importance.max,
            sound: RawResourceAndroidNotificationSound("uangku"),
            priority: Priority.max);

    var notification =
        NotificationDetails(android: _androidNotificationDetails);

    await fln.show(0, title, body, notification);
  }
}
