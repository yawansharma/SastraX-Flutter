import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/theme_model.dart';

class MoreOptionsPage extends StatelessWidget {
  final List<Map<String, dynamic>> options = [
    {
      'title': 'Sports',
      'subtitle': 'Sports activities and events',
      'icon': Icons.sports_soccer,
      'color': Colors.green,
    },
    {
      'title': 'Media',
      'subtitle': 'Photos, videos and announcements',
      'icon': Icons.photo_library,
      'color': Colors.purple,
    },
    {
      'title': 'Clubs',
      'subtitle': 'Student clubs and societies',
      'icon': Icons.group,
      'color': Colors.orange,
    },
    {
      'title': 'Library',
      'subtitle': 'Library resources and booking',
      'icon': Icons.library_books,
      'color': Colors.brown,
    },
    {
      'title': 'calculator',
      'subtitle': 'SGPA predictor',
      'icon': Icons.calculate_sharp,
      'color': Colors.lightGreen,
    },
    {
      'title': 'Transport',
      'subtitle': 'Bus routes and schedules',
      'icon': Icons.directions_bus,
      'color': Colors.blue,
    },
    {
      'title': 'Hostel',
      'subtitle': 'Hostel information and services',
      'icon': Icons.home,
      'color': Colors.teal,
    },
    {
      'title': 'Placement',
      'subtitle': 'Placement opportunities and updates',
      'icon': Icons.work,
      'color': Colors.indigo,
    },
    {
      'title': 'Events',
      'subtitle': 'Campus events and festivals',
      'icon': Icons.event,
      'color': Colors.red,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return Scaffold(
          backgroundColor: themeProvider.backgroundColor,
          appBar: AppBar(
            title: Text(
              'More Options',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: themeProvider.isDarkMode ? themeProvider.primaryColor : Colors.white,
              ),
            ),
            backgroundColor: themeProvider.appBarBackgroundColor,
            iconTheme: IconThemeData(
              color: themeProvider.isDarkMode ? themeProvider.primaryColor : Colors.white,
            ),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                // Header Section
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.all(16),
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: themeProvider.cardBackgroundColor,
                    borderRadius: BorderRadius.circular(20),
                    border: themeProvider.isDarkMode
                        ? Border.all(color: AppTheme.neonBlue.withOpacity(0.3))
                        : null,
                    boxShadow: themeProvider.isDarkMode
                        ? [
                            BoxShadow(
                              color: AppTheme.neonBlue.withOpacity(0.2),
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
                  child: Column(
                    children: [
                      Icon(
                        Icons.explore,
                        size: 50,
                        color: themeProvider.primaryColor,
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Explore More Features',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: themeProvider.textColor,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        'Discover additional services and activities',
                        style: TextStyle(
                          fontSize: 14,
                          color: themeProvider.textSecondaryColor,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                
                // Options Grid
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 16),
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 1.1,
                    ),
                    itemCount: options.length,
                    itemBuilder: (context, index) {
                      final option = options[index];
                      return _buildOptionCard(
                        context,
                        option['title'],
                        option['subtitle'],
                        option['icon'],
                        option['color'],
                        themeProvider,
                      );
                    },
                  ),
                ),
                
                SizedBox(height: 20),
                
                // Quick Actions
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: themeProvider.cardBackgroundColor,
                    borderRadius: BorderRadius.circular(20),
                    border: themeProvider.isDarkMode
                        ? Border.all(color: AppTheme.neonBlue.withOpacity(0.3))
                        : null,
                    boxShadow: themeProvider.isDarkMode
                        ? [
                            BoxShadow(
                              color: AppTheme.neonBlue.withOpacity(0.2),
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
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          gradient: themeProvider.isDarkMode
                              ? LinearGradient(colors: [Colors.black, Color(0xFF1A1A1A)])
                              : LinearGradient(colors: [themeProvider.primaryColor, Color(0xFF3b82f6)]),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.flash_on, 
                              color: themeProvider.isDarkMode ? themeProvider.primaryColor : Colors.white,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Quick Actions',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: themeProvider.isDarkMode ? themeProvider.primaryColor : Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          children: [
                            _buildQuickAction(
                              'Emergency Contact',
                              'Contact campus security',
                              Icons.emergency,
                              themeProvider.isDarkMode ? Color(0xFFFF6B6B) : Colors.red,
                              () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Emergency: +91 9876543210'),
                                    backgroundColor: themeProvider.isDarkMode ? Color(0xFFFF6B6B) : Colors.red,
                                  ),
                                );
                              },
                              themeProvider,
                            ),
                            SizedBox(height: 12),
                            _buildQuickAction(
                              'IT Support',
                              'Technical help and support',
                              Icons.support,
                              themeProvider.primaryColor,
                              () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('IT Support: support@sastra.edu'),
                                    backgroundColor: themeProvider.primaryColor,
                                  ),
                                );
                              },
                              themeProvider,
                            ),
                            SizedBox(height: 12),
                            _buildQuickAction(
                              'Feedback',
                              'Share your feedback',
                              Icons.feedback,
                              themeProvider.isDarkMode ? Color(0xFFFFD93D) : Colors.orange,
                              () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Feedback form opened'),
                                    backgroundColor: themeProvider.isDarkMode ? Color(0xFFFFD93D) : Colors.orange,
                                  ),
                                );
                              },
                              themeProvider,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                
                SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildOptionCard(BuildContext context, String title, String subtitle, IconData icon, Color color, ThemeProvider themeProvider) {
    return GestureDetector(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$title feature coming soon!'),
            backgroundColor: color,
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: themeProvider.cardBackgroundColor,
          borderRadius: BorderRadius.circular(20),
          border: themeProvider.isDarkMode
              ? Border.all(color: color.withOpacity(0.3))
              : null,
          boxShadow: themeProvider.isDarkMode
              ? [
                  BoxShadow(
                    color: color.withOpacity(0.2),
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [color, color.withOpacity(0.8)],
                ),
                borderRadius: BorderRadius.circular(15),
                boxShadow: themeProvider.isDarkMode
                    ? [
                        BoxShadow(
                          color: color.withOpacity(0.5),
                          blurRadius: 15,
                          spreadRadius: 3,
                        ),
                      ]
                    : null,
              ),
              child: Icon(
                icon,
                size: 30,
                color: themeProvider.isDarkMode ? Colors.black : Colors.white,
              ),
            ),
            SizedBox(height: 12),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: themeProvider.textColor,
              ),
            ),
            SizedBox(height: 4),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                subtitle,
                style: TextStyle(
                  fontSize: 12,
                  color: themeProvider.textSecondaryColor,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickAction(String title, String subtitle, IconData icon, Color color, VoidCallback onTap, ThemeProvider themeProvider) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: themeProvider.isDarkMode 
              ? color.withOpacity(0.1)
              : color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: color.withOpacity(0.3),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [color, color.withOpacity(0.8)],
                ),
                borderRadius: BorderRadius.circular(8),
                boxShadow: themeProvider.isDarkMode
                    ? [
                        BoxShadow(
                          color: color.withOpacity(0.5),
                          blurRadius: 8,
                          spreadRadius: 1,
                        ),
                      ]
                    : null,
              ),
              child: Icon(
                icon,
                color: themeProvider.isDarkMode ? Colors.black : Colors.white,
                size: 20,
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: themeProvider.textColor,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: themeProvider.textSecondaryColor,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: color,
            ),
          ],
        ),
      ),
    );
  }
}
