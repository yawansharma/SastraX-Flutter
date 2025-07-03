import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/theme_model.dart';
import '../components/theme_toggle_button.dart';
import '../components/neon_container.dart';
import '../components/attendance_pie_chart.dart';
import '../components/fee_due_card.dart';
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
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      const DashboardScreen(),
      CalendarPage(),
      CommunityPage(),
      MessMenuPage(),
      ProfilePage(regNo: widget.regNo),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, theme, child) => Scaffold(
        backgroundColor: theme.isDarkMode ? AppTheme.darkBackground : AppTheme.lightBackground,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: Image.asset('assets/icon/LogoIcon.png'),
          title: const Text('SastraX', style: TextStyle(fontWeight: FontWeight.bold)),
          centerTitle: true,
          backgroundColor: theme.isDarkMode ? AppTheme.darkBackground : AppTheme.primaryBlue,
          elevation: 0,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: ThemeToggleButton(
                isDarkMode: theme.isDarkMode,
                onToggle: theme.toggleTheme,
              ),
            ),
          ],
        ),
        body: _pages[_currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (i) => setState(() => _currentIndex = i),
          type: BottomNavigationBarType.fixed,
          backgroundColor: theme.isDarkMode ? AppTheme.darkSurface : Colors.white,
          selectedItemColor: theme.isDarkMode ? AppTheme.neonBlue : AppTheme.primaryBlue,
          unselectedItemColor: Colors.grey,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: 'Calendar'),
            BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Community'),
            BottomNavigationBarItem(icon: Icon(Icons.restaurant), label: 'Mess Menu'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          ],
        ),
      ),
    );
  }
}

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool _showFeeDue = false;

  void _toggleFee() {
    setState(() {
      _showFeeDue = !_showFeeDue;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          NeonContainer(
            child: Row(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: theme.isDarkMode ? AppTheme.neonBlue : AppTheme.primaryBlue,
                  child: Icon(Icons.person, color: theme.isDarkMode ? Colors.black : Colors.white),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Welcome Back!',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: theme.isDarkMode ? AppTheme.neonBlue : AppTheme.primaryBlue)),
                      Text('Student Dashboard',
                          style: TextStyle(color: theme.isDarkMode ? Colors.white70 : Colors.grey[600]))
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  flex: 2,
                  child: NeonContainer(
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                    child: const AttendancePieChart(
                      attendancePercentage: 85,
                      attendedClasses: 85,
                      totalClasses: 100,
                      bunkingDaysLeft: 5,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 1,
                  child: Column(
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Expanded(
                              child: NeonContainer(
                                padding: const EdgeInsets.all(12),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.assignment_turned_in,
                                        size: 28,
                                        color: theme.isDarkMode ? AppTheme.neonBlue : AppTheme.primaryBlue),
                                    const SizedBox(height: 4),
                                    const Text('Assignments', style: TextStyle(fontWeight: FontWeight.bold)),
                                    Text('12 Pending',
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: theme.isDarkMode ? Colors.white70 : Colors.grey[600])),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      Expanded(
                        child: Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: _toggleFee,
                                child: NeonContainer(
                                  padding: const EdgeInsets.all(12),
                                  child: _showFeeDue
                                      ? FeeDueCard(feeDue: 5000)
                                      : Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.grade,
                                          size: 28,
                                          color: theme.isDarkMode
                                              ? AppTheme.electricBlue
                                              : Colors.orange),
                                      const SizedBox(height: 4),
                                      const Text('GPA',
                                          style: TextStyle(fontWeight: FontWeight.bold)),
                                      Text('8.5/10',
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: theme.isDarkMode
                                                  ? Colors.white70
                                                  : Colors.grey[600])),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          NeonContainer(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Today’s Schedule',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: theme.isDarkMode ? AppTheme.neonBlue : AppTheme.primaryBlue)),
                const SizedBox(height: 16),
                _scheduleItem(context, '9:00 AM – 10:00 AM', 'Mathematics', 'Room 101'),
                _scheduleItem(context, '10:15 AM – 11:15 AM', 'Physics', 'Lab 2'),
                _scheduleItem(context, '11:30 AM – 12:30 PM', 'Computer Science', 'Room 205'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _scheduleItem(BuildContext context, String time, String subject, String room) {
    final theme = Provider.of<ThemeProvider>(context, listen: false);
    final dark = theme.isDarkMode;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 40,
            decoration: BoxDecoration(
              color: dark ? AppTheme.neonBlue : AppTheme.primaryBlue,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(subject,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: dark ? Colors.white : Colors.black)),
                Text('$time • $room',
                    style: TextStyle(fontSize: 12, color: dark ? Colors.white70 : Colors.grey[600]))
              ],
            ),
          ),
        ],
      ),
    );
  }
}
