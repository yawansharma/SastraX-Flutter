import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/theme_model.dart';
import '../components/theme_toggle_button.dart';
import '../components/neon_container.dart';
import '../components/attendance_pie_chart.dart';
import 'calendar_page.dart';
import 'community_page.dart';
import 'internals_page.dart';
import 'mess_menu_page.dart';
import 'profile_page.dart';

class HomePage extends StatefulWidget {
  final String regNo;
  const HomePage({Key? key, required this.regNo}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      DashboardScreen(),
      CalendarPage(),
      CommunityPage(),
      MessMenuPage(),
      ProfilePage(regNo: widget.regNo),
    ];
  }

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
          body: _pages[_currentIndex],
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (index) => setState(() => _currentIndex = index),
            backgroundColor: themeProvider.isDarkMode
                ? AppTheme.darkSurface
                : Colors.white,
            elevation: 0,
            type: BottomNavigationBarType.fixed,
            selectedItemColor: themeProvider.isDarkMode
                ? AppTheme.neonBlue
                : AppTheme.primaryBlue,
            unselectedItemColor: themeProvider.isDarkMode
                ? Colors.grey
                : Colors.grey[600],
            items: const [
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
                icon: Icon(Icons.restaurant),
                label: 'Mess Menu',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Profile',
              ),
            ],
          ),
        );
      },
    );
  }
}

class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
          AttendancePieChart(
            attendancePercentage: 85.0,
            attendedClasses: 85,
            totalClasses: 100,
            bunkingDaysLeft: 5,
          ),
          SizedBox(height: 20),
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
                _buildScheduleItem('9:00 AM - 10:00 AM', 'Mathematics', 'Room 101', themeProvider.isDarkMode),
                _buildScheduleItem('10:15 AM - 11:15 AM', 'Physics', 'Lab 2', themeProvider.isDarkMode),
                _buildScheduleItem('11:30 AM - 12:30 PM', 'Computer Science', 'Room 205', themeProvider.isDarkMode),
              ],
            ),
          ),
        ],
      ),
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
