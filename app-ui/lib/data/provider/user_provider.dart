import 'package:shared_preferences/shared_preferences.dart';

class UserState {
  static late SharedPreferences localStorage;
  static Future init() async {
    localStorage = await SharedPreferences.getInstance();
  }

  static String get userId => localStorage.getString('userId')!;
  static bool? get update => localStorage.getBool('update') ?? false;
  static bool? get forceUpdate => localStorage.getBool('forceUpdate') ?? false;
}
