import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:mybrary/res/constants/color.dart';
import 'package:mybrary/res/constants/style.dart';
import 'package:mybrary/ui/search/search_scan/search_scan_screen.dart';
import 'package:permission_handler/permission_handler.dart';

Future<dynamic> checkScanPermission(BuildContext context) async {
  await Permission.camera.request();

  final permissionCameraStatus = await Permission.camera.status;

  switch (permissionCameraStatus) {
    case PermissionStatus.granted || PermissionStatus.provisional:
      if (context.mounted) {
        final cameras = await availableCameras();
        final firstCamera = cameras.first;

        if (!context.mounted) return;
        return Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => SearchScanScreen(camera: firstCamera),
          ),
        );
      }
    case PermissionStatus.denied || PermissionStatus.permanentlyDenied:
      if (context.mounted) {
        return ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            action: SnackBarAction(
              label: '설정',
              textColor: primaryColor,
              onPressed: () {
                openAppSettings();
              },
            ),
            content: const Text(
              '카메라 권한이 없습니다.\n설정에서 권한을 허용해주세요.',
              style: commonSnackBarMessageStyle,
            ),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    default:
      return Permission.camera.request();
  }
}
