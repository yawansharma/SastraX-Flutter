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
  final int currentDayIndex = DateTime.now().weekday - 1;
  final int currentWeek = ((DateTime.now().difference(DateTime(DateTime.now().year, 1, 1)).inDays ~/ 7) % 4) + 1;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: currentDayIndex.clamp(0, 6));
    selectedWeek = currentWeek.toString();
    fetchMessMenu();
  }

  Future<void> fetchMessMenu() async {
    try {
      final response = await http.get(Uri.parse('https://instant-researcher-defend-tagged.trycloudflare.com/messMenu'));
      if (response.statusCode == 200) {
        setState(() {
          fullMenu = json.decode(response.body);
          filterMenuByWeek(selectedWeek);
        });
      }
    } catch (e) {
      print('Error fetching mess menu: $e');
    }
  }

  void filterMenuByWeek(String week) {
    setState(() {
      selectedWeek = week;
      filteredMenu = fullMenu.where((day) => day["week"] == week).toList();
    });
  }

  String _getBackgroundImage(String title) {
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
      builder: (context, themeProvider, child) {
        return Scaffold(
          backgroundColor: themeProvider.backgroundColor,
          body: filteredMenu.isEmpty
              ? Center(child: CircularProgressIndicator())
              : PageView.builder(
            controller: _pageController,
            itemCount: filteredMenu.length,
            itemBuilder: (context, index) {
              final dayMenu = filteredMenu[index];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 50),
                  Center(
                    child: Text(
                      dayMenu['day'],
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                        color: themeProvider.textColor,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Expanded(
                    child: ListView(
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      children: [
                        _buildMealCard('Breakfast', dayMenu['breakfast'].join(", "), themeProvider),
                        _buildMealCard('Lunch', dayMenu['lunch'].join(", "), themeProvider),
                        _buildMealCard('Snacks', dayMenu['snacks'].join(", "), themeProvider),
                        _buildMealCard('Dinner', dayMenu['dinner'].join(", "), themeProvider),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildMealCard(String title, String content, ThemeProvider themeProvider) {
    Color cardColor;
    IconData mealIcon;

    switch (title) {
      case 'Breakfast':
        cardColor = themeProvider.isDarkMode ? Color(0xFFFFD93D) : Colors.orange[300]!;
        mealIcon = Icons.wb_sunny;
        break;
      case 'Lunch':
        cardColor = themeProvider.isDarkMode ? AppTheme.neonBlue : Colors.green[300]!;
        mealIcon = Icons.lunch_dining;
        break;
      case 'Snacks':
        cardColor = themeProvider.isDarkMode ? Color(0xFFFF6B6B) : Colors.purple[300]!;
        mealIcon = Icons.local_cafe;
        break;
      case 'Dinner':
        cardColor = themeProvider.isDarkMode ? AppTheme.electricBlue : Colors.blue[300]!;
        mealIcon = Icons.dinner_dining;
        break;
      default:
        cardColor = themeProvider.isDarkMode ? Colors.grey[600]! : Colors.grey[300]!;
        mealIcon = Icons.restaurant;
    }

    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      height: 170,
      decoration: BoxDecoration(
        color: themeProvider.cardBackgroundColor,
        borderRadius: BorderRadius.circular(20),
        border: themeProvider.isDarkMode ? Border.all(color: cardColor.withOpacity(0.3)) : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.asset(
              _getBackgroundImage(title),
              fit: BoxFit.cover,
              height: 170,
              width: double.infinity,
              color: Colors.black.withOpacity(0.4),
              colorBlendMode: BlendMode.darken,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16),
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
                  child: Icon(
                    mealIcon,
                    color: themeProvider.isDarkMode ? Colors.black : Colors.white,
                    size: 25,
                  ),
                ),
                SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        content,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}