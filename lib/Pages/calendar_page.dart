import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/theme_model.dart';

class CalendarPage extends StatefulWidget {
  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  Map<DateTime, List<String>> _events = {};
  TextEditingController _noteController = TextEditingController();

  @override
  void initState() {
    super.initState();
    
    // Sample events
    _events = {
      DateTime(2024, 1, 15): ['Assignment Due - Mathematics'],
      DateTime(2024, 1, 20): ['Project Presentation - Physics'],
      DateTime(2024, 1, 25): ['Mid-term Exam - Chemistry'],
    };
  }

  List<String> _getEventsForDay(DateTime day) {
    DateTime key = DateTime(day.year, day.month, day.day);
    return _events[key] ?? [];
  }

  void _addNote(DateTime day, String note) {
    setState(() {
      DateTime key = DateTime(day.year, day.month, day.day);
      if (_events[key] != null) {
        _events[key]!.add(note);
      } else {
        _events[key] = [note];
      }
    });
  }

  void _showAddNoteDialog(ThemeProvider themeProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: themeProvider.cardBackgroundColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'Add Note',
          style: TextStyle(color: themeProvider.textColor),
        ),
        content: TextField(
          controller: _noteController,
          style: TextStyle(color: themeProvider.textColor),
          decoration: InputDecoration(
            hintText: 'Enter your note...',
            hintStyle: TextStyle(color: themeProvider.textSecondaryColor),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(color: themeProvider.primaryColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(color: themeProvider.primaryColor, width: 2),
            ),
          ),
          maxLines: 3,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: TextStyle(color: themeProvider.textSecondaryColor)),
          ),
          ElevatedButton(
            onPressed: () {
              if (_noteController.text.isNotEmpty) {
                _addNote(_selectedDay, _noteController.text);
                _noteController.clear();
                Navigator.pop(context);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: themeProvider.primaryColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: Text('Add', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return Scaffold(
          backgroundColor: themeProvider.backgroundColor,
          appBar: AppBar(
            title: Text(
              'Calendar',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: themeProvider.isDarkMode ? themeProvider.primaryColor : Colors.white,
              ),
            ),
            backgroundColor: themeProvider.appBarBackgroundColor,
            iconTheme: IconThemeData(
              color: themeProvider.isDarkMode ? themeProvider.primaryColor : Colors.white,
            ),
            actions: [
              IconButton(
                onPressed: () => _showAddNoteDialog(themeProvider),
                icon: Icon(Icons.add),
              ),
            ],
          ),
          body: Column(
            children: [
              // Simple Calendar Header
              Container(
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
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    children: [
                      // Month Navigation
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            onPressed: () {
                              setState(() {
                                _focusedDay = DateTime(_focusedDay.year, _focusedDay.month - 1);
                              });
                            },
                            icon: Icon(Icons.chevron_left, color: themeProvider.primaryColor),
                          ),
                          Text(
                            '${_getMonthName(_focusedDay.month)} ${_focusedDay.year}',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: themeProvider.textColor,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              setState(() {
                                _focusedDay = DateTime(_focusedDay.year, _focusedDay.month + 1);
                              });
                            },
                            icon: Icon(Icons.chevron_right, color: themeProvider.primaryColor),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      
                      // Days Grid
                      Container(
                        height: 200,
                        child: _buildSimpleCalendar(themeProvider),
                      ),
                    ],
                  ),
                ),
              ),
              
              // Events List
              Expanded(
                child: Container(
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
                              Icons.event_note, 
                              color: themeProvider.isDarkMode ? themeProvider.primaryColor : Colors.white,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Events for ${_selectedDay.day}/${_selectedDay.month}/${_selectedDay.year}',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: themeProvider.isDarkMode ? themeProvider.primaryColor : Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: _getEventsForDay(_selectedDay).isEmpty
                            ? Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.event_busy,
                                      size: 50,
                                      color: themeProvider.textSecondaryColor,
                                    ),
                                    SizedBox(height: 10),
                                    Text(
                                      'No events for this day',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: themeProvider.textSecondaryColor,
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    ElevatedButton(
                                      onPressed: () => _showAddNoteDialog(themeProvider),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: themeProvider.primaryColor,
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                      ),
                                      child: Text('Add Event', style: TextStyle(color: Colors.white)),
                                    ),
                                  ],
                                ),
                              )
                            : ListView.builder(
                                padding: EdgeInsets.all(16),
                                itemCount: _getEventsForDay(_selectedDay).length,
                                itemBuilder: (context, index) {
                                  final event = _getEventsForDay(_selectedDay)[index];
                                  return Container(
                                    margin: EdgeInsets.only(bottom: 8),
                                    padding: EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: themeProvider.isDarkMode 
                                          ? themeProvider.primaryColor.withOpacity(0.1)
                                          : Colors.blue[50],
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                        color: themeProvider.primaryColor.withOpacity(0.3),
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.event,
                                          color: themeProvider.primaryColor,
                                          size: 20,
                                        ),
                                        SizedBox(width: 10),
                                        Expanded(
                                          child: Text(
                                            event,
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                              color: themeProvider.textColor,
                                            ),
                                          ),
                                        ),
                                        IconButton(
                                          onPressed: () {
                                            setState(() {
                                              DateTime key = DateTime(_selectedDay.year, _selectedDay.month, _selectedDay.day);
                                              _events[key]?.remove(event);
                                              if (_events[key]?.isEmpty == true) {
                                                _events.remove(key);
                                              }
                                            });
                                          },
                                          icon: Icon(Icons.delete, color: Colors.red, size: 18),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                      ),
                    ],
                  ),
                ),
              ),
              
              SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSimpleCalendar(ThemeProvider themeProvider) {
    final firstDayOfMonth = DateTime(_focusedDay.year, _focusedDay.month, 1);
    final lastDayOfMonth = DateTime(_focusedDay.year, _focusedDay.month + 1, 0);
    final firstWeekday = firstDayOfMonth.weekday;
    final daysInMonth = lastDayOfMonth.day;

    return Column(
      children: [
        // Days of week header
        Row(
          children: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun']
              .map((day) => Expanded(
                    child: Center(
                      child: Text(
                        day,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: themeProvider.textSecondaryColor,
                        ),
                      ),
                    ),
                  ))
              .toList(),
        ),
        SizedBox(height: 8),
        
        // Calendar grid
        Expanded(
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
            ),
            itemCount: 42, // 6 weeks * 7 days
            itemBuilder: (context, index) {
              final dayOffset = index - (firstWeekday - 1);
              
              if (dayOffset < 1 || dayOffset > daysInMonth) {
                return Container(); // Empty cell
              }
              
              final currentDate = DateTime(_focusedDay.year, _focusedDay.month, dayOffset);
              final isSelected = _isSameDay(currentDate, _selectedDay);
              final isToday = _isSameDay(currentDate, DateTime.now());
              final hasEvents = _getEventsForDay(currentDate).isNotEmpty;

              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedDay = currentDate;
                  });
                },
                child: Container(
                  margin: EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? themeProvider.primaryColor
                        : isToday
                            ? themeProvider.primaryColor.withOpacity(0.2)
                            : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                    border: hasEvents 
                        ? Border.all(color: Colors.orange, width: 2) 
                        : null,
                  ),
                  child: Center(
                    child: Text(
                      dayOffset.toString(),
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: isSelected
                            ? Colors.white
                            : isToday
                                ? themeProvider.primaryColor
                                : themeProvider.textColor,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  String _getMonthName(int month) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return months[month - 1];
  }
}
