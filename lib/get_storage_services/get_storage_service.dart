import 'package:get_storage/get_storage.dart';

class GetStorageServices {
  static GetStorage getStorage = GetStorage();
  static clearStorage() {
    getStorage.erase();
  }

  static setUserName({required String username}) {
    getStorage.write('username', username);
  }

  static getUserName() {
    return getStorage.read('username');
  }

  static setUserLoggedIn() {
    getStorage.write('isUserLoggedIn', true);
  }

  static getUserLoggedInStatus() {
    return getStorage.read('isUserLoggedIn');
  }

  /// user uid
  static setToken(String userUid) {
    getStorage.write('token', userUid);
  }

  static getToken() {
    return getStorage.read('token');
  }

  /// profile image
  static setProfileImageValue(String LoginValue) {
    getStorage.write('setProfileImage', LoginValue);
  }

  static getProfileImageValue() {
    return getStorage.read('setProfileImage');
  }

  /// name image
  static setNameValue(String LoginValue) {
    getStorage.write('setNameValue', LoginValue);
  }

  static getNameValue() {
    return getStorage.read('setNameValue');
  }

  /// full name
  static setFullNameValue(String LoginValue) {
    getStorage.write('setFullNameValue', LoginValue);
  }

  static getFullNameValue() {
    return getStorage.read('setFullNameValue');
  }

  /// email
  static setEmail(String LoginValue) {
    getStorage.write('setEmailValue', LoginValue);
  }

  static getEmail() {
    return getStorage.read('setEmailValue');
  }

  /// mobile
  static setMobile(String LoginValue) {
    getStorage.write('setMobile', LoginValue);
  }

  static getMobile() {
    return getStorage.read('setMobile');
  }

  /// is Email or phone
  static setIsEmailOrPhone(bool LoginValue) {
    getStorage.write('setIsEmailOrPhone', LoginValue);
  }

  static getIsEmailOrPhone() {
    return getStorage.read('setIsEmailOrPhone');
  }

  ///  set Country short code
  static setCountryCode(String countyCode) {
    getStorage.write('countyCode', countyCode);
  }

  static getCountryCode() {
    return getStorage.read('countyCode');
  }
}
