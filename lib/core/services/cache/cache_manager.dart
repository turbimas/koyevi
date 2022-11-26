import 'package:shared_preferences/shared_preferences.dart';

class CacheManager {
  static final CacheManager _instance = CacheManager._init();

  SharedPreferences? _preferences;
  static CacheManager get instance => _instance;

  CacheManager._init() {
    SharedPreferences.getInstance().then((value) {
      _preferences = value;
    });
  }
  static Future initCache() async {
    instance._preferences ??= await SharedPreferences.getInstance();
  }

  Future<void> clearAll() async {
    await _preferences!.clear();
  }

  // get
  Object? get(String key) => _preferences!.get(key);
  bool? getBool(String key) => _preferences!.getBool(key);
  double? getDouble(String key) => _preferences!.getDouble(key);
  int? getInt(String key) => _preferences!.getInt(key);
  String? getString(String key) => _preferences!.getString(key);
  List<String>? getStringList(String key) => _preferences!.getStringList(key);

  // set
  Future<bool> setInt(String key, int value) async =>
      await _preferences!.setInt(key, value);
  Future<bool> setDouble(String key, double value) async =>
      await _preferences!.setDouble(key, value);
  Future<bool> setBool(String key, bool value) async =>
      await _preferences!.setBool(key, value);
  Future<bool> setString(String key, String value) async =>
      await _preferences!.setString(key, value);
  Future<bool> setStringList(String key, List<String> value) async =>
      await _preferences!.setStringList(key, value);

  Future<bool> remove(String key) async => await _preferences!.remove(key);

  // Future<void> clearAll() async {
  //   await _preferences!.clear();
  // }

  // Future<void> clearAllSaveFirst() async {
  //   if (_preferences != null) {
  //     await _preferences!.clear();
  //     await setBoolValue(PreferencesKeys.IS_FIRST_APP, true);
  //   }
  // }

  // Future<void> setStringValue(PreferencesKeys key, String value) async {
  //   await _preferences!.setString(key.toString(), value);
  // }

  // Future<void> setBoolValue(PreferencesKeys key, bool value) async {
  //   await _preferences!.setBool(key.toString(), value);
  // }

  // String getStringValue(PreferencesKeys key) =>
  //     _preferences?.getString(key.toString()) ?? '';

  // bool getBoolValue(PreferencesKeys key) =>
  //     _preferences!.getBool(key.toString()) ?? false;
}
