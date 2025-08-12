import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../models/theme_model.dart';

class MessMenuPage extends StatefulWidget {
  @override
  State<MessMenuPage> createState() => _MessMenuPageState();
}

class _MessMenuPageState extends State<MessMenuPage> {
  final List<String> weekDays = ['SUN', 'MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT'];

  late final PageController _pageController;
  List<dynamic> _fullMenu = [];
  List<dynamic> _filtered = [];
  bool isLoading = true;

  late String selectedWeek;   // "1".."4"
  late String selectedDayAbbr;

  @override
  void initState() {
    super.initState();

    final now = DateTime.now();
    final todayIdx = now.weekday % 7; // Sunday = 0
    selectedDayAbbr = weekDays[todayIdx];
    _pageController = PageController(initialPage: todayIdx);

    selectedWeek = weekOfMonth(now).toString(); // 1‑4
    _fetchMenu();
  }
  int weekOfMonth(DateTime date) {
    final firstDay = DateTime(date.year, date.month, 1);
    final before = firstDay.weekday % 7;            // days before the 1st in week 1
    final week = ((before + date.day - 1) ~/ 7) + 1; // 1‑5
    return (week - 1) % 4 + 1;                       // wrap to 1‑4
  }

  Future<void> _fetchMenu() async {
    try {
      final res = await http.get(Uri.parse(
          'https://feel-commercial-managed-laws.trycloudflare.com/messMenu'));

      if (res.statusCode != 200) throw Exception('HTTP ${res.statusCode}');

      _fullMenu = jsonDecode(res.body);
      _applyWeekFilter();
    } catch (e) {
      if (mounted) {
        setState(() => isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Couldn’t load menu: $e')),
        );
      }
    }
  }

  void _applyWeekFilter() {
    _filtered = _fullMenu
        .where((d) => d['week'].toString() == selectedWeek) // ← cast to string
        .toList()
      ..sort((a, b) => _dayIndex(a['day']).compareTo(_dayIndex(b['day'])));

    setState(() => isLoading = false);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final todayPos = _filtered.indexWhere((d) =>
      d['day'].toString().substring(0, 3).toUpperCase() == selectedDayAbbr);
      if (_pageController.hasClients && todayPos != -1) {
        _pageController.jumpToPage(todayPos);
      }
    });
  }

  int _dayIndex(String day) =>
      weekDays.indexOf(day.substring(0, 3).toUpperCase());

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (_, theme, __) => Scaffold(
        backgroundColor: theme.backgroundColor,
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : _filtered.isEmpty
            ? const Center(child: Text('No menu found for this week'))
            : Column(
          children: [
            const SizedBox(height: 50),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  _dayRow(theme, 0, 4),
                  const SizedBox(height: 10),
                  _dayRow(theme, 4, 7),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _filtered.length,
                itemBuilder: (_, idx) => _buildDayMenu(idx, theme),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDayMenu(int idx, ThemeProvider theme) {
    final day = _filtered[idx];
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      children: [
        _mealCard('Breakfast', day['breakfast'].join(', '), theme),
        _mealCard('Lunch', day['lunch'].join(', '), theme),
        _mealCard('Snacks', day['snacks'].join(', '), theme),
        _mealCard('Dinner', day['dinner'].join(', '), theme),
      ],
    );
  }

  Widget _dayRow(ThemeProvider theme, int start, int end) {
    return Row(
      children: weekDays.sublist(start, end).map((abbr) {
        final isSel = selectedDayAbbr == abbr;
        return Expanded(
          child: GestureDetector(
            onTap: () {
              final newPage = _filtered.indexWhere((d) =>
              d['day'].toString().substring(0, 3).toUpperCase() == abbr);
              if (newPage != -1) {
                setState(() => selectedDayAbbr = abbr);
                if (_pageController.hasClients) _pageController.jumpToPage(newPage);
              }
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: isSel
                    ? (theme.isDarkMode ? Colors.amber[300] : Colors.blueAccent)
                    : theme.cardBackgroundColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
                  abbr,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isSel
                        ? (theme.isDarkMode ? Colors.black : Colors.white)
                        : theme.textColor,
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _mealCard(String title, String menu, ThemeProvider theme) {

    final palette = {
      'Breakfast': {
        'color': theme.isDarkMode ? const Color(0xFFFFD93D) : Colors.orange[300],
        'icon': Icons.wb_sunny,
        'bg': 'assets/images/sunrise.jpg'
      },
      'Lunch': {
        'color': theme.isDarkMode ? AppTheme.neonBlue : Colors.green[300],
        'icon': Icons.lunch_dining,
        'bg': 'assets/images/sunshine.jpg'
      },
      'Snacks': {
        'color': theme.isDarkMode ? const Color(0xFFFF6B6B) : Colors.purple[300],
        'icon': Icons.local_cafe,
        'bg': 'assets/images/sunset.jpg'
      },
      'Dinner': {
        'color': theme.isDarkMode ? AppTheme.electricBlue : Colors.blue[300],
        'icon': Icons.dinner_dining,
        'bg': 'assets/images/moon.jpg'
      },
    }[title]!;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: theme.cardBackgroundColor,
        borderRadius: BorderRadius.circular(20),
        border: theme.isDarkMode
            ? Border.all(color: (palette['color'] as Color).withOpacity(0.3))
            : null,
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(0, 5))
        ],
        image: DecorationImage(
          image: AssetImage(palette['bg'] as String),
          fit: BoxFit.cover,
          colorFilter:
          ColorFilter.mode(Colors.black.withOpacity(0.4), BlendMode.darken),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: palette['color'] as Color,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(palette['icon'] as IconData,
                  color: theme.isDarkMode ? Colors.black : Colors.white, size: 25),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                  const SizedBox(height: 8),
                  SelectableText(menu,
                      style:
                      const TextStyle(fontSize: 14, color: Colors.white)),
                ],
              ),
            ),
          ],

        ),
      ),
    );
  }
}
