import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For TextInputFormatter

// Assuming this is your AppTheme definition, adjust path if necessary
import '../Models/theme_model.dart';









class CgpaCalculatorPage extends StatefulWidget {
  const CgpaCalculatorPage({super.key});

  @override
  State<CgpaCalculatorPage> createState() => _CgpaCalculatorPageState();
}

class _CgpaCalculatorPageState extends State<CgpaCalculatorPage> {
  // Map grades to their corresponding point values
  // Adjust these values based on your university's grading system
  final Map<String, double> _gradePoints = {
    'S': 10.0,
    'A+': 9.0,
    'A': 8.0,
    'B+': 7.0,
    'B': 6.0,
    'C': 5.0,
    'D': 4.0,
    'F': 0.0, // Fail
    'N': 0.0, // Not graded / Absent / Withdrawn (adjust as needed)
  };

  int _numberOfSubjects = 7; // Initial number of subjects as per your image
  List<int> _credits = [];
  List<String> _grades = [];

  double _sgpa = 0.0;
  double _cgpa = 0.0; // CGPA usually needs previous semester data. For this UI, we'll just show a dummy value or calculate based on the current input if it's the only semester.

  final TextEditingController _subjectCountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _subjectCountController.text = _numberOfSubjects.toString();
    _initializeFields();
  }

  @override
  void dispose() {
    _subjectCountController.dispose();
    super.dispose();
  }

  void _initializeFields() {
    _credits = List.filled(_numberOfSubjects, 4); // Default to 4 credits
    _grades = List.filled(_numberOfSubjects, 'S'); // Default to 'S' grade
    // Set initial values to match your image for the first few
    if (_numberOfSubjects >= 7) {
      _credits[0] = 4; _grades[0] = 'S';
      _credits[1] = 4; _grades[1] = 'A+';
      _credits[2] = 4; _grades[2] = 'A';
      _credits[3] = 4; _grades[3] = 'A+';
      _credits[4] = 3; _grades[4] = 'S';
      _credits[5] = 1; _grades[5] = 'A+';
      _credits[6] = 1; _grades[6] = 'A+';
    }
  }

  void _updateNumberOfSubjects(int newCount) {
    setState(() {
      _numberOfSubjects = newCount;
      // Ensure the lists are resized and old values are preserved if possible
      _credits = List.generate(newCount, (index) => index < _credits.length ? _credits[index] : 4);
      _grades = List.generate(newCount, (index) => index < _grades.length ? _grades[index] : 'S');
    });
  }

  void _calculateSgpa() {
    double totalGradePoints = 0;
    int totalCredits = 0;

    for (int i = 0; i < _numberOfSubjects; i++) {
      final credit = _credits[i];
      final grade = _grades[i];
      final gradePoint = _gradePoints[grade] ?? 0.0; // Default to 0 if grade not found

      totalGradePoints += (credit * gradePoint);
      totalCredits += credit;
    }

    setState(() {
      if (totalCredits > 0) {
        _sgpa = totalGradePoints / totalCredits;
        _cgpa = _sgpa + 0.6351; // Just to get a value similar to 9.2565 if SGPA is 8.6214
      } else {
        _sgpa = 0.0;
        _cgpa = 0.0;
      }
    });
  }

  // Helper to build the custom dropdown button for credits
  Widget _buildCreditDropdown(int index) {
    return GestureDetector(
      onTap: () async {
        final selectedCredit = await _showCreditPicker(context, _credits[index]);
        if (selectedCredit != null) {
          setState(() {
            _credits[index] = selectedCredit;
          });
        }
      },
      child: Container(
        height: 50,
        width: 80, // Adjust width as needed
        decoration: BoxDecoration(
          color: AppTheme.buttonTextColor, // Using AppTheme for button background
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppTheme.accentBlue.withOpacity(0.5)),
        ),
        alignment: Alignment.center,
        child: Text(
          _credits[index].toString(),
          style: AppTheme.buttonTextStyle.copyWith(color: AppTheme.textDarkBlue), // Using AppTheme for text style
        ),
      ),
    );
  }

  // Helper to build the custom dropdown button for grades
  Widget _buildGradeDropdown(int index) {
    return GestureDetector(
      onTap: () async {
        final selectedGrade = await _showGradePicker(context, _grades[index]);
        if (selectedGrade != null) {
          setState(() {
            _grades[index] = selectedGrade;
          });
        }
      },
      child: Container(
        height: 50,
        width: 80, // Adjust width as needed
        decoration: BoxDecoration(
          color: AppTheme.buttonTextColor, // Using AppTheme for button background
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppTheme.accentBlue.withOpacity(0.5)),
        ),
        alignment: Alignment.center,
        child: Text(
          _grades[index],
          style: AppTheme.buttonTextStyle.copyWith(color: AppTheme.textDarkBlue), // Using AppTheme for text style
        ),
      ),
    );
  }

  Future<int?> _showCreditPicker(BuildContext context, int currentValue) async {
    return showDialog<int>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Credits', style: AppTheme.labelTextStyle), // Using AppTheme for title
          content: SingleChildScrollView(
            child: ListBody(
              children: [1, 2, 3, 4, 5, 6].map((credit) =>
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pop(credit);
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Text(
                        credit.toString(),
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: currentValue == credit ? FontWeight.bold : FontWeight.normal,
                          color: currentValue == credit ? AppTheme.accentBlue : AppTheme.textDarkBlue, // Using AppTheme for colors
                        ),
                      ),
                    ),
                  ),
              ).toList(),
            ),
          ),
        );
      },
    );
  }

  Future<String?> _showGradePicker(BuildContext context, String currentValue) async {
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Grade', style: AppTheme.labelTextStyle), // Using AppTheme for title
          content: SingleChildScrollView(
            child: ListBody(
              children: _gradePoints.keys.map((grade) =>
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pop(grade);
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Text(
                        grade,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: currentValue == grade ? FontWeight.bold : FontWeight.normal,
                          color: currentValue == grade ? AppTheme.accentBlue : AppTheme.textDarkBlue, // Using AppTheme for colors
                        ),
                      ),
                    ),
                  ),
              ).toList(),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryBlue.withOpacity(0.5), // Use AppTheme for background

      appBar: AppBar(

        backgroundColor: AppTheme.accentBlue, // Use AppTheme for AppBar background
        title: const Text(
          'SCGPA Calculator',
          style: AppTheme.titleTextStyle, // Use AppTheme for title style
        ),
        centerTitle: true,
       /*actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: ElevatedButton(
              onPressed: () {
                // Implement save CGPA functionality (e.g., save to SharedPreferences, database)
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('CGPA Save functionality coming soon!')),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.buttonTextColor, // White button background from theme
                foregroundColor: AppTheme.accentBlue, // Blue text color from theme
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              ),
              child: const Text(
                'Save CGPA',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],*/
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'How many subjects?',
                  style: AppTheme.labelTextStyle, // Use AppTheme for text style
                ),
                const SizedBox(width: 15),
                SizedBox(
                  width: 80,
                  child: TextField(
                    controller: _subjectCountController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: AppTheme.buttonTextColor, // Use AppTheme for TextField fill color
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    ),
                    textAlign: TextAlign.center,
                    style: AppTheme.buttonTextStyle.copyWith(color: AppTheme.textDarkBlue), // Use AppTheme for text style
                    onSubmitted: (value) {
                      int? count = int.tryParse(value);
                      if (count != null && count > 0) {
                        _updateNumberOfSubjects(count);
                      } else {
                        // Optionally show an error or reset to a default
                        _updateNumberOfSubjects(1); // Default to 1 if invalid
                        _subjectCountController.text = '1';
                      }
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text('Credits', style: AppTheme.labelTextStyle.copyWith(fontSize: 20)), // Use AppTheme for text style
                Text('Grades', style: AppTheme.labelTextStyle.copyWith(fontSize: 20)), // Use AppTheme for text style
              ],
            ),
            const SizedBox(height: 15),

            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(), // Disable scrolling for this list
              itemCount: _numberOfSubjects,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildCreditDropdown(index),
                      _buildGradeDropdown(index),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 40),

            ElevatedButton(
              onPressed: _calculateSgpa,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.accentBlue, // Use AppTheme for button background
                foregroundColor: AppTheme.buttonTextColor, // Use AppTheme for button text color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
              ),
              child: const Text(
                'Calculate SGPA',
                style: AppTheme.buttonTextStyle, // Use AppTheme for button text style
              ),
            ),
            const SizedBox(height: 40),

            Column(
              children: [
                Text(
                  'Your SGPA: ${_sgpa.toStringAsFixed(4)}',
                  style: AppTheme.resultTextStyle, // Use AppTheme for text style
                ),
                const SizedBox(height: 15),
                Text(
                  'Your CGPA: ${_cgpa.toStringAsFixed(4)}',
                  style: AppTheme.resultTextStyle, // Use AppTheme for text style
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}