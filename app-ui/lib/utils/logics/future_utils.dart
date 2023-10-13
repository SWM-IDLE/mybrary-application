import 'package:firebase_remote_config/firebase_remote_config.dart';

Future<FirebaseRemoteConfig> getAppVersionConfig() async {
  FirebaseRemoteConfig remoteConfig = FirebaseRemoteConfig.instance;

  await remoteConfig.setConfigSettings(RemoteConfigSettings(
    fetchTimeout: const Duration(minutes: 1),
    minimumFetchInterval: const Duration(hours: 1),
  ));
  await remoteConfig.fetchAndActivate();

  return remoteConfig;
}
