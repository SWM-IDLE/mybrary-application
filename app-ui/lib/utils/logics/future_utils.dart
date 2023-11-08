import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:mybrary/res/constants/color.dart';
import 'package:mybrary/res/constants/style.dart';
import 'package:mybrary/utils/logics/common_utils.dart';

Future<FirebaseRemoteConfig> getAppVersionConfig() async {
  FirebaseRemoteConfig remoteConfig = FirebaseRemoteConfig.instance;

  await remoteConfig.setConfigSettings(RemoteConfigSettings(
    fetchTimeout: const Duration(days: 1),
    minimumFetchInterval: const Duration(days: 1),
  ));
  await remoteConfig.fetchAndActivate();

  return remoteConfig;
}

Future<bool> onWillPopCommonSaveAlert({
  required BuildContext context,
  required bool saveCondition,
  required void Function() onTapBackAction,
}) async {
  if (saveCondition) {
    return await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            '저장 여부',
            style: commonSubBoldStyle,
            textAlign: TextAlign.center,
          ),
          content: const Text(
            '작성 중인 내용이 존재합니다.\n저장하지 않고 뒤로 가실건가요 ? :(',
            style: confirmButtonTextStyle,
            textAlign: TextAlign.center,
          ),
          contentPadding: const EdgeInsets.all(16.0),
          actionsAlignment: MainAxisAlignment.center,
          buttonPadding: const EdgeInsets.symmetric(horizontal: 8.0),
          actions: [
            Row(
              children: [
                confirmButton(
                  onTap: () {
                    Navigator.of(context).pop(false);
                  },
                  buttonText: '취소',
                  isCancel: true,
                ),
                confirmButton(
                  onTap: onTapBackAction,
                  buttonText: '저장없이 뒤로가기',
                  isCancel: false,
                  confirmButtonColor: primaryColor,
                  confirmButtonText: commonWhiteColor,
                ),
              ],
            ),
          ],
        );
      },
    );
  } else {
    return true;
  }
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("백그라운드 메시지 처리.. ${message.notification!.body!}");
}

void initializeNotification() async {
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(const AndroidNotificationChannel(
          'high_importance_channel', 'high_importance_notification',
          importance: Importance.max));

  await flutterLocalNotificationsPlugin.initialize(const InitializationSettings(
    android: AndroidInitializationSettings("@mipmap/ic_launcher"),
  ));

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
}

Future<void> showNotification() async {
  const AndroidNotificationDetails androidNotificationDetails =
      AndroidNotificationDetails('channel id', 'channel name',
          channelDescription: 'channel description',
          importance: Importance.max,
          priority: Priority.max,
          showWhen: false);

  const NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: DarwinNotificationDetails(badgeNumber: 1));

  await FlutterLocalNotificationsPlugin().show(
    0,
    'test title',
    'test body',
    notificationDetails,
  );
}
