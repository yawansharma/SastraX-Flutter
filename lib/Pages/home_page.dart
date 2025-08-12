import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:confetti/confetti.dart';
import 'package:provider/provider.dart';
import 'subject_wise_attendance.dart';
import '../Components/timetable_widget.dart';
import '../models/theme_model.dart';
import '../components/theme_toggle_button.dart';
import '../components/neon_container.dart';
import '../components/attendance_pie_chart.dart';
import '../components/fee_due_card.dart';
import 'profile_page.dart';
import 'calendar_page.dart';
import 'community_page.dart';
import 'mess_menu_page.dart';
import 'more_options_page.dart';

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
      DashboardScreen(regNo: widget.regNo),
      CalendarPage(regNo: widget.regNo),
      CommunityPage(),
      MessMenuPage(),
      const MoreOptionsScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (_, theme, __) => Scaffold(
        backgroundColor: theme.isDarkMode
            ? AppTheme.darkBackground
            : AppTheme.lightBackground,
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
            BottomNavigationBarItem(icon: Icon(Icons.more_horiz_outlined), label: 'More'),
          ],
        ),
      ),
    );
  }
}

class DashboardScreen extends StatefulWidget {
  final String regNo;
  const DashboardScreen({super.key, required this.regNo});

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
  bool isBirthday = false;
  bool _birthdayChecked = false;

  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _fetchAttendance();
    _fetchCGPA();
    _confettiController = ConfettiController(duration: const Duration(seconds: 3));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_birthdayChecked) {
      _checkBirthday();
      _birthdayChecked = true;
    }
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  Future<void> _checkBirthday() async {
    try {
      final res = await http.get(
        Uri.parse(
          'https://withdrawal-northern-herb-undo.trycloudflare.com/dob?regNo=${widget.regNo}',
        ),
      );

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        final dob = data['dobData']?[0]?['dob'];
        if (dob != null && dob.isNotEmpty) {
          final parsed = DateFormat('dd-MM-yyyy').parse(dob);
          final today = DateTime.now();

          if (parsed.day == today.day && parsed.month == today.month) {
            setState(() => isBirthday = true);
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _confettiController.play();
            });
          }
        }
      } else {
        setState(() => isBirthday = false);
      }
    } catch (_) {
      setState(() => isBirthday = false);
    }
  }

  Future<void> _fetchAttendance() async {
    // Check if data is already loaded to avoid refetching.
    if (attendancePercent >= 0 && totalClasses > 0) return;

    try {
      final res = await http.post(
        Uri.parse('https://kenneth-adsl-education-gamma.trycloudflare.com/attendance'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'refresh': false, 'regNo': widget.regNo}),
      );

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);

        final raw = data['attendanceHTML'] ?? data['attendance'] ?? '0%';
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
    } catch (_) {
      setState(() => attendancePercent = 0);
    }
  }

  Future<void> _fetchCGPA() async {
    // Check if CGPA is already loaded.
    if (cgpa != null && cgpa != 'N/A') {
      setState(() => isCgpaLoading = false);
      return;
    }

    try {
      final res = await http.post(
        Uri.parse('https://kenneth-adsl-education-gamma.trycloudflare.com/cgpa'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'refresh': false}),
      );

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        final cgpaList = data['cgpaData'] ?? data['cgpa'];
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

    return Stack(
      children: [
        CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => ProfilePage(regNo: widget.regNo)),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                  child: NeonContainer(
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 28,
                          backgroundColor: theme.isDarkMode
                              ? AppTheme.neonBlue
                              : AppTheme.primaryBlue,
                          child: Icon(Icons.person,
                              color: theme.isDarkMode ? Colors.black : Colors.white),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (isBirthday)
                                MediaQuery.withClampedTextScaling(
                                  minScaleFactor: 1.0,
                                  maxScaleFactor: 1.0,
                                  child: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Text(
                                      '🎉 Happy Birthday! 🎉',
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.amber,
                                      ),
                                    ),
                                  ),
                                )
                              else
                                Text(
                                  'Welcome Back!',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: theme.isDarkMode
                                        ? AppTheme.neonBlue
                                        : AppTheme.primaryBlue,
                                  ),
                                ),
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
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverToBoxAdapter(
                child: NeonContainer(
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                  child: attendancePercent < 0
                      ? const Center(child: CircularProgressIndicator())
                      : GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => SubjectWiseAttendancePage()),
                    ),
                    child: AttendancePieChart(
                      attendancePercentage: attendancePercent,
                      attendedClasses: attendedClasses,
                      totalClasses: totalClasses,
                      bunkingDaysLeft: bunkLeft,
                    ),
                  ),
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverGrid(
                delegate: SliverChildListDelegate.fixed([
                  _buildAssignmentsTile(theme),
                  _buildGpaFeeTile(theme),
                ]),
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 210,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 1.0,
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
              sliver: SliverToBoxAdapter(
                child: NeonContainer(
                  padding: EdgeInsets.zero,
                  child: TimetableWidget(regNo: widget.regNo),
                ),
              ),
            ),
          ],
        ),
        if (isBirthday)
          Positioned.fill(
            child: Align(
              alignment: Alignment.topCenter,
              child: ConfettiWidget(
                confettiController: _confettiController,
                blastDirectionality: BlastDirectionality.explosive,
                emissionFrequency: 0.05,
                numberOfParticles: 30,
                maxBlastForce: 25,
                minBlastForce: 8,
                gravity: 0.4,
                shouldLoop: false,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildAssignmentsTile(ThemeProvider theme) {
    return NeonContainer(
      padding: const EdgeInsets.all(12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.assignment_turned_in,
              size: 32,
              color: theme.isDarkMode ? AppTheme.neonBlue : AppTheme.primaryBlue),
          const SizedBox(height: 6),
          const Text('Assignments', style: TextStyle(fontWeight: FontWeight.bold)),
          Text('12 Pending',
              style: TextStyle(
                  fontSize: 12,
                  color: theme.isDarkMode ? Colors.white70 : Colors.grey[600])),
        ],
      ),
    );
  }

  Widget _buildGpaFeeTile(ThemeProvider theme) {
    return GestureDetector(
      onTap: () => setState(() => showFeeDue = !showFeeDue),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: showFeeDue
            ? const FeeDueCard(key: ValueKey('fee'), feeDue: 12000)
            : NeonContainer(
          key: const ValueKey('gpa'),
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.grade,
                  size: 24,
                  color: theme.isDarkMode
                      ? AppTheme.electricBlue
                      : Colors.orange),
              const SizedBox(height: 6),
              const Text('GPA', style: TextStyle(fontWeight: FontWeight.bold)),
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
                          : Colors.grey[600])),
            ],
          ),
        ),
      ),
    );
  }
}