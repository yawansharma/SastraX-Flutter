import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/theme_model.dart';
import '../models/theme_model.dart';
import '../components/theme_toggle_button.dart';
import '../components/neon_container.dart';
import '../components/attendance_pie_chart.dart';
import 'profile_page.dart';
import 'calendar_page.dart';
import 'community_page.dart';
import 'internals_page.dart';
import 'mess_menu_page.dart';
import 'more_options_page.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return Scaffold(
          backgroundColor: themeProvider.isDarkMode
              ? AppTheme.darkBackground
              : AppTheme.lightBackground,
          appBar: AppBar(
            title: Text(
              'SASTRAX',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: themeProvider.isDarkMode
                    ? AppTheme.neonBlue
                    : Colors.white,
              ),
            ),
            backgroundColor: themeProvider.isDarkMode
                ? AppTheme.darkBackground
                : AppTheme.primaryBlue,
            elevation: 0,
            actions: [
              Padding(
                padding: EdgeInsets.only(right: 16),
                child: ThemeToggleButton(
                  isDarkMode: themeProvider.isDarkMode,
                  onToggle: themeProvider.toggleTheme,
                ),
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Welcome Section
                NeonContainer(
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: themeProvider.isDarkMode
                            ? AppTheme.neonBlue
                            : AppTheme.primaryBlue,
                        child: Icon(
                          Icons.person,
                          color: themeProvider.isDarkMode
                              ? Colors.black
                              : Colors.white,
                          size: 30,
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Welcome Back!',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: themeProvider.isDarkMode
                                    ? AppTheme.neonBlue
                                    : AppTheme.primaryBlue,
                              ),
                            ),
                            Text(
                              'Student Dashboard',
                              style: TextStyle(
                                color: themeProvider.isDarkMode
                                    ? Colors.white70
                                    : Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 20),

                // Attendance Chart
                AttendancePieChart(
                  attendancePercentage: 85.0,
                  attendedClasses: 85,
                  totalClasses: 100,
                  bunkingDaysLeft: 5,
                ),

                SizedBox(height: 20),

                // Quick Stats
                Row(
                  children: [
                    Expanded(
                      child: NeonContainer(
                        child: Column(
                          children: [
                            Icon(
                              Icons.assignment_turned_in,
                              size: 40,
                              color: themeProvider.isDarkMode
                                  ? AppTheme.neonBlue
                                  : AppTheme.primaryBlue,
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Assignments',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: themeProvider.isDarkMode
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                            Text(
                              '12 Pending',
                              style: TextStyle(
                                color: themeProvider.isDarkMode
                                    ? Colors.white70
                                    : Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: NeonContainer(
                        child: Column(
                          children: [
                            Icon(
                              Icons.grade,
                              size: 40,
                              color: themeProvider.isDarkMode
                                  ? AppTheme.electricBlue
                                  : Colors.orange,
                            ),
                            SizedBox(height: 8),
                            Text(
                              'GPA',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: themeProvider.isDarkMode
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                            Text(
                              '8.5/10',
                              style: TextStyle(
                                color: themeProvider.isDarkMode
                                    ? Colors.white70
                                    : Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 20),

                // Today's Schedule
                NeonContainer(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Today\'s Schedule',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: themeProvider.isDarkMode
                              ? AppTheme.neonBlue
                              : AppTheme.primaryBlue,
                        ),
                      ),
                      SizedBox(height: 16),
                      _buildScheduleItem(
                        '9:00 AM - 10:00 AM',
                        'Mathematics',
                        'Room 101',
                        themeProvider.isDarkMode,
                      ),
                      _buildScheduleItem(
                        '10:15 AM - 11:15 AM',
                        'Physics',
                        'Lab 2',
                        themeProvider.isDarkMode,
                      ),
                      _buildScheduleItem(
                        '11:30 AM - 12:30 PM',
                        'Computer Science',
                        'Room 205',
                        themeProvider.isDarkMode,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          bottomNavigationBar: Container(
            decoration: BoxDecoration(
              color: themeProvider.isDarkMode
                  ? AppTheme.darkSurface
                  : Colors.white,
              boxShadow: themeProvider.isDarkMode
                  ? [
                BoxShadow(
                  color: AppTheme.neonBlue.withOpacity(0.2),
                  blurRadius: 10,
                  offset: Offset(0, -2),
                ),
              ]
                  : [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 8,
                  offset: Offset(0, -2),
                ),
              ],
            ),
            child: BottomNavigationBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              type: BottomNavigationBarType.fixed,
              selectedItemColor: themeProvider.isDarkMode
                  ? AppTheme.neonBlue
                  : AppTheme.primaryBlue,
              unselectedItemColor: themeProvider.isDarkMode
                  ? Colors.grey
                  : Colors.grey[600],
              items: [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.calendar_today),
                  label: 'Calendar',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.people),
                  label: 'Community',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person),
                  label: 'Profile',
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildScheduleItem(String time, String subject, String room, bool isDarkMode) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 40,
            decoration: BoxDecoration(
              color: isDarkMode ? AppTheme.neonBlue : AppTheme.primaryBlue,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  subject,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
                Text(
                  '$time • $room',
                  style: TextStyle(
                    color: isDarkMode ? Colors.white70 : Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
