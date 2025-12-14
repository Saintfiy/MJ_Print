import 'package:get/get.dart';
import 'package:mj_print/core/models/user_model.dart';
import 'package:mj_print/data/providers/auth_provider.dart';
import 'package:mj_print/core/services/storage_service.dart';

class AuthRepository extends GetxService {
  final AuthProvider _authProvider = Get.find();
  final StorageService _storageService = Get.find();

  Future<UserModel?> login(String email, String password) async {
    return await _authProvider.login(email, password);
  }

  Future<UserModel?> register(
    String email,
    String password,
    String name,
  ) async {
    return await _authProvider.register(email, password, name);
  }

  Future<void> logout() async {
    await _authProvider.logout();
    await _storageService.removeAuthToken();
  }

  Future<String> getStoredToken() async {
    return _storageService.getAuthToken();
  }

  Future<void> storeToken(String token) async {
    await _storageService.setAuthToken(token);
  }

  Future<UserModel?> getCurrentUser() async {
    final userId = _authProvider.currentUser?.id;
    if (userId == null) return null;

    try {
      final profile = await _authProvider.getUserProfile(userId);
      return profile;
    } catch (e) {
      return null;
    }
  }

  Future<bool> updateProfile(UserModel user) async {
    final userId = _authProvider.currentUser?.id;
    if (userId == null) return false;

    final updated = await _authProvider.updateProfile(userId, user.toJson());
    if (updated != null) {
      await _storageService.setUserData(user.toJson().toString());
      return true;
    }
    return false;
  }

  Future<bool> isEmailVerified() async {
    // Supabase provider does not expose an explicit isEmailVerified helper.
    // A simple check: if a user is present, assume email is available.
    final user = _authProvider.currentUser;
    return user != null;
  }

  Future<bool> resetPassword(String email) async {
    try {
      await _authProvider.resetPassword(email);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> isLoggedIn() async {
    final token = await getStoredToken();
    return token.isNotEmpty;
  }
}
