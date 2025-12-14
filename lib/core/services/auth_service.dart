import 'package:get/get.dart';
import 'package:mj_print/core/models/user_model.dart';
import 'package:mj_print/core/services/supabase_service.dart';
import 'package:mj_print/core/utils/constants.dart';
import 'dart:developer';

class AuthService extends GetxService {
  final SupabaseService _supabase = Get.find();
  final Rx<UserModel?> _currentUser = Rx<UserModel?>(null);
  final RxBool isLoggedIn = false.obs;
  final RxBool isLoading = false.obs;

  UserModel? get currentUser => _currentUser.value;

  @override
  Future<void> onInit() async {
    super.onInit();
    await checkAuthStatus();
  }

  Future<void> checkAuthStatus() async {
    try {
      isLoading.value = true;

      // Check if user is authenticated with Supabase
      if (_supabase.isAuthenticated) {
        isLoggedIn.value = true;

        // Fetch user profile
        await fetchUserProfile();

        log('✅ User is authenticated: ${currentUser?.email}');
      } else {
        isLoggedIn.value = false;
        _currentUser.value = null;
        log('ℹ️ No authenticated user');
      }
    } catch (e) {
      log('❌ Auth check error: $e');
      isLoggedIn.value = false;
      _currentUser.value = null;
    } finally {
      isLoading.value = false;
    }
  }

  Future<UserModel?> fetchUserProfile() async {
    try {
      final userId = _supabase.currentUserId;
      if (userId == null) return null;

      final response = await _supabase.client
          .from(AppConstants.profilesTable)
          .select()
          .eq('id', userId)
          .maybeSingle();

      if (response != null) {
        final user = UserModel.fromJson(response);
        _currentUser.value = user;
        return user;
      }

      return null;
    } catch (e) {
      log('❌ Fetch profile error: $e');
      return null;
    }
  }

  Future<UserModel?> register(
      String email, String password, String fullName) async {
    try {
      isLoading.value = true;

      // 1. Register with Supabase Auth
      final authResponse = await _supabase.signUp(email, password);

      if (authResponse.user == null) {
        throw Exception('Registration failed: No user returned');
      }

      // 2. Create user profile in profiles table
      final profileData = {
        'id': authResponse.user!.id,
        'email': email,
        'full_name': fullName,
        'role': AppConstants.roleCustomer,
      };

      await _supabase.client
          .from(AppConstants.profilesTable)
          .insert(profileData);

      // 3. Fetch created profile
      final user = await fetchUserProfile();

      if (user != null) {
        isLoggedIn.value = true;
        log('✅ Registration successful: ${user.email}');
      }

      return user;
    } catch (e) {
      log('❌ Registration error: $e');
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  Future<UserModel?> login(String email, String password) async {
    try {
      isLoading.value = true;

      // 1. Login with Supabase Auth
      final authResponse = await _supabase.signIn(email, password);

      if (authResponse.user == null) {
        throw Exception('Login failed: Invalid credentials');
      }

      // 2. Fetch user profile
      final user = await fetchUserProfile();

      if (user != null) {
        isLoggedIn.value = true;
        log('✅ Login successful: ${user.email}');
      }

      return user;
    } catch (e) {
      log('❌ Login error: $e');
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    try {
      isLoading.value = true;
      await _supabase.signOut();

      isLoggedIn.value = false;
      _currentUser.value = null;

      log('✅ Logout successful');
    } catch (e) {
      log('❌ Logout error: $e');
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  Future<UserModel?> updateProfile(Map<String, dynamic> updates) async {
    try {
      if (currentUser == null) return null;

      await _supabase.client
          .from(AppConstants.profilesTable)
          .update(updates)
          .eq('id', currentUser!.id);

      // Refresh user data
      return await fetchUserProfile();
    } catch (e) {
      log('❌ Update profile error: $e');
      return null;
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      await _supabase.client.auth.resetPasswordForEmail(email);
    } catch (e) {
      log('❌ Reset password error: $e');
      rethrow;
    }
  }
}
