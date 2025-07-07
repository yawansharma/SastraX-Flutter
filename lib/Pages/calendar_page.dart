import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/theme_model.dart';

class CalendarPage extends StatefulWidget {
  final String regNo;
  const CalendarPage({required this.regNo, super.key});

  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  Map<String, List<String>> _events = {};
  final TextEditingController _noteController = TextEditingController();
  late SharedPreferences _prefs;
  late String _storageKey;

  @override
  void initState() {
    super.initState();
    _storageKey = 'calendar_events_${widget.regNo}';
    _loadEvents();
  }

  Future<void> _loadEvents() async {
    _prefs = await SharedPreferences.getInstance();
    final rawJson = _prefs.getString(_storageKey);
    if (rawJson != null) {
      final decoded = jsonDecode(rawJson) as Map<String, dynamic>;
      _events = decoded.map((key, value) => MapEntry(key, List<String>.from(value as List)));
    } else {
      _events = {
        '2024-01-15': ['Assignment Due - Mathematics'],
        '2024-01-20': ['Project Presentation - Physics'],
        '2024-01-25': ['Mid-term Exam - Chemistry'],
      };
    }
    setState(() {});
  }

  Future<void> _saveEvents() async {
    await _prefs.setString(_storageKey, jsonEncode(_events));
  }

  List<String> _getEventsForDay(DateTime day) {
    final key = _keyFromDate(day);
    return _events[key] ?? [];
  }

  void _addNote(DateTime day, String note) {
    final key = _keyFromDate(day);
    setState(() {
      _events.putIfAbsent(key, () => []).add(note);
    });
    _saveEvents();
  }

  void _deleteNote(DateTime day, String note) {
    final key = _keyFromDate(day);
    setState(() {
      _events[key]?.remove(note);
      if (_events[key]?.isEmpty ?? false) _events.remove(key);
    });
    _saveEvents();
  }

  String _keyFromDate(DateTime d) =>
      '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  String _monthName(int m) => const [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December'
  ][m - 1];

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return Scaffold(
          backgroundColor: themeProvider.backgroundColor,
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildCalendarCard(themeProvider),
                  const SizedBox(height: 16),
                  _buildEventsCard(themeProvider),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCalendarCard(ThemeProvider theme) {
    return Container(
      decoration: _boxDecoration(theme),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _navIcon(Icons.chevron_left, () {
                  setState(() => _focusedDay = DateTime(_focusedDay.year, _focusedDay.month - 1));
                }, theme),
                Text(
                  '${_monthName(_focusedDay.month)} ${_focusedDay.year}',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: theme.textColor),
                ),
                _navIcon(Icons.chevron_right, () {
                  setState(() => _focusedDay = DateTime(_focusedDay.year, _focusedDay.month + 1));
                }, theme),
              ],
            ),
            const SizedBox(height: 12),
            _buildMiniCalendar(theme),
          ],
        ),
      ),
    );
  }

  Widget _buildMiniCalendar(ThemeProvider theme) {
    final first = DateTime(_focusedDay.year, _focusedDay.month, 1);
    final last = DateTime(_focusedDay.year, _focusedDay.month + 1, 0);
    final firstWeekday = first.weekday;
    final daysInMonth = last.day;

    return Column(
      children: [
        Row(
          children: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun']
              .map((d) => Expanded(
              child: Center(
                  child: Text(d,
                      style: TextStyle(fontWeight: FontWeight.bold, color: theme.textSecondaryColor)))))
              .toList(),
        ),
        const SizedBox(height: 8),
        GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 7),
          itemCount: 42,
          itemBuilder: (_, idx) {
            final dayOffset = idx - (firstWeekday - 1);
            if (dayOffset < 1 || dayOffset > daysInMonth) return Container();
            final current = DateTime(_focusedDay.year, _focusedDay.month, dayOffset);
            final isToday = _isSameDay(current, DateTime.now());
            final isSel = _isSameDay(current, _selectedDay);
            final hasEvt = _getEventsForDay(current).isNotEmpty;

            return GestureDetector(
              onTap: () => setState(() => _selectedDay = current),
              child: Container(
                margin: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: isSel
                      ? theme.primaryColor
                      : isToday
                      ? theme.primaryColor.withOpacity(0.2)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                  border: hasEvt ? Border.all(color: Colors.orange, width: 2) : null,
                ),
                child: Center(
                  child: Text('$dayOffset',
                      style: TextStyle(
                          fontWeight: FontWeight.w600, color: isSel ? Colors.white : theme.textColor)),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildEventsCard(ThemeProvider theme) {
    final events = _getEventsForDay(_selectedDay);

    return Container(
      decoration: _boxDecoration(theme),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [theme.primaryColor, const Color(0xFF3b82f6)]),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Row(
              children: [
                const Icon(Icons.event_note, color: Colors.white),
                const SizedBox(width: 8),
                Text(
                  'Events for ${_selectedDay.day}/${_selectedDay.month}/${_selectedDay.year}',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ],
            ),
          ),
          if (events.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 40),
              child: _emptyState(theme),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: events.length,
              padding: const EdgeInsets.all(16),
              itemBuilder: (_, idx) => _eventTile(events[idx], theme),
            ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.primaryColor,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: () => _showAddNoteDialog(theme),
              icon: const Icon(Icons.add, color: Colors.white),
              label: const Text('Add Event', style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _eventTile(String event, ThemeProvider theme) => Container(
    margin: const EdgeInsets.only(bottom: 8),
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: theme.primaryColor.withOpacity(0.1),
      borderRadius: BorderRadius.circular(8),
    ),
    child: Row(
      children: [
        Icon(Icons.event, color: theme.primaryColor),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            event,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: theme.textColor,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            softWrap: false,
          ),
        ),
        IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: () => _deleteNote(_selectedDay, event),
        )
      ],
    ),
  );

  Widget _emptyState(ThemeProvider theme) => Center(
    child: Column(
      children: [
        Icon(Icons.event_busy, size: 50, color: theme.textSecondaryColor),
        const SizedBox(height: 10),
        Text('No events for this day', style: TextStyle(color: theme.textSecondaryColor)),
      ],
    ),
  );

  BoxDecoration _boxDecoration(ThemeProvider t) => BoxDecoration(
    color: t.cardBackgroundColor,
    borderRadius: BorderRadius.circular(20),
    boxShadow: [
      BoxShadow(
          color: t.isDarkMode ? Colors.blueAccent.withOpacity(0.2) : Colors.black12,
          blurRadius: 10,
          offset: const Offset(0, 5)),
    ],
  );

  IconButton _navIcon(IconData icon, VoidCallback cb, ThemeProvider t) =>
      IconButton(icon: Icon(icon, color: t.primaryColor), onPressed: cb);

  void _showAddNoteDialog(ThemeProvider theme) {
    _noteController.clear();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: theme.cardBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        final mediaQuery = MediaQuery.of(context);
        return MediaQuery(
          data: mediaQuery.copyWith(textScaler: const TextScaler.linear(1.0)),
          child: Padding(
            padding: EdgeInsets.only(bottom: mediaQuery.viewInsets.bottom),
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: _noteController,
                    maxLines: 3,
                    style: TextStyle(color: theme.textColor),
                    decoration: InputDecoration(
                      hintText: 'Enter your note...',
                      hintStyle: TextStyle(color: theme.textSecondaryColor),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(color: theme.primaryColor, width: 2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text('Cancel', style: TextStyle(color: theme.textSecondaryColor)),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.primaryColor,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        onPressed: () {
                          if (_noteController.text.trim().isNotEmpty) {
                            _addNote(_selectedDay, _noteController.text.trim());
                            Navigator.pop(context);
                          }
                        },
                        child: const Text('Add', style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
