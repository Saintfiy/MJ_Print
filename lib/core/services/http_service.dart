import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mj_print/core/models/simple_response_model.dart';

class HttpService {
  static const String baseUrl = 'https://jsonplaceholder.typicode.com';
  
  final Map<String, String> headers = {
    'Content-Type': 'application/json',
  };

  Future<SimpleResponseModel> get(String endpoint) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/$endpoint'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        return SimpleResponseModel(
          success: true,
          message: 'Data fetched successfully',
          data: json.decode(response.body),
        );
      } else {
        return SimpleResponseModel(
          success: false,
          message: 'Failed to fetch data: ${response.statusCode}',
        );
      }
    } catch (e) {
      return SimpleResponseModel(
        success: false,
        message: 'Error: $e',
      );
    }
  }

  Future<SimpleResponseModel> post(
    String endpoint, 
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/$endpoint'),
        headers: headers,
        body: json.encode(data),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return SimpleResponseModel(
          success: true,
          message: 'Data posted successfully',
          data: json.decode(response.body),
        );
      } else {
        return SimpleResponseModel(
          success: false,
          message: 'Failed to post data: ${response.statusCode}',
        );
      }
    } catch (e) {
      return SimpleResponseModel(
        success: false,
        message: 'Error: $e',
      );
    }
  }

  Future<SimpleResponseModel> put(
    String endpoint, 
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/$endpoint'),
        headers: headers,
        body: json.encode(data),
      );

      if (response.statusCode == 200) {
        return SimpleResponseModel(
          success: true,
          message: 'Data updated successfully',
          data: json.decode(response.body),
        );
      } else {
        return SimpleResponseModel(
          success: false,
          message: 'Failed to update data: ${response.statusCode}',
        );
      }
    } catch (e) {
      return SimpleResponseModel(
        success: false,
        message: 'Error: $e',
      );
    }
  }

  Future<SimpleResponseModel> delete(String endpoint) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/$endpoint'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        return SimpleResponseModel(
          success: true,
          message: 'Data deleted successfully',
        );
      } else {
        return SimpleResponseModel(
          success: false,
          message: 'Failed to delete data: ${response.statusCode}',
        );
      }
    } catch (e) {
      return SimpleResponseModel(
        success: false,
        message: 'Error: $e',
      );
    }
  }
}