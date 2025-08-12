import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'more_options_page.dart';

// Assuming this is your AppTheme definition. I've recreated it to match the image's colors.
class AppTheme {
  static const Color primaryPurple = Color(0xFF1872F1);
  static const Color accentPurple = Color(0xFF56C3DB);
  static const Color lightPurple = Color(0xFFD6C8E0);
  static const Color white = Colors.white;

  static const TextStyle titleTextStyle = TextStyle(
    color: white,
    fontSize: 20,
    fontWeight: FontWeight.bold,
  );
  static const TextStyle headingTextStyle = TextStyle(
    color: white,
    fontSize: 24,
    fontWeight: FontWeight.bold,
  );
  static const TextStyle subHeadingTextStyle = TextStyle(
    color: Colors.white70,
    fontSize: 14,
  );
  static const TextStyle cardTextStyle = TextStyle(
    color: white,
    fontSize: 16,
  );
  static const TextStyle buttonTextStyle = TextStyle(
    color: primaryPurple,
    fontSize: 16,
    fontWeight: FontWeight.bold,
  );
  static const TextStyle tabTextStyle = TextStyle(
    color: white,
    fontSize: 16,
    fontWeight: FontWeight.bold,
  );
  static const TextStyle resultTextStyle = TextStyle(
    color: primaryPurple,
    fontSize: 20,
    fontWeight: FontWeight.bold,
  );
}

// Assuming you have a MoreOptionsPage class defined.
class MoreOptionsPage extends StatelessWidget {
  const MoreOptionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('More Options'),
      ),
      body: const Center(
        child: Text('This is the More Options Page'),
      ),
    );
  }
}

class CgpaCalculatorPage extends StatefulWidget {
  const CgpaCalculatorPage({super.key});

  @override
  State<CgpaCalculatorPage> createState() => _CgpaCalculatorPageState();
}

class _CgpaCalculatorPageState extends State<CgpaCalculatorPage> {
  final Map<String, double> _gradePoints = {
    'S': 10.0, 'A+': 9.0, 'A': 8.0, 'B+': 7.0, 'B': 6.0,
    'C': 5.0, 'D': 4.0, 'F': 0.0, 'N': 0.0,
  };

  // Using a list of maps to store subject data (credits and grades)
  List<Map<String, dynamic>> _subjects = [];
  double _sgpa = 0.0;
  double _cgpa = 0.0;

  @override
  void initState() {
    super.initState();
    // Initialize with a few subjects to match the image's starting state
    _addSubject(credits: 4, grade: 'S');
    _addSubject(credits: 4, grade: 'A+');
    _addSubject(credits: 4, grade: 'A');
    _addSubject(credits: 4, grade: 'A+');
    _addSubject(credits: 3, grade: 'S');
    _addSubject(credits: 1, grade: 'A+');
    _addSubject(credits: 1, grade: 'A+');
    _calculateSgpa(); // Calculate initial SGPA
  }

  void _addSubject({int credits = 4, String grade = 'S'}) {
    setState(() {
      _subjects.add({'credits': credits, 'grade': grade});
      _calculateSgpa();
    });
  }

  void _removeSubject(int index) {
    setState(() {
      _subjects.removeAt(index);
      _calculateSgpa();
    });
  }

  void _updateCredit(int index, int newCredit) {
    setState(() {
      _subjects[index]['credits'] = newCredit;
      _calculateSgpa();
    });
  }

  void _updateGrade(int index, String newGrade) {
    setState(() {
      _subjects[index]['grade'] = newGrade;
      _calculateSgpa();
    });
  }

  void _calculateSgpa() {
    double totalGradePoints = 0;
    int totalCredits = 0;

    for (var subject in _subjects) {
      final credit = subject['credits'] as int;
      final grade = subject['grade'] as String;
      final gradePoint = _gradePoints[grade] ?? 0.0;

      totalGradePoints += (credit * gradePoint);
      totalCredits += credit;
    }

    setState(() {
      if (totalCredits > 0) {
        _sgpa = totalGradePoints / totalCredits;
      } else {
        _sgpa = 0.0;
      }
      // For demonstration, let's keep the CGPA logic simple.
      // In a real app, this would be based on historical data.
      _cgpa = _sgpa;
    });
  }

  // --- UI building helpers ---

  Widget _buildSubjectCard(int index) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: AppTheme.accentPurple,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              'Subject ${index + 1} Credits ->',
              style: AppTheme.cardTextStyle,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 10),
          // Credits Dropdown
          GestureDetector(
            onTap: () => _showCreditPicker(index),
            child: Container(
              height: 45,
              width: 60,
              decoration: BoxDecoration(
                color: AppTheme.primaryPurple.withOpacity(0.5),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppTheme.lightPurple, width: 0.5),
              ),
              alignment: Alignment.center,
              child: Text(
                _subjects[index]['credits'].toString(),
                style: AppTheme.cardTextStyle,
              ),
            ),
          ),
          const SizedBox(width: 10),
          // Grades Dropdown
          GestureDetector(
            onTap: () => _showGradePicker(index),
            child: Container(
              height: 45,
              width: 60,
              decoration: BoxDecoration(
                color: AppTheme.primaryPurple.withOpacity(0.5),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppTheme.lightPurple, width: 0.5),
              ),
              alignment: Alignment.center,
              child: Text(
                _subjects[index]['grade'],
                style: AppTheme.cardTextStyle,
              ),
            ),
          ),
          const SizedBox(width: 10),
          // Remove Subject Button
          InkWell(
            onTap: () => _removeSubject(index),
            child: const Icon(
              Icons.close,
              color: AppTheme.white,
              size: 24,
            ),
          ),
        ],
      ),
    );
  }

  // Helper to show credit picker dialog
  Future<void> _showCreditPicker(int index) async {
    final selectedCredit = await showDialog<int>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppTheme.accentPurple,
          title: const Text('Select Credits', style: AppTheme.cardTextStyle),
          content: SingleChildScrollView(
            child: ListBody(
              children: [1, 2, 3, 4, 5, 6].map((credit) => InkWell(
                onTap: () => Navigator.of(context).pop(credit),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Text(
                    credit.toString(),
                    style: AppTheme.cardTextStyle.copyWith(
                      fontWeight: _subjects[index]['credits'] == credit ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ),
              )).toList(),
            ),
          ),
        );
      },
    );
    if (selectedCredit != null) {
      _updateCredit(index, selectedCredit);
    }
  }

  // Helper to show grade picker dialog
  Future<void> _showGradePicker(int index) async {
    final selectedGrade = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppTheme.accentPurple,
          title: const Text('Select Grade', style: AppTheme.cardTextStyle),
          content: SingleChildScrollView(
            child: ListBody(
              children: _gradePoints.keys.map((grade) => InkWell(
                onTap: () => Navigator.of(context).pop(grade),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Text(
                    grade,
                    style: AppTheme.cardTextStyle.copyWith(
                      fontWeight: _subjects[index]['grade'] == grade ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ),
              )).toList(),
            ),
          ),
        );
      },
    );
    if (selectedGrade != null) {
      _updateGrade(index, selectedGrade);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryPurple,
      appBar: AppBar(
        backgroundColor: AppTheme.primaryPurple,
        // Add a back button to the AppBar
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.white),
          onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MoreOptionsScreen())),
        ),
        title: const Text('Calculators', style: AppTheme.titleTextStyle),
        centerTitle: false,
        elevation: 0,
        actions: const [
          // You can add other actions here if needed
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tabs Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildTab('SGPA', Icons.star, isSelected: true),
               // _buildTab('Grade', Icons.grade, isSelected: false),
               // _buildTab('Attendance', Icons.calendar_today, isSelected: false),
              ],
            ),
            const SizedBox(height: 30),
            const Text('GPA Predictor', style: AppTheme.headingTextStyle),
            const SizedBox(height: 5),
            const Text(
              'Calculate your SGPA based on credits and expected grade.',
              style: AppTheme.subHeadingTextStyle,
            ),
            const SizedBox(height: 20),
            // Subjects List
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _subjects.length,
              itemBuilder: (context, index) => _buildSubjectCard(index),
            ),
            const SizedBox(height: 20),
            // Expected SGPA Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              decoration: BoxDecoration(
                color: AppTheme.lightPurple,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Text(
                'Expected SGPA: ${_sgpa.toStringAsFixed(4)}',
                textAlign: TextAlign.center,
                style: AppTheme.resultTextStyle,
              ),
            ),
            const SizedBox(height: 20),
            // Add Subject Button
            Center(
              child: ElevatedButton.icon(
                onPressed: () => _addSubject(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  foregroundColor: AppTheme.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: const BorderSide(color: AppTheme.white, width: 1),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                ),
                icon: const Icon(Icons.add, color: AppTheme.white),
                label: const Text(
                  'Add subject',
                  style: TextStyle(color: AppTheme.white),
                ),
              ),
            ),
          ],
        ),
      ),
      // Bottom Navigation Bar
     /* bottomNavigationBar: BottomNavigationBar(
        backgroundColor: AppTheme.primaryPurple,
        selectedItemColor: AppTheme.lightPurple,
        unselectedItemColor: Colors.white54,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.folder_open),
            label: 'Materials',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calculate),
            label: 'Calculators',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),*/
    );
  }

  Widget _buildTab(String title, IconData icon, {required bool isSelected}) {
    return Column(
      children: [
        Icon(icon, color: isSelected ? AppTheme.lightPurple : AppTheme.white, size: 30),
        const SizedBox(height: 5),
        Text(
          title,
          style: AppTheme.tabTextStyle.copyWith(
            color: isSelected ? AppTheme.lightPurple : AppTheme.white,
            fontSize: isSelected ? 16 : 14,
          ),
        ),
        if (isSelected)
          Container(
            margin: const EdgeInsets.only(top: 5),
            height: 3,
            width: 40,
            color: AppTheme.lightPurple,
          ),
      ],
    );
  }
}
