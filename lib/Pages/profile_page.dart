import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/theme_model.dart';

class ProfilePage extends StatelessWidget {
  final Map<String, String> studentData = {
    'name': 'nivedha',
    'registerNumber': '123456789',
    'department': 'Computer Science Engineering',
    'semester': '6th Semester',
    'email': 'aaaa@sastra.ac.in',
    'phone': '+91 9876543210',
    'batch': '2021-2025',
  };

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return Scaffold(
          backgroundColor: themeProvider.backgroundColor,
          appBar: AppBar(
            title: Text(
              'Student Profile',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: themeProvider.isDarkMode ? themeProvider.primaryColor : Colors.white,
              ),
            ),
            backgroundColor: themeProvider.appBarBackgroundColor,
            elevation: 0,
            iconTheme: IconThemeData(
              color: themeProvider.isDarkMode ? themeProvider.primaryColor : Colors.white,
            ),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                // Profile Header
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: themeProvider.isDarkMode
                        ? LinearGradient(colors: [Colors.black, Color(0xFF1A1A1A)])
                        : LinearGradient(colors: [Color(0xFF1e3a8a), Color(0xFF3b82f6)]),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                  ),
                  child: Column(
                    children: [
                      SizedBox(height: 20),
                      // Profile Picture
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: themeProvider.isDarkMode
                              ? LinearGradient(colors: [themeProvider.primaryColor, AppTheme.electricBlue])
                              : LinearGradient(colors: [Colors.white, Colors.blue[100]!]),
                          border: Border.all(
                            color: themeProvider.isDarkMode ? themeProvider.primaryColor : Colors.blue, 
                            width: 4,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: themeProvider.isDarkMode 
                                  ? themeProvider.primaryColor.withOpacity(0.5)
                                  : Colors.black26,
                              blurRadius: themeProvider.isDarkMode ? 15 : 10,
                              offset: Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.person,
                          size: 60,
                          color: themeProvider.isDarkMode ? Colors.black : Color(0xFF1e3a8a),
                        ),
                      ),
                      SizedBox(height: 15),
                      // Student Name
                      Text(
                        studentData['name']!,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: themeProvider.isDarkMode ? themeProvider.primaryColor : Colors.white,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        studentData['registerNumber']!,
                        style: TextStyle(
                          fontSize: 16,
                          color: themeProvider.isDarkMode ? themeProvider.textSecondaryColor : Colors.white70,
                        ),
                      ),
                      SizedBox(height: 30),
                    ],
                  ),
                ),
                
                SizedBox(height: 30),
                
                // Profile Details
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      _buildProfileCard('Department', studentData['department']!, Icons.school, themeProvider.primaryColor, themeProvider),
                      SizedBox(height: 15),
                      _buildProfileCard('Semester', studentData['semester']!, Icons.calendar_today, Colors.green, themeProvider),
                      SizedBox(height: 15),
                      _buildProfileCard('Batch', studentData['batch']!, Icons.group, Colors.orange, themeProvider),
                      SizedBox(height: 15),
                      _buildProfileCard('Email', studentData['email']!, Icons.email, themeProvider.primaryColor, themeProvider),
                      SizedBox(height: 15),
                      _buildProfileCard('Phone', studentData['phone']!, Icons.phone, Colors.green, themeProvider),
                      SizedBox(height: 30),
                      
                      // Action Buttons
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Edit Profile feature coming soon!'),
                                    backgroundColor: themeProvider.primaryColor,
                                  ),
                                );
                              },
                              icon: Icon(Icons.edit, color: Colors.white),
                              label: Text('Edit Profile', style: TextStyle(color: Colors.white)),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: themeProvider.primaryColor,
                                padding: EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 15),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Settings feature coming soon!'),
                                    backgroundColor: themeProvider.textSecondaryColor,
                                  ),
                                );
                              },
                              icon: Icon(Icons.settings, color: Colors.white),
                              label: Text('Settings', style: TextStyle(color: Colors.white)),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: themeProvider.textSecondaryColor,
                                padding: EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildProfileCard(String title, String value, IconData icon, Color color, ThemeProvider themeProvider) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: themeProvider.cardBackgroundColor,
        borderRadius: BorderRadius.circular(15),
        border: themeProvider.isDarkMode 
            ? Border.all(color: color.withOpacity(0.3))
            : null,
        boxShadow: themeProvider.isDarkMode
            ? [
                BoxShadow(
                  color: color.withOpacity(0.2),
                  blurRadius: 10,
                  spreadRadius: 1,
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
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: themeProvider.isDarkMode 
                  ? Border.all(color: color.withOpacity(0.3))
                  : null,
            ),
            child: Icon(
              icon,
              color: color,
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
                    fontSize: 14,
                    color: themeProvider.textSecondaryColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: themeProvider.textColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
