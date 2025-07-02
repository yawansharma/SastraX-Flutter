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
    return StudentProfile(
      name: json['name'],
      regNo: json['regNo'],
      department: json['department'],
      semester: json['semester'],
    );
  }
}
