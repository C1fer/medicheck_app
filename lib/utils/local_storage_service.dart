import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  late SharedPreferences _prefs;

  void _init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Save Data
  Future<bool?> setInt(String key, int val) async {
    return await _prefs.setInt(key, val);
  }

  Future<bool?> setDouble(String key, double val) async {
    return await _prefs.setDouble(key, val);
  }

  Future<bool?> setString(String key, String val) async {
    return await _prefs.setString(key, val);
  }

 Future<bool?> setBool(String key, bool val) async {
    return await _prefs.setBool(key, val);
  }

  Future<bool?> setStringList(String key, List<String> val) async {
    return await _prefs.setStringList(key, val);
  }

  // Read Data
  int? getInt(String key) {
    return _prefs.getInt(key);
  }

  double? getDouble(String key) {
    return _prefs.getDouble(key);
  }

  String? getString(String key) {
    return _prefs.getString(key);
  }

  bool? getBool(String key) {
    return _prefs.getBool(key);
  }

  List<String>? getStringList(String key) {
    return _prefs.getStringList(key);
  }

  // Remove Data
  Future<bool?> removeEntry(String key) async{
    return await _prefs.remove(key);
  }
}