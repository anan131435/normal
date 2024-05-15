

import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  late SharedPreferences _preferences;
  static late LocalStorage _instance;
  LocalStorage.of() {
    init();
  }
  LocalStorage._pre(SharedPreferences preferences) {
    _preferences = preferences;
  }
  static LocalStorage getInstance() {
    _instance ??= LocalStorage.of();
    return _instance;
  }
  void init() async {
    if (_preferences == null) {
      _preferences = await SharedPreferences.getInstance();
    }
  }
  static Future<LocalStorage> preInit() async {
    if (_instance == null) {
      var pres = await SharedPreferences.getInstance();
      _instance = LocalStorage._pre(pres);
    }
    return _instance;
  }

  void setData<T>(String key, T data) {
    if (data is String) {
      _preferences.setString(key, data);
    } else if (data is double) {
      _preferences.setDouble(key, data);
    } else if (data is int) {
      _preferences.setInt(key, data);
    } else if (data is bool) {
      _preferences.setBool(key, data);
    } else if (data is List<String>) {
      _preferences.setStringList(key, data);
    }
  }

  T? get<T>(String key) {
    var value = _preferences.get(key);
    if (value !=null ) {
      return value as T;
    }
    return null;
  }

  void remove(String key) {
    _preferences.remove(key);
  }
}