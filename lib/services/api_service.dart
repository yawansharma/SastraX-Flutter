import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/student_profile.dart';

class ApiService {
  static const String baseUrl = 'https://ongoing-disk-ok-dealers.trycloudflare.com'
      '';

  static Future<StudentProfile> fetchStudentProfile(String regNo) async {
    final response = await http.get(Uri.parse('$baseUrl/profile'));

    if (response.statusCode == 200) {
      return StudentProfile.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load profile');
    }
  }
}
