import 'package:get/get.dart';
import 'package:mj_print/core/services/supabase_service.dart';
import 'package:mj_print/core/models/simple_response_model.dart';
import 'package:mj_print/core/models/location_model.dart';

class LocationProvider extends GetxService {
  final SupabaseService _supabaseService = Get.find();

  // Save location to Supabase
  Future<SimpleResponseModel> saveLocation(LocationModel location) async {
    try {
      final response =
          await _supabaseService.insertData('locations', location.toJson());
      return SimpleResponseModel(
          success: true, message: 'Location saved', data: response);
    } catch (e) {
      return SimpleResponseModel(success: false, message: e.toString());
    }
  }

  // Get location history
  Future<SimpleResponseModel> getLocationHistory() async {
    try {
      final response = await _supabaseService.getData('locations');
      return SimpleResponseModel(
          success: true, message: 'Locations fetched', data: response);
    } catch (e) {
      return SimpleResponseModel(success: false, message: e.toString());
    }
  }

  // Get locations by user
  Future<SimpleResponseModel> getLocationsByUser(String userId) async {
    try {
      final response = await _supabaseService.client
          .from('locations')
          .select()
          .eq('user_id', userId)
          .order('timestamp', ascending: false);

      return SimpleResponseModel(
        success: true,
        message: 'Location history fetched',
        data: response,
      );
    } catch (e) {
      return SimpleResponseModel(
        success: false,
        message: e.toString(),
      );
    }
  }

  // Get recent locations
  Future<SimpleResponseModel> getRecentLocations(int limit) async {
    try {
      final response = await _supabaseService.client
          .from('locations')
          .select()
          .order('timestamp', ascending: false)
          .limit(limit);

      return SimpleResponseModel(
        success: true,
        message: 'Recent locations fetched',
        data: response,
      );
    } catch (e) {
      return SimpleResponseModel(
        success: false,
        message: e.toString(),
      );
    }
  }

  // Delete location
  Future<SimpleResponseModel> deleteLocation(String locationId) async {
    try {
      await _supabaseService.deleteData('locations', locationId);
      return SimpleResponseModel(success: true, message: 'Location deleted');
    } catch (e) {
      return SimpleResponseModel(success: false, message: e.toString());
    }
  }

  // Clear location history
  Future<SimpleResponseModel> clearLocationHistory(String userId) async {
    try {
      await _supabaseService.client
          .from('locations')
          .delete()
          .eq('user_id', userId);

      return SimpleResponseModel(
        success: true,
        message: 'Location history cleared',
      );
    } catch (e) {
      return SimpleResponseModel(
        success: false,
        message: e.toString(),
      );
    }
  }

  // Get locations in date range
  Future<SimpleResponseModel> getLocationsInRange(
    String userId,
    DateTime startDate,
    DateTime endDate,
  ) async {
    try {
      final response = await _supabaseService.client
          .from('locations')
          .select()
          .eq('user_id', userId)
          .gte('timestamp', startDate.toIso8601String())
          .lte('timestamp', endDate.toIso8601String())
          .order('timestamp', ascending: false);

      return SimpleResponseModel(
        success: true,
        message: 'Locations in range fetched',
        data: response,
      );
    } catch (e) {
      return SimpleResponseModel(
        success: false,
        message: e.toString(),
      );
    }
  }

  // Real-time location updates
  Stream<List<Map<String, dynamic>>> getLocationUpdates() {
    return _supabaseService.subscribeToTable('locations');
  }
}
