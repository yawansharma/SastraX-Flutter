import 'dart:convert';
import 'package:http/http.dart' as http;

class AttendanceSnapshot {
  final double percentage;
  final int attended;
  final int total;

  AttendanceSnapshot(this.percentage, this.attended, this.total);

  /// Factory that parses the HTML‑ish string from backend
  factory AttendanceSnapshot.parse(String raw) {
    final percentMatch = RegExp(r'(\d+(?:\.\d+)?)\s*%').firstMatch(raw);
    final pairMatch    = RegExp(r'\(\s*(\d+)\s*/\s*(\d+)\s*\)')
        .firstMatch(raw);

    return AttendanceSnapshot(
      double.parse(percentMatch?[1] ?? '0'),
      int.parse(pairMatch?[1] ?? '0'),
      int.parse(pairMatch?[2] ?? '0'),
    );
  }
}

class AttendanceService {
  static const _base = 'https://hollywood-millions-pulse-dramatic.trycloudflare.com';

  static Future<AttendanceSnapshot> fetch() async {
    final res = await http.get(Uri.parse('$_base/attendance'));
    if (res.statusCode != 200) {
      throw Exception('HTTP ${res.statusCode}');
    }
    final body = jsonDecode(res.body);
    if (body['success'] != true) {
      throw Exception('Backend error');
    }
    return AttendanceSnapshot.parse(body['attendanceHTML'] as String);
  }
}
