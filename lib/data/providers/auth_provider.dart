import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:mj_print/core/services/supabase_service.dart';
import 'package:mj_print/core/models/user_model.dart';
import 'package:mj_print/core/utils/constants.dart';
import 'dart:developer';

class AuthProvider {
  final SupabaseService _supabase = Get.find();

  // Get current user from Supabase
  User? get currentUser => _supabase.currentUser;
  bool get isAuthenticated => _supabase.isAuthenticated;

  // Login with email and password
  Future<UserModel?> login(String email, String password) async {
    try {
      // 1. Authenticate with Supabase
      final authResponse = await _supabase.client.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (authResponse.user == null) {
        return null;
      }

      // 2. Fetch user profile
      final profile = await _supabase.client
          .from(AppConstants.profilesTable)
          .select()
          .eq('id', authResponse.user!.id)
          .maybeSingle();

      if (profile == null) {
        // Create profile if doesn't exist
        final newProfile = {
          'id': authResponse.user!.id,
          'email': email,
          'full_name': email.split('@').first,
          'role': AppConstants.roleCustomer,
          'created_at': DateTime.now().toIso8601String(),
          'updated_at': DateTime.now().toIso8601String(),
        };

        await _supabase.client
            .from(AppConstants.profilesTable)
            .insert(newProfile);

        return UserModel.fromJson(newProfile);
      }

      return UserModel.fromJson(profile);
    } catch (e) {
      log('❌ Login provider error: $e');
      rethrow;
    }
  }

  // Register new user
  Future<UserModel?> register(
      String email, String password, String fullName) async {
    try {
      // 1. Register with Supabase Auth
      final authResponse = await _supabase.client.auth.signUp(
        email: email,
        password: password,
      );

      if (authResponse.user == null) {
        throw Exception('Registration failed');
      }

      // 2. Create user profile
      final profileData = {
        'id': authResponse.user!.id,
        'email': email,
        'full_name': fullName,
        'role': AppConstants.roleCustomer,
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      };

      await _supabase.client
          .from(AppConstants.profilesTable)
          .insert(profileData);

      return UserModel.fromJson(profileData);
    } catch (e) {
      log('❌ Register provider error: $e');
      rethrow;
    }
  }

  // Logout
  Future<void> logout() async {
    try {
      await _supabase.client.auth.signOut();
    } catch (e) {
      log('❌ Logout provider error: $e');
      rethrow;
    }
  }

  // Get user profile
  Future<UserModel?> getUserProfile(String userId) async {
    try {
      final response = await _supabase.client
          .from(AppConstants.profilesTable)
          .select()
          .eq('id', userId)
          .maybeSingle();

      if (response == null) return null;
      return UserModel.fromJson(response);
    } catch (e) {
      log('❌ Get profile error: $e');
      return null;
    }
  }

  // Update user profile
  Future<UserModel?> updateProfile(
      String userId, Map<String, dynamic> updates) async {
    try {
      final updatedData = {
        ...updates,
        'updated_at': DateTime.now().toIso8601String(),
      };

      final response = await _supabase.client
          .from(AppConstants.profilesTable)
          .update(updatedData)
          .eq('id', userId)
          .select()
          .single();

      return UserModel.fromJson(response);
    } catch (e) {
      log('❌ Update profile error: $e');
      return null;
    }
  }

  // Check if email exists
  Future<bool> checkEmailExists(String email) async {
    try {
      final response = await _supabase.client
          .from(AppConstants.profilesTable)
          .select('id')
          .eq('email', email)
          .maybeSingle();

      return response != null;
    } catch (e) {
      log('❌ Check email error: $e');
      return false;
    }
  }

  // Reset password
  Future<void> resetPassword(String email) async {
    try {
      await _supabase.client.auth.resetPasswordForEmail(email);
    } catch (e) {
      log('❌ Reset password error: $e');
      rethrow;
    }
  }

  // Update password
  Future<void> updatePassword(String newPassword) async {
    try {
      await _supabase.client.auth.updateUser(
        UserAttributes(password: newPassword),
      );
    } catch (e) {
      log('❌ Update password error: $e');
      rethrow;
    }
  }

  // Get all users (admin only)
  Future<List<UserModel>> getAllUsers() async {
    try {
      final response = await _supabase.client
          .from(AppConstants.profilesTable)
          .select()
          .order('created_at', ascending: false);

      return (response as List)
          .map((json) => UserModel.fromJson(json))
          .toList();
    } catch (e) {
      log('❌ Get all users error: $e');
      return [];
    }
  }

  // Check if user is admin
  Future<bool> isAdmin(String userId) async {
    try {
      final response = await _supabase.client
          .from(AppConstants.profilesTable)
          .select('role')
          .eq('id', userId)
          .single();

      return response['role'] == AppConstants.roleAdmin;
    } catch (e) {
      log('❌ Check admin error: $e');
      return false;
    }
  }
}
