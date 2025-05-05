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
}
