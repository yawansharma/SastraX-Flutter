import 'package:flutter/material.dart';

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
    int currentDayIndex = DateTime.now().weekday - 1; // Monday = 0, Sunday = 6
    _pageController = PageController(initialPage: currentDayIndex.clamp(0, 6));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mess Menu'),
        centerTitle: true,
        backgroundColor: Colors.green.shade700,
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
                    dayMenu['day'],
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: 20),
                _buildMealCard('Breakfast', dayMenu['breakfast']),
                _buildMealCard('Lunch', dayMenu['lunch']),
                _buildMealCard('Snacks', dayMenu['snacks']),
                _buildMealCard('Dinner', dayMenu['dinner']),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildMealCard(String title, String content) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.symmetric(vertical: 10),
      child: ListTile(
        title: Text(
          title,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(content),
      ),
    );
  }
}
