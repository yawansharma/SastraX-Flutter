import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/theme_model.dart';

class TimetableWidget extends StatelessWidget {
  final List<Map<String, String>> timetable = [
    {'time': '8:45 - 9:45 AM', 'subject': 'CA', 'room': 'Room 101'},
    {'time': '9:45 - 10:45 AM', 'subject': 'CO', 'room': 'Lab 2'},
    {'time': '10:45 - 11:00 AM', 'subject': 'Break', 'room': ''},
    {'time': '11:00 - 12:00 PM', 'subject': 'CN', 'room': 'Room 205'},
    {'time': '12:00 - 1:00 PM', 'subject': 'Computer Science', 'room': 'Lab 1'},
    {'time': '1:00 - 2:00 PM', 'subject': 'Lunch Break', 'room': ''},
    {'time': '2:00 - 3:00 PM', 'subject': 'OS', 'room': 'Room 301'},
    {'time': '3:00 - 3:15 PM', 'subject': 'Break', 'room': ''},
    {'time': '3:15 - 4:15 PM', 'subject': 'DAA', 'room': 'Lab 3'},
    {'time': '4:15 - 5:00 PM', 'subject': 'DBMS', 'room': 'Room 102'},
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return Container(
          margin: EdgeInsets.all(16),
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
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: themeProvider.isDarkMode
                      ? LinearGradient(colors: [Colors.black, Color(0xFF1A1A1A)])
                      : LinearGradient(colors: [AppTheme.navyBlue, Color(0xFF3b82f6)]),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.schedule, 
                      color: themeProvider.isDarkMode ? AppTheme.neonBlue : Colors.white, 
                      size: 24,
                    ),
                    SizedBox(width: 12),
                    Text(
                      'Today\'s Timetable',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: themeProvider.isDarkMode ? AppTheme.neonBlue : Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: 350,
                child: ListView.builder(
                  padding: EdgeInsets.all(16),
                  itemCount: timetable.length,
                  itemBuilder: (context, index) {
                    final item = timetable[index];
                    bool isBreak = item['subject']!.contains('Break');
                    
                    return Container(
                      margin: EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        gradient: themeProvider.isDarkMode
                            ? LinearGradient(
                                colors: isBreak 
                                    ? [Color(0xFF2A1810), Color(0xFF3A2418)]
                                    : [Color(0xFF0A1A2A), Color(0xFF152A3A)],
                              )
                            : LinearGradient(
                                colors: isBreak 
                                    ? [Colors.orange[50]!, Colors.orange[100]!]
                                    : [Colors.blue[50]!, Colors.blue[100]!],
                              ),
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: themeProvider.isDarkMode
                              ? (isBreak ? Color(0xFFFFD93D) : AppTheme.neonBlue).withOpacity(0.3)
                              : (isBreak ? Colors.orange[200]! : Colors.blue[200]!),
                          width: 1,
                        ),
                      ),
                      child: ListTile(
                        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        leading: Container(
                          width: 50,
                          height: 40,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: themeProvider.isDarkMode
                                  ? (isBreak 
                                      ? [Color(0xFFFFD93D), Color(0xFFFFE55C)]
                                      : [AppTheme.neonBlue, AppTheme.electricBlue])
                                  : (isBreak 
                                      ? [Colors.orange[400]!, Colors.orange[600]!]
                                      : [Colors.blue[400]!, Colors.blue[600]!]),
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: Text(
                              '${index + 1}',
                              style: TextStyle(
                                color: themeProvider.isDarkMode ? Colors.black : Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                        title: Text(
                          item['subject']!,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: themeProvider.primaryColor,
                            fontSize: 16,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item['time']!,
                              style: TextStyle(
                                color: themeProvider.textSecondaryColor,
                                fontSize: 14,
                              ),
                            ),
                            if (item['room']!.isNotEmpty)
                              Text(
                                item['room']!,
                                style: TextStyle(
                                  color: themeProvider.textSecondaryColor,
                                  fontSize: 12,
                                ),
                              ),
                          ],
                        ),
                        trailing: Icon(
                          isBreak ? Icons.free_breakfast : Icons.book,
                          color: themeProvider.isDarkMode
                              ? (isBreak ? Color(0xFFFFD93D) : AppTheme.neonBlue)
                              : (isBreak ? Colors.orange[600] : Colors.blue[600]),
                          size: 24,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
