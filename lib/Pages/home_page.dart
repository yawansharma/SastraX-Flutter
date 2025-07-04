import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../Components/timetable_widget.dart'; // Ensure this path is correct
import '../models/theme_model.dart';
import '../components/theme_toggle_button.dart';
import '../components/neon_container.dart';
import '../components/attendance_pie_chart.dart';
import '../components/fee_due_card.dart';

import 'profile_page.dart'; // This is the correct import for ProfilePage
import 'calendar_page.dart';
import 'community_page.dart';
import 'mess_menu_page.dart';
import 'more_options_page.dart'; // Import the MoreOptionsPage

class HomePage extends StatefulWidget {
  final String regNo;
  const HomePage({super.key, required this.regNo});

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
      DashboardScreen(regNo: widget.regNo), // Pass regNo to DashboardScreen
      CalendarPage(),
      CommunityPage(),
      MessMenuPage(),
       MoreOptionsPage(), // MoreOptionsPage is now at index 4, corresponding to the 'More' icon
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (_, theme, __) => Scaffold(
        backgroundColor:
        theme.isDarkMode ? AppTheme.darkBackground : AppTheme.lightBackground,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: Image.asset('assets/icon/LogoIcon.png'),
          title: const Text('SastraX', style: TextStyle(fontWeight: FontWeight.bold)),
          centerTitle: true,
          backgroundColor:
          theme.isDarkMode ? AppTheme.darkBackground : AppTheme.primaryBlue,
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
          selectedItemColor:
          theme.isDarkMode ? AppTheme.neonBlue : AppTheme.primaryBlue,
          unselectedItemColor: Colors.grey,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: 'Calendar'),
            BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Community'),
            BottomNavigationBarItem(icon: Icon(Icons.restaurant), label: 'Mess'),
            BottomNavigationBarItem(icon: Icon(Icons.more_horiz_outlined), label: 'More'), // The 'More' icon is at index 4
          ],
        ),
      ),
    );
  }
}

class DashboardScreen extends StatefulWidget {
  final String regNo; // Add regNo parameter
  const DashboardScreen({super.key, required this.regNo}); // Update constructor

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool showFeeDue = false;

  double attendancePercent = -1;
  int attendedClasses = 0;
  int totalClasses = 0;

  String? cgpa;
  bool isCgpaLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchAttendance();
    _fetchCGPA();
  }

  Future<void> _fetchAttendance() async {
    try {
      final res = await http.get(Uri.parse('http://10.0.2.2:3000/attendance'));
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        final raw = data['attendanceHTML'] as String? ?? '0%';
        final percentMatch = RegExp(r'(\d+(?:\.\d+)?)\s*%').firstMatch(raw);
        final pairMatch = RegExp(r'\(\s*(\d+)\s*/\s*(\d+)\s*\)').firstMatch(raw);

        setState(() {
          attendancePercent = double.tryParse(percentMatch?[1] ?? '0') ?? 0.0;
          attendedClasses = int.tryParse(pairMatch?[1] ?? '0') ?? 0;
          totalClasses = int.tryParse(pairMatch?[2] ?? '0') ?? 0;
        });
      } else {
        setState(() => attendancePercent = 0);
      }
    } catch (e) {
      setState(() => attendancePercent = 0);
    }
  }

  Future<void> _fetchCGPA() async {
    try {
      final res = await http.get(Uri.parse('https://dna-attitude-per-eds.trycloudflare.com/cgpa'));
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        final cgpaList = data['cgpaData'];
        if (cgpaList != null && cgpaList.isNotEmpty) {
          setState(() {
            cgpa = cgpaList[0]['cgpa'];
            isCgpaLoading = false;
          });
          return;
        }
      }
    } catch (_) {}
    setState(() {
      cgpa = 'N/A';
      isCgpaLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context);

    final bunkLeft = totalClasses == 0
        ? 0
        : (attendancePercent / 100 * totalClasses - 0.75 * totalClasses)
        .floor()
        .clamp(0, totalClasses);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
<<<<<<< HEAD
          /* Welcome banner - Now tappable to ProfileScreen */
          GestureDetector( // Wrap the entire NeonContainer for a larger tap area
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfilePage(regNo: widget.regNo)),
              );
            },
            child: NeonContainer(
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor:
                    theme.isDarkMode ? AppTheme.neonBlue : AppTheme.primaryBlue,
                    child:
                    Icon(Icons.person, color: theme.isDarkMode ? Colors.black : Colors.white),
=======
          NeonContainer(
            child: Row(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor:
                  theme.isDarkMode ? AppTheme.neonBlue : AppTheme.primaryBlue,
                  child: Icon(Icons.person,
                      color: theme.isDarkMode ? Colors.black : Colors.white),
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
                              color: theme.isDarkMode
                                  ? AppTheme.neonBlue
                                  : AppTheme.primaryBlue)),
                      Text('Student Dashboard',
                          style: TextStyle(
                              color: theme.isDarkMode
                                  ? Colors.white70
                                  : Colors.grey[600]))
                    ],
>>>>>>> a6623e564f35fe398ded725ac0e0f8ce6ea2e578
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
                                color: theme.isDarkMode
                                    ? AppTheme.neonBlue
                                    : AppTheme.primaryBlue)),
                        Text('Student Dashboard',
                            style: TextStyle(
                                color: theme.isDarkMode
                                    ? Colors.white70
                                    : Colors.grey[600]))
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: NeonContainer(
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                  child: attendancePercent < 0
                      ? const Center(child: CircularProgressIndicator())
                      : AttendancePieChart(
                    attendancePercentage: attendancePercent,
                    attendedClasses: attendedClasses,
                    totalClasses: totalClasses,
                    bunkingDaysLeft: bunkLeft,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 1,
                child: SizedBox(
                  height: 240,
                  child: Column(
                    children: [
                      Expanded(
                        child: NeonContainer(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.assignment_turned_in,
                                  size: 28,
                                  color: theme.isDarkMode
                                      ? AppTheme.neonBlue
                                      : AppTheme.primaryBlue),
                              const SizedBox(height: 4),
                              const Text('Assignments',
                                  style: TextStyle(fontWeight: FontWeight.bold)),
                              Text('12 Pending',
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: theme.isDarkMode
                                          ? Colors.white70
                                          : Colors.grey[600]))
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => showFeeDue = !showFeeDue),
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 300),
                            child: showFeeDue
                                ? const FeeDueCard(
                                key: ValueKey('fee'), feeDue: 12000)
                                : NeonContainer(
                              key: const ValueKey('gpa'),
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.grade,
                                      size: 18,
                                      color: theme.isDarkMode
                                          ? AppTheme.electricBlue
                                          : Colors.orange),
                                  const SizedBox(height: 4),
                                  const Text('GPA',
                                      style: TextStyle(fontWeight: FontWeight.bold)),
                                  isCgpaLoading
                                      ? const SizedBox(
                                    height: 16,
                                    width: 16,
                                    child: CircularProgressIndicator(strokeWidth: 2),
                                  )
                                      : Text('$cgpa / 10',
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: theme.isDarkMode
                                              ? Colors.white70
                                              : Colors.grey[600]))
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
<<<<<<< HEAD



          /* Today’s Timetable Section (Styled as per image) ----------------------------------------------- */
          Container
            (
            decoration: BoxDecoration(
              color: theme.isDarkMode ? AppTheme.darkSurface : Colors.white, // Background for the whole timetable section
              borderRadius: BorderRadius.circular(15), // Overall rounded corners for the timetable section
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
=======
          const SizedBox(height: 20),
          NeonContainer(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Today’s Schedule',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: theme.isDarkMode
                            ? AppTheme.neonBlue
                            : AppTheme.primaryBlue)),
                const SizedBox(height: 16),
                _scheduleItem(context, '9:00 AM – 10:00 AM', 'Mathematics', 'Room 101'),
                _scheduleItem(context, '10:15 AM – 11:15 AM', 'Physics', 'Lab 2'),
                _scheduleItem(context, '11:30 AM – 12:30 PM', 'Computer Science', 'Room 205'),
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
>>>>>>> a6623e564f35fe398ded725ac0e0f8ce6ea2e578
            child: Column(
              children: [


                // Timetable content - The TimetableWidget is expected to contain the scrollable list of subject boxes
                // We give it a constrained height using SizedBox to enable its internal scrolling.
                 SizedBox
                   (
                  height: 400, // Adjust this height as needed to fit your design
                  child: TimetableWidget(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
