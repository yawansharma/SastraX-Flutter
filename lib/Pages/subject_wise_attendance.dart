import 'package:flutter/material.dart';

class SubjectWiseAttendancePage extends StatelessWidget {
  String backendUrl;
  SubjectWiseAttendancePage({super.key, required this.backendUrl});
  
  final List<Map<String, dynamic>> subjects = [
    {'name': 'Mathematics', 'percentage': 85},
    {'name': 'Physics', 'percentage': 85},
    {'name': 'Chemistry', 'percentage': 85},
    {'name': 'Biology', 'percentage': 63},
    {'name': 'Computer', 'percentage': 75},
  ];

  Color _getBarColor(int percent) {
    return percent >= 80 ? Colors.green : Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Subject-wise Attendance'),
        backgroundColor: Colors.blue.shade700,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: subjects.map((subject) {
            final color = _getBarColor(subject['percentage']);
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    subject['name'],
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  Stack(
                    children: [
                      Container(
                        height: 20,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      Container(
                        height: 20,
                        width: MediaQuery.of(context).size.width *
                            (subject['percentage'] / 100),
                        decoration: BoxDecoration(
                          color: color,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      '${subject['percentage']}%',
                      style: TextStyle(
                        color: color,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
