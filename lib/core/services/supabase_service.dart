import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:mj_print/core/utils/constants.dart';
import 'dart:developer';

class SupabaseService extends GetxService {
  static SupabaseService get instance => Get.find<SupabaseService>();

  late final SupabaseClient client;
  final RxBool isConnected = false.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    await _initializeSupabase();
  }

  Future<void> _initializeSupabase() async {
    try {
      await Supabase.initialize(
        url: AppConstants.supabaseUrl,
        anonKey: AppConstants.supabaseAnonKey,
      );
      client = Supabase.instance.client;
      isConnected.value = true;
      log('✅ Supabase initialized successfully');
    } catch (e) {
      log('❌ Error initializing Supabase: $e');
      isConnected.value = false;
      rethrow;
    }
  }

  // Auth Methods
  Future<AuthResponse> signUp(String email, String password) async {
    try {
      final response = await client.auth.signUp(
        email: email,
        password: password,
      );
      return response;
    } catch (e) {
      log('❌ Sign up error: $e');
      rethrow;
    }
  }

  Future<AuthResponse> signIn(String email, String password) async {
    try {
      final response = await client.auth.signInWithPassword(
        email: email,
        password: password,
      );
      return response;
    } catch (e) {
      log('❌ Sign in error: $e');
      rethrow;
    }
  }

  Future<void> signOut() async {
    try {
      await client.auth.signOut();
    } catch (e) {
      log('❌ Sign out error: $e');
      rethrow;
    }
  }

  // Data Methods
  Future<List<Map<String, dynamic>>> insertData(
    String table,
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await client.from(table).insert(data).select();
      return List<Map<String, dynamic>>.from(response as List);
    } catch (e) {
      log('❌ Insert error: $e');
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> getData(
    String table, {
    Map<String, dynamic>? filters,
    String? orderBy,
    bool ascending = true,
    int? limit,
  }) async {
    try {
      dynamic query = client.from(table).select();

      // Apply filters if any
      if (filters != null) {
        filters.forEach((key, value) {
          if (value != null) {
            query = query.eq(key, value);
          }
        });
      }

      // Apply ordering
      if (orderBy != null) {
        query = query.order(orderBy, ascending: ascending);
      }

      // Apply limit
      if (limit != null) {
        query = query.limit(limit);
      }

      final response = await query;
      return List<Map<String, dynamic>>.from(response as List);
    } catch (e) {
      log('❌ Get data error: $e');
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> updateData(
    String table,
    String id,
    Map<String, dynamic> data,
  ) async {
    try {
      final response =
          await client.from(table).update(data).eq('id', id).select();
      return List<Map<String, dynamic>>.from(response as List);
    } catch (e) {
      log('❌ Update error: $e');
      rethrow;
    }
  }

  // Simple subscribe stub - emits current data once. Replace with real-time implementation when needed.
  Stream<List<Map<String, dynamic>>> subscribeToTable(String table) async* {
    final data = await getData(table);
    yield data;
  }

  Future<void> deleteData(String table, String id) async {
    try {
      await client.from(table).delete().eq('id', id);
    } catch (e) {
      log('❌ Delete error: $e');
      rethrow;
    }
  }

  // Helper Methods
  User? get currentUser => client.auth.currentUser;
  Session? get currentSession => client.auth.currentSession;
  String? get currentUserId => currentUser?.id;
  bool get isAuthenticated => currentUser != null;

  // Auth state stream
  Stream<AuthState> get authStateChanges => client.auth.onAuthStateChange;

  // Check if user is admin
  Future<bool> isUserAdmin() async {
    try {
      if (currentUserId == null) return false;

      final response = await client
          .from(AppConstants.profilesTable)
          .select('role')
          .eq('id', currentUserId!)
          .single();

      return response['role'] == AppConstants.roleAdmin;
    } catch (e) {
      return false;
    }
  }
}
