class StudentProfile {
  final String name;
  final String regNo;
  final String department;
  final String semester;

  StudentProfile({
    required this.name,
    required this.regNo,
    required this.department,
    required this.semester,
  });

  factory StudentProfile.fromJson(Map<String, dynamic> json) {
    final profile = json['profileData'] ?? {};
    return StudentProfile(
      name: profile['name'] ?? 'Unknown',
      regNo: profile['regNo'] ?? 'Unknown',
      department: profile['department'] ?? 'Unknown',
      semester: profile['semester'] ?? 'Unknown',
    );
  }
}