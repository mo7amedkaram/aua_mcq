import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AppVersionService extends GetxController {
  final Rx<String?> _latestVersion = Rx<String?>(null);

  // Getter for the latest version
  String? get latestVersion => _latestVersion.value;

  // Initialize and fetch the latest version using HTTP
  Future<void> initialize() async {
    try {
      await _fetchLatestVersion();
    } catch (e) {
      print('Error initializing AppVersionService: $e');
    }
  }

  // Fetch the latest app version using HTTP GET request
  Future<void> _fetchLatestVersion() async {
    try {
      // استبدل هذا الـ URL بالـ endpoint الفعلي الخاص بك
      final response = await http.get(
        Uri.parse('https://your-api-endpoint.com/api/version'),
        headers: {
          'Content-Type': 'application/json',
          // أضف أي headers مطلوبة مثل الـ authentication إذا لزم الأمر
        },
      );

      if (response.statusCode == 200) {
        // افترض أن الـ response يعيد JSON بصيغة: {"data": "1.0.0"}
        final data = jsonDecode(response.body);
        _latestVersion.value = data['data'];
      } else {
        throw Exception('Failed to load version: ${response.statusCode}');
      }
    } catch (e) {
      print('Failed to fetch app version: $e');
      _latestVersion.value = null;
    }
  }

  // Check if the current version needs an update
  bool needsUpdate(String currentVersion) {
    if (_latestVersion.value == null) return false;
    return _latestVersion.value != currentVersion;
  }
}
