import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';

class AppwriteDb {
  final String _baseUrl = 'https://cloud.appwrite.io/v1';
  final String _projectId = '65f463fd706dd4b9b48f';

  Map<String, String> _getHeaders() {
    return {
      'Content-Type': 'application/json',
      'X-Appwrite-Project': _projectId,
    };
  }

  // this function responsible for check userData in database
  Future<String?> checkUserId({required String userId}) async {
    try {
      final response = await http.get(
        Uri.parse(
            '$_baseUrl/databases/65343991a4a9ab79fba9/collections/65ac5736d76070d8b547/documents?queries[]=${Uri.encodeComponent('equal("user_id", "$userId")')}'),
        headers: _getHeaders(),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['documents'] != null && data['documents'].isNotEmpty) {
          return data['documents'][0]['data']['user_id'];
        }
      }
      return null;
    } catch (error) {
      print('Error checking user ID: $error');
      return null;
    }
  }

  //---------------------------------- get all userData -----
  Future<Map<String, dynamic>?> getAllUserData({required String userId}) async {
    try {
      final response = await http.get(
        Uri.parse(
            '$_baseUrl/databases/65343991a4a9ab79fba9/collections/65ac5736d76070d8b547/documents?queries[]=${Uri.encodeComponent('equal("user_id", "$userId")')}'),
        headers: _getHeaders(),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['documents'] != null && data['documents'].isNotEmpty) {
          return data['documents'][0]['data'];
        }
      }
      return null;
    } catch (error) {
      print('Error getting user data: $error');
      return null;
    }
  }

  //---------------------- store user data --------
  Future<void> createDocument({
    required String userId,
    required String userName,
    required String userEmail,
    required String phoneNumber,
    required String deviceId,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(
            '$_baseUrl/databases/65343991a4a9ab79fba9/collections/65ac5736d76070d8b547/documents'),
        headers: _getHeaders(),
        body: json.encode({
          'documentId': _generateUniqueId(),
          'data': {
            "user_id": userId,
            "user_name": userName,
            "user_email": userEmail,
            "user_phone_number": phoneNumber,
            "user_device_id": deviceId
          }
        }),
      );

      if (response.statusCode != 201) {
        throw Exception('Failed to create document: ${response.reasonPhrase}');
      }
    } catch (error) {
      print('Error creating document: $error');
      rethrow;
    }
  }

  // Generate a unique ID for documents
  String _generateUniqueId() {
    // Simple implementation for unique ID generation
    return '${DateTime.now().millisecondsSinceEpoch}-${1000 + (DateTime.now().microsecond % 9000)}';
  }

  //------------- //--------------------
  Future<List<dynamic>?> getUsersWithFilter(
      String userId, String subcategoryId) async {
    try {
      // Using a different project ID for this specific request
      final headers = {
        'Content-Type': 'application/json',
        'X-Appwrite-Project': '65490db0b6534bd99e01',
      };

      final String queries =
          'queries[]=${Uri.encodeComponent('equal("user_id", "$userId")')}&queries[]=${Uri.encodeComponent('equal("subcategory_id", "$subcategoryId")')}';

      final response = await http.get(
        Uri.parse(
            '$_baseUrl/databases/65490ddae28178cc3551/collections/6560f6f1e184767b8a4a/documents?$queries'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['documents'] != null) {
          return data['documents'];
        }
      } else {
        // Handle error based on status code
        Get.snackbar("Error",
            "Failed to fetch data: ${response.statusCode} ${response.reasonPhrase}");
      }
      return null;
    } catch (error) {
      Get.snackbar("Error", error.toString());
      return null;
    }
  }
}
