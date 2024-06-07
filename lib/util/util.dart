import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

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
    tz.initializeTimeZones();

    var now = tz.TZDateTime.now(tz.local);
    var today = tz.TZDateTime(now.location, now.year, now.month, now.day, 24);

    AndroidNotificationDetails _androidNotificationDetails =
        AndroidNotificationDetails(
            "channel_id_reminder_uangku", "reminder_channel",
            playSound: true,
            importance: Importance.high,
            sound: RawResourceAndroidNotificationSound(
                "uangku.mp3".split(".").first),
            priority: Priority.high);

    var notification =
        NotificationDetails(android: _androidNotificationDetails);

    await fln.zonedSchedule(id, title, body, today, notification,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime);
  }

  static Future showScheduleTextNotification(
      {var id = 1,
      required String title,
      required String body,
      var payload,
      required FlutterLocalNotificationsPlugin fln}) async {
    await fln.zonedSchedule(
        id,
        'scheduled title',
        'scheduled body',
        tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5)),
        const NotificationDetails(
            android: AndroidNotificationDetails(
                'channel_id_reminder_uangku', 'reminder_channel',
                channelDescription: 'your channel description')),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime);
  }
}



// AndroidNotificationDetails _androidNotificationDetails =
    //     AndroidNotificationDetails("channel_id_reminder_scheduled_uangku",
    //         "scheduled_reminder_channel",
    //         playSound: true,
    //         importance: Importance.high,
    //         sound: RawResourceAndroidNotificationSound(
    //             "uangku.mp3".split(".").first),
    //         priority: Priority.high);

    // var notification =
    //     NotificationDetails(android: _androidNotificationDetails);

    // await fln.zonedSchedule(id, title, body,
    //     tz.TZDateTime.now(tz.local).add(Duration(seconds: 5)), notification,
    //     uiLocalNotificationDateInterpretation:
    //         UILocalNotificationDateInterpretation.absoluteTime,
    //     payload: payload);