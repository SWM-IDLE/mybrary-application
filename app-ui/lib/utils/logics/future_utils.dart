import 'dart:developer';
import 'dart:io';
import 'dart:math' as math;

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:mybrary/res/constants/color.dart';
import 'package:mybrary/res/constants/style.dart';
import 'package:mybrary/utils/logics/common_utils.dart';
import 'package:mybrary/utils/logics/ui_utils.dart';

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
  AndroidNotificationChannel? androidNotificationChannel;
  if (Platform.isIOS) {
    await FirebaseMessaging.instance.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
  } else if (Platform.isAndroid) {
    androidNotificationChannel = const AndroidNotificationChannel(
      'important_channel', // id
      'Important_Notifications', // name
      description: '중요도가 높은 알림을 위한 채널.',
      importance: Importance.high,
    );

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(androidNotificationChannel);

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(const AndroidNotificationChannel(
            'high_importance_channel', 'high_importance_notification',
            importance: Importance.max));

    await flutterLocalNotificationsPlugin
        .initialize(const InitializationSettings(
      android: AndroidInitializationSettings("@mipmap/ic_launcher"),
    ));

    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    getToken();
  }
}

Future<String> getToken() async {
  log("fcmToken : ${await FirebaseMessaging.instance.getToken()}");
  String? token;
  token = await FirebaseMessaging.instance.getToken();
  if (token != null) {
    return token;
  }
  return '';
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

Future<String> convertHeicToJpg(XFile heicFile) async {
  try {
    Uint8List heicBytes = await heicFile.readAsBytes();
    List<int> jpgBytes = await FlutterImageCompress.compressWithList(
      heicBytes,
      quality: 94, // 압축 품질, 0-100 사이의 값
      rotate: 0, // 이미지 회전 각도 (0, 90, 180, 270)
      format: CompressFormat.jpeg, // 압축 형식 설정
    );

    String jpgPath = heicFile.path.replaceAll('.heic', '.jpg');
    File jpgFile = File(jpgPath);
    await jpgFile.writeAsBytes(jpgBytes);

    return jpgFile.path;
  } catch (e) {
    log("HEIC to JPEG 변환 오류: $e");
    rethrow;
  }
}

Future<String> resizeAndroidPhoto(String filePath, Size previewSize) async {
  File imageFile = await resizePhoto(filePath, previewSize);

  return imageFile.path;
}

Future<XFile> resizeIosPhoto(String filePath, Size previewSize) async {
  File imageFile = await resizePhoto(filePath, previewSize);

  return XFile(imageFile.path);
}

Future<File> resizePhoto(String filePath, Size previewSize) async {
  ImageProperties properties =
      await FlutterNativeImage.getImageProperties(filePath);

  var cropSize =
      math.min(previewSize.width, previewSize.height) * (isIOS ? 0.7 : 2.2);
  int offsetX = (properties.width! - cropSize) ~/ 2;
  int offsetY = (properties.height! - cropSize) ~/ 2;

  File imageFile = await FlutterNativeImage.cropImage(
      filePath, offsetX, offsetY, cropSize.toInt(), cropSize.toInt());
  return imageFile;
}
