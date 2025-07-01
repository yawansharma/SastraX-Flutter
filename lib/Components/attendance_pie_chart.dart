import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import '../models/theme_model.dart';

class AttendancePieChart extends StatelessWidget {
  final double attendancePercentage;
  final int attendedClasses;
  final int totalClasses;
  final int bunkingDaysLeft;

  const AttendancePieChart({
    Key? key,
    required this.attendancePercentage,
    required this.attendedClasses,
    required this.totalClasses,
    required this.bunkingDaysLeft,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: themeProvider.isDarkMode
                ? AppTheme.darkSurface
                : Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: themeProvider.isDarkMode
                ? [
              BoxShadow(
                color: AppTheme.neonBlue.withOpacity(0.5),
                blurRadius: 15,
                spreadRadius: 2,
              ),
            ]
                : [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Stack(
            children: [
              // Background glow effect for dark mode
              if (themeProvider.isDarkMode)
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: RadialGradient(
                        colors: [
                          AppTheme.neonBlue.withOpacity(0.3),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),

              Column(
                children: [
                  Text(
                    'Attendance',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: themeProvider.isDarkMode
                          ? AppTheme.neonBlue
                          : AppTheme.primaryBlue,
                    ),
                  ),
                  SizedBox(height: 20),
                  SizedBox(
                    height: 200,
                    child: PieChart(
                      PieChartData(
                        pieTouchData: PieTouchData(enabled: false),
                        borderData: FlBorderData(show: false),
                        sectionsSpace: 0,
                        centerSpaceRadius: 60,
                        sections: [
                          PieChartSectionData(
                            color: themeProvider.isDarkMode
                                ? AppTheme.neonBlue
                                : AppTheme.primaryBlue,
                            value: attendancePercentage,
                            title: '${attendancePercentage.toInt()}%',
                            radius: 50,
                            titleStyle: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          PieChartSectionData(
                            color: themeProvider.isDarkMode
                                ? Colors.grey[800]!
                                : Colors.grey[300]!,
                            value: 100 - attendancePercentage,
                            title: '',
                            radius: 50,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          Text(
                            '$attendedClasses',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: themeProvider.isDarkMode
                                  ? AppTheme.neonBlue
                                  : AppTheme.primaryBlue,
                            ),
                          ),
                          Text(
                            'Attended',
                            style: TextStyle(
                              color: themeProvider.isDarkMode
                                  ? Colors.white70
                                  : Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Text(
                            '$totalClasses',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: themeProvider.isDarkMode
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                          Text(
                            'Total',
                            style: TextStyle(
                              color: themeProvider.isDarkMode
                                  ? Colors.white70
                                  : Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Text(
                            '$bunkingDaysLeft',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: themeProvider.isDarkMode
                                  ? AppTheme.electricBlue
                                  : Colors.orange,
                            ),
                          ),
                          Text(
                            'Can Skip',
                            style: TextStyle(
                              color: themeProvider.isDarkMode
                                  ? Colors.white70
                                  : Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

