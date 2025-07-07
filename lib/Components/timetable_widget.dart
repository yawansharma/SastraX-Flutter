import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/theme_model.dart';

class TimetableWidget extends StatefulWidget {
  @override
  _TimetableWidgetState createState() => _TimetableWidgetState();
}

class _TimetableWidgetState extends State<TimetableWidget> {
  final ScrollController _scrollController = ScrollController();

  final List<Map<String, String>> timetable = [
    {'time': '8:45 AM - 9:45 AM', 'subject': 'CA', 'room': 'Room 101'},
    {'time': '9:45 AM - 10:45 AM', 'subject': 'CO', 'room': 'Lab 2'},
    {'time': '10:45 AM - 11:00 AM', 'subject': 'Break', 'room': ''},
    {'time': '11:00 AM - 12:00 PM', 'subject': 'CN', 'room': 'Room 205'},
    {'time': '12:00 PM - 1:00 PM', 'subject': 'Computer Science', 'room': 'Lab 1'},
    {'time': '1:00 PM - 2:00 PM', 'subject': 'Lunch Break', 'room': ''},
    {'time': '2:00 PM - 3:00 PM', 'subject': 'OS', 'room': 'Room 301'},
    {'time': '3:00 PM - 3:15 PM', 'subject': 'Break', 'room': ''},
    {'time': '3:15 PM - 4:15 PM', 'subject': 'DAA', 'room': 'Lab 3'},
    {'time': '4:15 PM - 5:00 PM', 'subject': 'DBMS', 'room': 'Room 102'},
  ];

  int? currentIndex;

  @override
  void initState() {
    super.initState();
    currentIndex = _getCurrentIndex();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (currentIndex != null && _scrollController.hasClients) {
        _scrollController.animateTo(
          currentIndex! * 85.0,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  int? _getCurrentIndex() {
    final now = DateTime.now();
    final formatter = DateFormat('h:mm a');
    for (int i = 0; i < timetable.length; i++) {
      try {
        final parts = timetable[i]['time']!.split(' - ');
        final start = formatter.parse(parts[0]);
        final end = formatter.parse(parts[1]);
        final startTime = DateTime(now.year, now.month, now.day, start.hour, start.minute);
        final endTime = DateTime(now.year, now.month, now.day, end.hour, end.minute);
        if (now.isAfter(startTime) && now.isBefore(endTime)) return i;
      } catch (_) {}
    }
    return null;
  }

  bool _isCurrentSlot(String timeRange) {
    try {
      final now = DateTime.now();
      final formatter = DateFormat('h:mm a');
      final parts = timeRange.split(' - ');
      final start = formatter.parse(parts[0]);
      final end = formatter.parse(parts[1]);
      final startTime = DateTime(now.year, now.month, now.day, start.hour, start.minute);
      final endTime = DateTime(now.year, now.month, now.day, end.hour, end.minute);
      return now.isAfter(startTime) && now.isBefore(endTime);
    } catch (_) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, _) {
        return Container(
          margin: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: themeProvider.cardBackgroundColor,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppTheme.neonBlue.withOpacity(0.3)),
            boxShadow: themeProvider.isDarkMode
                ? [BoxShadow(color: AppTheme.neonBlue.withOpacity(0.2), blurRadius: 15)]
                : [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 5))],
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: themeProvider.isDarkMode
                      ? const LinearGradient(colors: [Colors.black, Color(0xFF1A1A1A)])
                      : const LinearGradient(colors: [AppTheme.navyBlue, Color(0xFF3b82f6)]),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(Icons.schedule,
                        color: themeProvider.isDarkMode ? AppTheme.neonBlue : Colors.white),
                    const SizedBox(width: 12),
                    Text(
                      'Today\'s Timetable',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: themeProvider.isDarkMode ? AppTheme.neonBlue : Colors.white,
                      ),
                      textScaler: TextScaler.linear(1.0),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 300,
                child: ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(16),
                  itemCount: timetable.length,
                  itemBuilder: (context, index) {
                    final item = timetable[index];
                    final isBreak = item['subject']!.contains('Break');
                    final isCurrent = _isCurrentSlot(item['time']!);

                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: themeProvider.isDarkMode
                              ? (isBreak
                              ? [Color(0xFF2A1810), Color(0xFF3A2418)]
                              : [Color(0xFF0A1A2A), Color(0xFF152A3A)])
                              : (isBreak
                              ? [Colors.orange[50]!, Colors.orange[100]!]
                              : [Colors.blue[50]!, Colors.blue[100]!]),
                        ),
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: isCurrent ? Colors.cyanAccent : Colors.transparent,
                          width: isCurrent ? 3 : 1,
                        ),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                                fontSize: 14,
                              ),
                              textScaler: TextScaler.linear(1.0),
                            ),
                          ),
                        ),
                        title: Text(
                          item['subject']!,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: themeProvider.primaryColor,
                            fontSize: 15,
                          ),
                          textScaler: TextScaler.linear(1.0),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            FittedBox(
                              fit: BoxFit.scaleDown,
                              alignment: Alignment.centerLeft,
                              child: Text(
                                item['time']!,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                softWrap: false,
                                style: TextStyle(
                                  color: themeProvider.textSecondaryColor,
                                  fontSize: 13,
                                ),
                                textScaler: TextScaler.linear(1.0),
                              ),
                            ),
                            if (item['room']!.isNotEmpty)
                              FittedBox(
                                fit: BoxFit.scaleDown,
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  item['room']!,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  softWrap: false,
                                  style: TextStyle(
                                    color: themeProvider.textSecondaryColor,
                                    fontSize: 11.5,
                                  ),
                                  textScaler: TextScaler.linear(1.0),
                                ),
                              ),
                          ],
                        ),
                        trailing: Icon(
                          isBreak ? Icons.free_breakfast : Icons.book,
                          color: isBreak
                              ? (themeProvider.isDarkMode
                              ? Color(0xFFFFD93D)
                              : Colors.orange[600])
                              : (themeProvider.isDarkMode
                              ? AppTheme.neonBlue
                              : Colors.blue[600]),
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
