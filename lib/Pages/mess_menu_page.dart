import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/theme_model.dart';

class MessMenuPage extends StatefulWidget {
  @override
  _MessMenuPageState createState() => _MessMenuPageState();
}

class _MessMenuPageState extends State<MessMenuPage> {
  late PageController _pageController;

  final List<Map<String, dynamic>> weeklyMenu = [
    {
      'Day': 'Monday',
      'Breakfast': 'Idli, Sambar, Chutney',
      'Lunch': 'Rice, Rasam, Cabbage Poriyal',
      'Snacks': 'Tea, Biscuits',
      'Dinner': 'Chapathi, Aloo Curry',
    },
    {
      'Day': 'Tuesday',
      'Breakfast': 'Dosa, Chutney, Sambar',
      'Lunch': 'Fried Rice, Gobi Manchurian',
      'Snacks': 'Cutlet, Tea',
      'Dinner': 'Upma, Coconut Chutney',
    },
    {
      'Day': 'Wednesday',
      'Breakfast': 'Pongal, Vada, Sambar',
      'Lunch': 'Sambar, Beans Poriyal, Curd',
      'Snacks': 'Bread Pakoda, Tea',
      'Dinner': 'Rice, Dal, Potato Fry',
    },
    {
      'Day': 'Thursday',
      'Breakfast': 'Poori, Masala',
      'Lunch': 'Lemon Rice, Chips',
      'Snacks': 'Vada, Tea',
      'Dinner': 'Chapathi, Paneer Butter Masala',
    },
    {
      'Day': 'Friday',
      'Breakfast': 'Aloo Paratha, Curd',
      'Lunch': 'Veg Biryani, Raita',
      'Snacks': 'Samosa, Tea',
      'Dinner': 'Rice, Tomato Dal, Bhindi Fry',
    },
    {
      'Day': 'Saturday',
      'Breakfast': 'Upma, Sambar',
      'Lunch': 'Curd Rice, Pickle, Chips',
      'Snacks': 'Murukku, Coffee',
      'Dinner': 'Dosa, Onion Chutney',
    },
    {
      'Day': 'Sunday',
      'Breakfast': 'Poori, Chana Masala',
      'Lunch': 'Paneer Pulao, Veg Kurma',
      'Snacks': 'Cake Slice, Tea',
      'Dinner': 'Pasta, Garlic Bread',
    },
  ];

  @override
  void initState() {
    super.initState();
    int currentDayIndex = DateTime.now().weekday - 1;
    _pageController = PageController(initialPage: currentDayIndex.clamp(0, 6));
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return Scaffold(
          backgroundColor: themeProvider.backgroundColor,
          appBar: AppBar(
            title: Text(
              'Mess Menu',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
                color: themeProvider.isDarkMode ? themeProvider.primaryColor : Colors.white,
              ),
            ),
            centerTitle: true,
            backgroundColor: themeProvider.appBarBackgroundColor,
            iconTheme: IconThemeData(
              color: themeProvider.isDarkMode ? themeProvider.primaryColor : Colors.white,
            ),
          ),
          body: PageView.builder(
            controller: _pageController,
            itemCount: weeklyMenu.length,
            itemBuilder: (context, index) {
              final dayMenu = weeklyMenu[index];
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: ListView(
                  children: [
                    Center(
                      child: Text(
                        dayMenu['Day'],
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                          color: themeProvider.textColor,
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    _buildMealCard('Breakfast', dayMenu['Breakfast'], themeProvider),
                    _buildMealCard('Lunch', dayMenu['Lunch'], themeProvider),
                    _buildMealCard('Snacks', dayMenu['Snacks'], themeProvider),
                    _buildMealCard('Dinner', dayMenu['Dinner'], themeProvider),
                  ],
                ),
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
      decoration: BoxDecoration(
        color: themeProvider.cardBackgroundColor,
        borderRadius: BorderRadius.circular(20),
        border: themeProvider.isDarkMode
            ? Border.all(color: cardColor.withOpacity(0.3))
            : null,
        boxShadow: themeProvider.isDarkMode
            ? [
                BoxShadow(
                  color: cardColor.withOpacity(0.2),
                  blurRadius: 15,
                  spreadRadius: 2,
                ),
              ]
            : [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10,
                  offset: Offset(0, 5),
                ),
              ],
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [cardColor, cardColor.withOpacity(0.8)],
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: themeProvider.isDarkMode
                    ? [
                        BoxShadow(
                          color: cardColor.withOpacity(0.5),
                          blurRadius: 10,
                          spreadRadius: 2,
                        ),
                      ]
                    : null,
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
                      color: themeProvider.textColor,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    content,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      color: themeProvider.textSecondaryColor,
                    ),
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
