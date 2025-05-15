import 'package:frontend/models/token/token.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  // Lưu token
  Future<void> saveTokens(Token token) async {
    final prefs = await SharedPreferences.getInstance();
    print("Save Access token ${token.accessToken}");
    await prefs.setString('accessToken', token.accessToken);
    await prefs.setString('refreshToken', token.refreshToken);
    await prefs.setString('tokenToken', token.tokenType);
    await prefs.setInt('expiresIn', token.expiresIn);
  }

  // Lưu user info (giả sử là dạng JSON string)
  Future<void> saveUserInfo(int userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('userId', userId);
  }
  Future<int?> getUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('userId');
  }

  Future<void> saveProfileId(int profileId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('profileId', profileId);
  }

  Future<int?> getProfileId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('profileId');
  }

  // Lấy token
  Future<String?> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('accessToken');
  }

  Future<String?> getRefreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('refreshToken');
  }

  Future<int?> getExpiresIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('expiresIn');
  }

  // Xoá tất cả
  Future<void> clearStorage() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }


  Future<void> setHandledSubscriptionSuccess(String subscriptionId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(subscriptionId, true);
  }

  Future<bool> hasHandledSubscriptionSuccess(String subscriptionId) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(subscriptionId) ?? false;
  }

  Future<void> resetHandledSubscriptionSuccess(String subscriptionId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(subscriptionId);
  }
}
