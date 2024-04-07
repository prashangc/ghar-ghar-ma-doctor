import 'package:shared_preferences/shared_preferences.dart';

class PreferenceHelper {
  static SharedPreferences? _sharedPrefs;

  init() async {
    _sharedPrefs ??= await SharedPreferences.getInstance();
    // _sharedPrefs!.reload();
  }

  storeUserID(tokenKey, tokenValue) async {
    await _sharedPrefs!.setString(tokenKey, tokenValue);
  }

  getUserID(tokenKey) {
    return _sharedPrefs!.getString(tokenKey) ?? '';
  }

  storeToDevice(tokenKey, tokenValue) {
    String myUserID = getUserID("userID") ?? '';
    _sharedPrefs!.setString(tokenKey + myUserID, tokenValue);
  }

  storeIntToDevice(tokenKey, tokenValue) {
    String myUserID = getUserID("userID");
    _sharedPrefs!.setInt(tokenKey + myUserID, tokenValue);
  }

  getFromDevice(tokenKey) {
    String myUserID = getUserID("userID") ?? '';
    return _sharedPrefs!.getString(tokenKey + myUserID);
  }

  getIntFromDevice(tokenKey) {
    String myUserID = getUserID("userID");
    return _sharedPrefs!.getInt(tokenKey + myUserID);
  }

  storeBooleanToDevice(tokenKey, tokenValue) {
    _sharedPrefs!.setBool(tokenKey, tokenValue);
  }

  getBooleanFromDevice(tokenKey) {
    return _sharedPrefs!.getBool(tokenKey) ?? false;
  }

  removeFromDevice(tokenKey) {
    String myUserID = getUserID("userID");
    return _sharedPrefs!.remove(tokenKey + myUserID);
  }
}

final sharedPrefs = PreferenceHelper();
