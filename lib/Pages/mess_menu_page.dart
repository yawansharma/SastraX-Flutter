import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/theme_model.dart';

class MessMenuPage extends StatefulWidget {
  @override
  _MessMenuPageState createState() => _MessMenuPageState();
}

class _MessMenuPageState extends State<MessMenuPage> {
  late PageController _pageController;
  List<dynamic> fullMenu = [];
  List<dynamic> filteredMenu = [];
  String selectedWeek = "1";

  final List<String> weekDays = ['SUN', 'MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT'];
  String selectedDay = '';

  final int currentDayIndex = DateTime.now().weekday % 7;
  final int currentWeek =
      ((DateTime.now().difference(DateTime(DateTime.now().year, 1, 1)).inDays ~/ 7) % 4) + 1;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: currentDayIndex);
    selectedWeek = currentWeek.toString();
    selectedDay = weekDays[currentDayIndex];
    fetchMessMenu();
  }

  Future<void> fetchMessMenu() async {
    try {
      final res = await http.get(
        Uri.parse('https://dna-attitude-per-eds.trycloudflare.com/messMenu'),
      );
      if (res.statusCode == 200) {
        setState(() {
          fullMenu = json.decode(res.body);
          filterMenuByWeek(selectedWeek);
        });
      } else {
        throw Exception('HTTP ${res.statusCode}');
      }
    } catch (e) {
      debugPrint('Error fetching mess menu → $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Couldn’t load menu: $e')),
        );
      }
    }
  }

  void filterMenuByWeek(String week) {
    setState(() {
      selectedWeek = week;
      filteredMenu = fullMenu.where((d) => d['week'] == week).toList();
    });
  }

  String _bg(String title) {
    switch (title) {
      case 'Breakfast':
        return 'assets/images/sunrise.jpg';
      case 'Lunch':
        return 'assets/images/sunshine.jpg';
      case 'Snacks':
        return 'assets/images/sunset.jpg';
      case 'Dinner':
        return 'assets/images/moon.jpg';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (_, theme, __) => Scaffold(
        backgroundColor: theme.backgroundColor,
        body: filteredMenu.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : Column(
          children: [
            const SizedBox(height: 50),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  _buildDayRow(theme, 0, 4), // SUN - WED
                  const SizedBox(height: 10),
                  _buildDayRow(theme, 4, 7), // THU - SAT
                ],
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(), // disable swiping
                itemCount: filteredMenu.length,
                itemBuilder: (_, idx) {
                  final day = filteredMenu[idx];
                  return ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    children: [
                      _mealCard('Breakfast', day['breakfast'].join(', '), theme),
                      _mealCard('Lunch', day['lunch'].join(', '), theme),
                      _mealCard('Snacks', day['snacks'].join(', '), theme),
                      _mealCard('Dinner', day['dinner'].join(', '), theme),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDayRow(ThemeProvider theme, int start, int end) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: weekDays.sublist(start, end).map((dayAbbr) {
        final int index = weekDays.indexOf(dayAbbr);
        final bool isSelected = selectedDay == dayAbbr;

        return Expanded(
          child: GestureDetector(
            onTap: () {
              setState(() {
                selectedDay = dayAbbr;
                _pageController.jumpToPage(index);
              });
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: isSelected
                    ? (theme.isDarkMode ? Colors.amber[300] : Colors.blueAccent)
                    : theme.cardBackgroundColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
                  dayAbbr,
                  style: TextStyle(
                    color: isSelected
                        ? (theme.isDarkMode ? Colors.black : Colors.white)
                        : theme.textColor,
                    fontWeight: FontWeight.bold,
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
    final Map<String, dynamic> palette = {
      'Breakfast': {
        'color': theme.isDarkMode ? const Color(0xFFFFD93D) : Colors.orange[300],
        'icon': Icons.wb_sunny
      },
      'Lunch': {
        'color': theme.isDarkMode ? AppTheme.neonBlue : Colors.green[300],
        'icon': Icons.lunch_dining
      },
      'Snacks': {
        'color': theme.isDarkMode ? const Color(0xFFFF6B6B) : Colors.purple[300],
        'icon': Icons.local_cafe
      },
      'Dinner': {
        'color': theme.isDarkMode ? AppTheme.electricBlue : Colors.blue[300],
        'icon': Icons.dinner_dining
      }
    };

    final Color cardColor = palette[title]?['color'] as Color? ??
        (theme.isDarkMode ? Colors.grey[700]! : Colors.grey[300]!);
    final IconData icon = palette[title]?['icon'] as IconData? ?? Icons.restaurant;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      constraints: const BoxConstraints(minHeight: 120),
      decoration: BoxDecoration(
        color: theme.cardBackgroundColor,
        borderRadius: BorderRadius.circular(20),
        border: theme.isDarkMode ? Border.all(color: cardColor.withOpacity(0.3)) : null,
        boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(0, 5))],
        image: DecorationImage(
          image: AssetImage(_bg(title)),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.4), BlendMode.darken),
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
                color: cardColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon,
                  color: theme.isDarkMode ? Colors.black : Colors.white, size: 25),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                  const SizedBox(height: 8),
                  SelectableText(
                    menu,
                    style: const TextStyle(fontSize: 14, color: Colors.white),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
