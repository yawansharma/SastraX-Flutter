import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
