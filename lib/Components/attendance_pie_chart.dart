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
    super.key,
    required this.attendancePercentage,
    required this.attendedClasses,
    required this.totalClasses,
    required this.bunkingDaysLeft,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        final isDark = themeProvider.isDarkMode;

        return Container(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 8),
          decoration: BoxDecoration(
            color: isDark ? AppTheme.darkSurface : Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: isDark
                ? [
              BoxShadow(
                color: AppTheme.neonBlue.withOpacity(0.5),
                blurRadius: 15,
                spreadRadius: 2,
              ),
            ]
                : [
              const BoxShadow(
                color: Colors.black12,
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Move attendance text up
              Padding(
                padding: const EdgeInsets.only(bottom: 40),
                child: Text(
                  'Attendance',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isDark ? AppTheme.neonBlue : AppTheme.primaryBlue,
                  ),
                ),
              ),

              // Pie chart
              SizedBox(
                height: 80,
                width: 80,
                child: PieChart(
                  PieChartData(
                    pieTouchData: PieTouchData(enabled: false),
                    borderData: FlBorderData(show: false),
                    sectionsSpace: 0,
                    centerSpaceRadius: 25,
                    sections: [
                      PieChartSectionData(
                        color: isDark ? AppTheme.neonBlue : AppTheme.primaryBlue,
                        value: attendancePercentage,
                        title: '${attendancePercentage.toInt()}%',
                        radius: 40,
                        titleStyle: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      PieChartSectionData(
                        color: isDark ? Colors.grey[800]! : Colors.grey[300]!,
                        value: 100 - attendancePercentage,
                        title: '',
                        radius: 32,
                      ),
                    ],
                  ),
                ),
              ),

              // Push stats slightly downward
              const SizedBox(height: 55),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildStat('Attended', '$attendedClasses',
                      isDark ? AppTheme.neonBlue : AppTheme.primaryBlue, isDark),
                  _buildStat('Total', '$totalClasses',
                      isDark ? Colors.white : Colors.black, isDark),
                  _buildStat('Can Skip', '$bunkingDaysLeft',
                      isDark ? AppTheme.electricBlue : Colors.orange, isDark),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStat(String label, String value, Color valueColor, bool dark) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: valueColor,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: dark ? Colors.white70 : Colors.grey[600],
          ),
        ),
      ],
    );
  }
}
