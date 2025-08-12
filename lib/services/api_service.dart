import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/student_profile.dart';

class ApiService {
  static const String baseUrl = 'https://kenneth-adsl-education-gamma.trycloudflare.com';

  static Future<StudentProfile> fetchStudentProfile(String regNo) async {
    final response = await http.post(
      Uri.parse('$baseUrl/profile'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({'regNo': regNo}),
    );

    if (response.statusCode == 200) {
      try {
        final jsonData = json.decode(response.body);
        return StudentProfile.fromJson(jsonData);
      } catch (e) {
        throw Exception('Parsing error: $e');
      }
    } else {
      throw Exception('Failed to load profile: ${response.statusCode}');
    }
  }
}
