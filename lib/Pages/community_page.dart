import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sastra_x/Pages/home_page.dart';
import '../models/theme_model.dart';

class CommunityPage extends StatefulWidget {
  @override
  _CommunityPageState createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage> {
  TextEditingController _messageController = TextEditingController();
  List<Map<String, dynamic>> messages = [
    {
      'sender': 'Alice',
      'message': 'Hey everyone! Anyone up for study group tonight?',
      'time': '10:30 AM',
      'isMe': false,
    },
    {
      'sender': 'You',
      'message': 'What subject?',
      'time': '10:32 AM',
      'isMe': true,
    },
    {
      'sender': 'Bob',
      'message': 'Mathematics would be great. I\'m struggling with calculus.',
      'time': '10:35 AM',
      'isMe': false,
    },
    {
      'sender': 'You',
      'message': 'Perfect! Let\'s meet at the library at 7 PM.',
      'time': '10:37 AM',
      'isMe': true,
    },
  ];

  void _sendMessage() {
    if (_messageController.text.trim().isNotEmpty) {
      setState(() {
        messages.add({
          'sender': 'You',
          'message': _messageController.text.trim(),
          'time': '${DateTime.now().hour}:${DateTime.now().minute.toString().padLeft(2, '0')}',
          'isMe': true,
        });
      });
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return Scaffold(
          backgroundColor: themeProvider.backgroundColor,
          
          appBar: AppBar(
            title: const Text(
              '',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            backgroundColor: AppTheme.primaryBlue,
            elevation: 0,

          ),
          
          
          body: Column(
            children: [
              // Chat Messages
              Expanded(
                child: Container(
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
                            const BoxShadow(
                              color: Colors.black12,
                              blurRadius: 10,
                              offset: Offset(0, 5),
                            ),
                          ],
                  ),
                  child: ListView.builder(
                    padding: EdgeInsets.all(16),
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final message = messages[index];
                      return _buildMessageBubble(
                        message['sender'],
                        message['message'],
                        message['time'],
                        message['isMe'],
                        themeProvider,
                      );
                    },
                  ),
                ),
              ),
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
                          const BoxShadow(
                            color: Colors.black12,
                            blurRadius: 10,
                            offset: Offset(0, 5),
                          ),
                        ],
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _messageController,
                          style: TextStyle(color: themeProvider.textColor),
                          decoration: InputDecoration(
                            hintText: 'Type a message...',
                            border: InputBorder.none,
                            hintStyle: TextStyle(color: themeProvider.textSecondaryColor),
                          ),
                          onSubmitted: (_) => _sendMessage(),
                        ),
                      ),
                      SizedBox(width: 8),
                      GestureDetector(
                        onTap: _sendMessage,
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            gradient: themeProvider.isDarkMode
                                ? LinearGradient(colors: [AppTheme.neonBlue, AppTheme.electricBlue])
                                : LinearGradient(colors: [themeProvider.primaryColor, Color(0xFF3b82f6)]),
                            shape: BoxShape.circle,
                            boxShadow: themeProvider.isDarkMode
                                ? [
                                    BoxShadow(
                                      color: AppTheme.neonBlue.withOpacity(0.5),
                                      blurRadius: 10,
                                      spreadRadius: 2,
                                    ),
                                  ]
                                : null,
                          ),
                          child: Icon(
                            Icons.send,
                            color: themeProvider.isDarkMode ? Colors.black : Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMessageBubble(String sender, String message, String time, bool isMe, ThemeProvider themeProvider) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isMe) ...[
            CircleAvatar(
              radius: 16,
              backgroundColor: themeProvider.isDarkMode 
                  ? themeProvider.primaryColor.withOpacity(0.3)
                  : Colors.blue[200],
              child: Text(
                sender[0].toUpperCase(),
                style: TextStyle(
                  color: themeProvider.isDarkMode ? themeProvider.primaryColor : AppColors.navyBlue,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
            SizedBox(width: 8),
          ],
          Flexible(
            child: Column(
              crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                if (!isMe)
                  Text(
                    sender,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: themeProvider.textSecondaryColor,
                    ),
                  ),
                SizedBox(height: 4),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    gradient: isMe 
                        ? (themeProvider.isDarkMode
                            ? LinearGradient(colors: [themeProvider.primaryColor, AppTheme.electricBlue])
                            : LinearGradient(colors: [themeProvider.primaryColor, Color(0xFF3b82f6)]))
                        : null,
                    color: isMe 
                        ? null 
                        : (themeProvider.isDarkMode 
                            ? themeProvider.surfaceColor 
                            : Colors.grey[200]),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(isMe ? 18 : 4),
                      topRight: Radius.circular(isMe ? 4 : 18),
                      bottomLeft: Radius.circular(18),
                      bottomRight: Radius.circular(18),
                    ),
                    border: themeProvider.isDarkMode && !isMe
                        ? Border.all(color: themeProvider.primaryColor.withOpacity(0.3))
                        : null,
                  ),
                  child: Text(
                    message,
                    style: TextStyle(
                      color: isMe 
                          ? (themeProvider.isDarkMode ? Colors.black : Colors.white)
                          : themeProvider.textColor,
                      fontSize: 14,
                    ),
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  time,
                  style: TextStyle(
                    fontSize: 10,
                    color: themeProvider.textSecondaryColor,
                  ),
                ),
              ],
            ),
          ),
          if (isMe) ...[
            SizedBox(width: 8),
            CircleAvatar(
              radius: 16,
              backgroundColor: themeProvider.isDarkMode 
                  ? themeProvider.primaryColor
                  : AppColors.navyBlue,
              child: Text(
                'Y',
                style: TextStyle(
                  color: themeProvider.isDarkMode ? Colors.black : Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
