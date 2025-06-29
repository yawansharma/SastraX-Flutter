import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: Text('Mess Menu' , style: GoogleFonts.lato(
          fontWeight: FontWeight.bold ,
          fontSize: 24,
        ),),
        centerTitle: true,
        backgroundColor: Colors.deepPurple[300],
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
                    dayMenu['Day'], // Corrected
                    style: GoogleFonts.lato(
                      fontWeight: FontWeight.bold ,
                      fontSize : 30 ,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                _buildMealCard('Breakfast', dayMenu['Breakfast']),
                _buildMealCard('Lunch', dayMenu['Lunch']),
                _buildMealCard('Snacks', dayMenu['Snacks']),
                _buildMealCard('Dinner', dayMenu['Dinner']),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildMealCard(String title, String content) {
    String imagePath = _getImagePathForMeal(title);

    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(imagePath),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            Colors.black.withOpacity(0.4),
            BlendMode.darken,
          ),
        ),
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 25,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 8),
          Text(
            content,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }


  String _getImagePathForMeal(String mealType) {
    switch (mealType) {
      case 'Breakfast':
        return 'assets/images/sunrise.jpg';
      case 'Lunch':
        return 'assets/images/sunshine.jpg';
      case 'Snacks':
        return 'assets/images/sunset.jpg';
      case 'Dinner':
        return 'assets/images/moon.jpg';
      default:
        return 'assets/images/sunshine.jpg'; // fallback
    }
  }

}
