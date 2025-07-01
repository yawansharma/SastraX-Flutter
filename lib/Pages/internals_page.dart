import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/theme_model.dart';

class InternalsPage extends StatelessWidget {
  final List<Map<String, dynamic>> subjects = [
    {
      'name': 'CA',
      'internal1': 18,
      'internal2': 22,
      'internal3': 20,
      'total': 60,
      'maxMarks': 75,
    },
    {
      'name': 'CO',
      'internal1': 20,
      'internal2': 19,
      'internal3': 23,
      'total': 62,
      'maxMarks': 75,
    },
    {
      'name': 'CN',
      'internal1': 17,
      'internal2': 21,
      'internal3': 19,
      'total': 57,
      'maxMarks': 75,
    },
    {
      'name': 'Computer Science',
      'internal1': 24,
      'internal2': 23,
      'internal3': 22,
      'total': 69,
      'maxMarks': 75,
    },
    {
      'name': 'DAA',
      'internal1': 19,
      'internal2': 20,
      'internal3': 21,
      'total': 60,
      'maxMarks': 75,
    },
    {
      'name': 'CODING',
      'internal1': 16,
      'internal2': 18,
      'internal3': 20,
      'total': 54,
      'maxMarks': 75,
    },
    {
      'name': 'PYTHON',
      'internal1': 22,
      'internal2': 20,
      'internal3': 18,
      'total': 60,
      'maxMarks': 75,
    },
  ];

  Color _getGradeColor(double percentage) {
    if (percentage >= 80) return Colors.green;
    if (percentage >= 70) return Colors.blue;
    if (percentage >= 60) return Colors.orange;
    return Colors.red;
  }

  String _getGrade(double percentage) {
    if (percentage >= 80) return 'A';
    if (percentage >= 70) return 'B';
    if (percentage >= 60) return 'C';
    return 'D';
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return Scaffold(
          backgroundColor: themeProvider.backgroundColor,
          appBar: AppBar(
            title: Text(
              'Internal Marks',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: themeProvider.isDarkMode ? AppTheme.neonBlue : Colors.white,
              ),
            ),
            backgroundColor: themeProvider.appBarBackgroundColor,
            iconTheme: IconThemeData(
              color: themeProvider.isDarkMode ? AppTheme.neonBlue : Colors.white,
            ),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.all(16),
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: themeProvider.cardBackgroundColor,
                    borderRadius: BorderRadius.circular(20),
                    border: themeProvider.isDarkMode
                        ? Border.all(color: AppTheme.neonBlue.withOpacity(0.3))
                        : null,
                    boxShadow: themeProvider.isDarkMode
                        ? [
                            BoxShadow(
                              color: AppTheme.neonBlue.withOpacity(0.2),
                              blurRadius: 15,
                              spreadRadius: 2,
                            ),
                          ]
                        : [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 10,
                              offset: Offset(0, 5),
                            ),
                          ],
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Overall Performance',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: themeProvider.textColor,
                        ),
                      ),
                      SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildStatCard('Total Subjects', '7', Icons.book, themeProvider),
                          _buildStatCard('Average', '78%', Icons.trending_up, themeProvider),
                          _buildStatCard('Grade', 'B+', Icons.star, themeProvider),
                        ],
                      ),
                    ],
                  ),
                ),
                
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: themeProvider.cardBackgroundColor,
                    borderRadius: BorderRadius.circular(20),
                    border: themeProvider.isDarkMode
                        ? Border.all(color: AppTheme.neonBlue.withOpacity(0.3))
                        : null,
                    boxShadow: themeProvider.isDarkMode
                        ? [
                            BoxShadow(
                              color: AppTheme.neonBlue.withOpacity(0.2),
                              blurRadius: 15,
                              spreadRadius: 2,
                            ),
                          ]
                        : [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 10,
                              offset: Offset(0, 5),
                            ),
                          ],
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          gradient: themeProvider.isDarkMode
                              ? LinearGradient(colors: [Colors.black, Color(0xFF1A1A1A)])
                              : LinearGradient(colors: [AppTheme.navyBlue, Color(0xFF3b82f6)]),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.assessment, 
                              color: themeProvider.isDarkMode ? AppTheme.neonBlue : Colors.white,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Subject-wise Internal Marks',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: themeProvider.isDarkMode ? AppTheme.neonBlue : Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: subjects.length,
                        itemBuilder: (context, index) {
                          final subject = subjects[index];
                          double percentage = (subject['total'] / subject['maxMarks']) * 100;
                          
                          return Container(
                            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: themeProvider.isDarkMode 
                                  ? themeProvider.surfaceColor
                                  : Colors.grey[50],
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: themeProvider.isDarkMode 
                                    ? themeProvider.primaryColor.withOpacity(0.3)
                                    : Colors.grey[200]!,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      subject['name'],
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: themeProvider.textColor,
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: _getGradeColor(percentage),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        _getGrade(percentage),
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 12),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    _buildInternalMark('IA1', subject['internal1'], themeProvider),
                                    _buildInternalMark('IA2', subject['internal2'], themeProvider),
                                    _buildInternalMark('IA3', subject['internal3'], themeProvider),
                                  ],
                                ),
                                SizedBox(height: 12),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Total: ${subject['total']}/${subject['maxMarks']}',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: themeProvider.textColor,
                                      ),
                                    ),
                                    Text(
                                      '${percentage.toStringAsFixed(1)}%',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: _getGradeColor(percentage),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 8),
                                LinearProgressIndicator(
                                  value: percentage / 100,
                                  backgroundColor: themeProvider.isDarkMode 
                                      ? Colors.grey[800]
                                      : Colors.grey[300],
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    _getGradeColor(percentage),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      SizedBox(height: 16),
                    ],
                  ),
                ),
                
                SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, ThemeProvider themeProvider) {
    return Column(
      children: [
        Icon(
          icon, 
          color: themeProvider.primaryColor, 
          size: 30,
        ),
        SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: themeProvider.textColor,
          ),
        ),
        Text(
          title,
          style: TextStyle(
            fontSize: 12,
            color: themeProvider.textSecondaryColor,
          ),
        ),
      ],
    );
  }

  Widget _buildInternalMark(String label, int marks, ThemeProvider themeProvider) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: themeProvider.textSecondaryColor,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 4),
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: themeProvider.isDarkMode 
                ? themeProvider.primaryColor.withOpacity(0.2)
                : Colors.blue[100],
            borderRadius: BorderRadius.circular(8),
            border: themeProvider.isDarkMode
                ? Border.all(color: themeProvider.primaryColor.withOpacity(0.5))
                : null,
          ),
          child: Center(
            child: Text(
              marks.toString(),
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: themeProvider.isDarkMode ? themeProvider.primaryColor : AppTheme.navyBlue,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
