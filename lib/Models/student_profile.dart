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
    final profile = json['profile'] ?? json['profileData'] ?? {};

    return StudentProfile(
      name: profile['name'] ?? 'N/A',
      regNo: profile['regNo'] ?? 'N/A',
      department: profile['department'] ?? 'N/A',
      semester: profile['semester'] ?? 'N/A',
    );
  }
}

