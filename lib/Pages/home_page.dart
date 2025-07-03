import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/theme_model.dart';
import '../components/theme_toggle_button.dart';
import '../components/attendance_pie_chart.dart';
import '../components/fee_due_card.dart';
import '../components/timetable_widget.dart';
import 'profile_page.dart';
import 'calendar_page.dart';
import 'community_page.dart';
import 'internals_page.dart';
import 'mess_menu_page.dart';
import 'more_options_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  
  final List<Widget> _pages = [
    HomeContent(),
    CalendarPage(),
    CommunityPage(),
    InternalsPage(),
    MessMenuPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return Scaffold(
          backgroundColor: themeProvider.backgroundColor,
          appBar: AppBar(
            backgroundColor: themeProvider.appBarBackgroundColor,
            elevation: 0,
            title: Text(
              'STUDENT DASHBOARD',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: themeProvider.isDarkMode ? AppTheme.neonBlue : Colors.white,
                fontSize: 20,
              ),
            ),
            actions: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ProfilePage()),
                  );
                },
                child: Container(
                  margin: EdgeInsets.only(right: 16),
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: themeProvider.isDarkMode
                        ? LinearGradient(colors: [AppTheme.neonBlue, AppTheme.electricBlue])
                        : LinearGradient(colors: [Colors.white, Colors.blue[100]!]),
                    border: Border.all(
                      color: themeProvider.isDarkMode ? AppTheme.neonBlue : Colors.blue, 
                      width: 2,
                    ),
                    boxShadow: themeProvider.isDarkMode
                        ? [
                            BoxShadow(
                              color: AppTheme.neonBlue.withOpacity(0.5),
                              blurRadius: 10,
                              spreadRadius: 2,
                            ),
                          ]
                        : null,
                  ),
                  child: Icon(
                    Icons.person,
                    color: themeProvider.isDarkMode ? Colors.black : AppTheme.navyBlue,
                    size: 24,
                  ),
                ),
              ),
            ],
          ),
          body: _pages[_selectedIndex],
          bottomNavigationBar: Container(
            decoration: BoxDecoration(
              color: themeProvider.cardBackgroundColor,
              border: themeProvider.isDarkMode
                  ? Border(top: BorderSide(color: AppTheme.neonBlue.withOpacity(0.3)))
                  : null,
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
              currentIndex: _selectedIndex,
              onTap: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
              selectedItemColor: themeProvider.primaryColor,
              unselectedItemColor: themeProvider.textSecondaryColor,
              selectedLabelStyle: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
              items: [
                BottomNavigationBarItem(
                  icon: _buildNavIcon(Icons.home, 0, themeProvider),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: _buildNavIcon(Icons.calendar_today, 1, themeProvider),
                  label: 'Calendar',
                ),
                BottomNavigationBarItem(
                  icon: _buildNavIcon(Icons.people, 2, themeProvider),
                  label: 'Community',
                ),
                BottomNavigationBarItem(
                  icon: _buildNavIcon(Icons.assessment, 3, themeProvider),
                  label: 'Internals',
                ),
                BottomNavigationBarItem(
                  icon: _buildNavIcon(Icons.restaurant, 4, themeProvider),
                  label: 'Mess Menu',
                ),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MoreOptionsPage()),
              );
            },
            backgroundColor: themeProvider.primaryColor,
            child: Icon(
              Icons.more_horiz,
              color: themeProvider.isDarkMode ? Colors.black : Colors.white,
            ),
          ),
        );
      },
    );
  }

  Widget _buildNavIcon(IconData icon, int index, ThemeProvider themeProvider) {
    bool isSelected = _selectedIndex == index;
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: isSelected && themeProvider.isDarkMode
            ? RadialGradient(
                colors: [
                  AppTheme.neonBlue.withOpacity(0.3),
                  Colors.transparent,
                ],
              )
            : null,
        boxShadow: isSelected && themeProvider.isDarkMode
            ? [
                BoxShadow(
                  color: AppTheme.neonBlue.withOpacity(0.5),
                  blurRadius: 15,
                  spreadRadius: 2,
                ),
              ]
            : null,
      ),
      child: Icon(
        icon,
        size: 24,
        color: isSelected 
            ? themeProvider.primaryColor 
            : themeProvider.textSecondaryColor,
      ),
    );
  }
}

class HomeContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 20),
              // Top section with attendance and fee
              Container(
                margin: EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: AttendancePieChart(
                        attendancePercentage: 85.0,
                        attendedClasses: 85,
                        totalClasses: 100,
                        bunkingDaysLeft: 5,
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      flex: 1,
                      child: FeeDueCard(feeDue: 0),
                    ),
                  ],
                ),
              ),
              
              SizedBox(height: 20),
              
              // Timetable
              TimetableWidget(),
            ],
          ),
        );
      },
    );
  }
}
