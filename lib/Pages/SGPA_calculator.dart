import 'package:flutter/material.dart';

class SgpaCalculatorPage extends StatefulWidget {
  String backendUrl;
   SgpaCalculatorPage({super.key, required this.backendUrl});

  @override
  State<SgpaCalculatorPage> createState() => _SgpaCalculatorPageState();
}

class _SgpaCalculatorPageState extends State<SgpaCalculatorPage> {
  final Map<String, double> _gradePoints = {
    'S': 10.0,
    'A+': 9.0,
    'A': 8.0,
    'B+': 7.0,
    'B': 6.0,
    'C': 5.0,
    'D': 4.0,
    'F': 0.0,
    'N': 0.0,
  };

  List<Map<String, dynamic>> _subjects = [];
  double _sgpa = 0.0;

  @override
  void initState() {
    super.initState();
    _subjects = List.generate(5, (_) => {'credits': 0, 'grade': ''});
  }

  void _addSubject() {
    setState(() {
      _subjects.add({'credits': 0, 'grade': ''});
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
      if (subject['credits'] != 0 && subject['grade'].isNotEmpty) {
        final credit = subject['credits'] as int;
        final grade = subject['grade'] as String;
        final gradePoint = _gradePoints[grade] ?? 0.0;
        totalGradePoints += credit * gradePoint;
        totalCredits += credit;
      }
    }

    setState(() {
      _sgpa = totalCredits > 0 ? totalGradePoints / totalCredits : 0.0;
    });
  }

  Widget _buildSubjectCard(BuildContext context, int index) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: theme.colorScheme.secondary.withOpacity(0.2),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'Subject ${index + 1} ->',
              style: theme.textTheme.bodyMedium,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 10),
          _buildPickerBox(
            context,
            text: _subjects[index]['credits'] == 0
                ? 'Credits'
                : _subjects[index]['credits'].toString(),
            onTap: () => _showCreditPicker(index),
          ),
          const SizedBox(width: 10),
          _buildPickerBox(
            context,
            text: _subjects[index]['grade'].isEmpty
                ? 'Grades'
                : _subjects[index]['grade'],
            onTap: () => _showGradePicker(index),
          ),
          const SizedBox(width: 10),
          InkWell(
            onTap: () => _removeSubject(index),
            child: Icon(Icons.close, color: theme.colorScheme.onSurface),
          ),
        ],
      ),
    );
  }

  Widget _buildPickerBox(BuildContext context,
      {required String text, required VoidCallback onTap}) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 45,
        width: 70,
        decoration: BoxDecoration(
          color: theme.colorScheme.primary.withOpacity(0.3),
          borderRadius: BorderRadius.circular(10),
          border:
          Border.all(color: theme.colorScheme.secondary.withOpacity(0.5)),
        ),
        alignment: Alignment.center,
        child: Text(text, style: theme.textTheme.bodyMedium),
      ),
    );
  }

  Future<void> _showCreditPicker(int index) async {
    final selectedCredit = await showDialog<int>(
      context: context,
      builder: (BuildContext context) {
        final theme = Theme.of(context);
        return AlertDialog(
          backgroundColor: theme.dialogBackgroundColor,
          title: Text('Select Credits', style: theme.textTheme.bodyLarge),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [1, 2, 3, 4, 5, 6]
                .map((credit) => ListTile(
              title: Text(credit.toString(),
                  style: theme.textTheme.bodyMedium),
              onTap: () => Navigator.of(context).pop(credit),
            ))
                .toList(),
          ),
        );
      },
    );
    if (selectedCredit != null) _updateCredit(index, selectedCredit);
  }

  Future<void> _showGradePicker(int index) async {
    final selectedGrade = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        final theme = Theme.of(context);
        return AlertDialog(
          backgroundColor: theme.dialogBackgroundColor,
          title: Text('Select Grade', style: theme.textTheme.bodyLarge),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: _gradePoints.keys
                .map((grade) => ListTile(
              title: Text(grade, style: theme.textTheme.bodyMedium),
              onTap: () => Navigator.of(context).pop(grade),
            ))
                .toList(),
          ),
        );
      },
    );
    if (selectedGrade != null) _updateGrade(index, selectedGrade);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('SGPA Calculator', style: theme.textTheme.titleLarge),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('SGPA Predictor', style: theme.textTheme.headlineSmall),
            const SizedBox(height: 5),
            Text(
              'Calculate your SGPA based on credits and expected grade.',
              style: theme.textTheme.bodySmall,
            ),
            const SizedBox(height: 20),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _subjects.length,
              itemBuilder: (context, index) =>
                  _buildSubjectCard(context, index),
            ),
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: theme.colorScheme.secondary.withOpacity(0.2),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Text(
                'Expected SGPA: ${_sgpa.toStringAsFixed(4)}',
                textAlign: TextAlign.center,
                style: theme.textTheme.titleMedium,
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton.icon(
                onPressed: _addSubject,
                icon: const Icon(Icons.add),
                label: const Text('Add subject'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
