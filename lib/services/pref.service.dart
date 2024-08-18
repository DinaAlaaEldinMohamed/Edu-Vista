import 'package:shared_preferences/shared_preferences.dart';

abstract class PreferncesService {
  static SharedPreferences? prefs;
  static Future<void> init() async {
    try {
      prefs = await SharedPreferences.getInstance();
      print('pref service initialized successfully');
    } catch (e) {
      print('Failed to initialize preferences service: $e');
    }
  }

  static bool get isOnboardingSeen =>
      prefs!.getBool('isOnboardingSeen') ?? false;
  static set isOnboardingSeen(bool value) =>
      prefs!.setBool('isOnboardingSeen', value);
}
