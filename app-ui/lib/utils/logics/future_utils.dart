import 'package:firebase_remote_config/firebase_remote_config.dart';

Future<FirebaseRemoteConfig> getAppVersionConfig() async {
  FirebaseRemoteConfig remoteConfig = FirebaseRemoteConfig.instance;

  await remoteConfig.setConfigSettings(RemoteConfigSettings(
    fetchTimeout: const Duration(days: 1),
    minimumFetchInterval: const Duration(days: 1),
  ));
  await remoteConfig.fetchAndActivate();

  return remoteConfig;
}
