import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../models/theme_model.dart';

class CommunityPage extends StatefulWidget {
  String backendUrl;
  CommunityPage({super.key, required this.backendUrl});

  @override
  _CommunityPageState createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage> {
  final TextEditingController _postController = TextEditingController();


  final List<Map<String, dynamic>> _posts = [
    {
      'sender': 'Alice',
      'handle': '@alice_wonder',
      'avatarInitial': 'A',
      'message': 'Hey everyone! Anyone up for a study group tonight? We could cover the last two chapters of calculus.',
      'time': '15m',
      'likes': 12,
      'reposts': 2,
      'views': 156,
      'imageFile': null,
    },
    {
      'sender': 'Bob the Builder',
      'handle': '@bob_builds',
      'avatarInitial': 'B',
      'message': 'Just a heads-up, the library just got a new shipment of programming books. Saw some great titles on Flutter and Dart!',
      'time': '45m',
      'likes': 34,
      'reposts': 9,
      'views': 432,
      'imageFile': null,
    },
  ];


  Future<XFile?> _pickImage() async {
    final ImagePicker picker = ImagePicker();

    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    return image;
  }


  void _openComposePostDialog() {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    XFile? selectedImageFile;

    showDialog(
      context: context,
      builder: (context) {

        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: themeProvider.cardBackgroundColor,
              title: Text('Compose Post', style: TextStyle(color: themeProvider.textColor)),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: _postController,
                      autofocus: true,
                      maxLength: 280,
                      maxLines: null,
                      style: TextStyle(color: themeProvider.textColor),
                      decoration: InputDecoration(
                        hintText: "What's happening?",
                        hintStyle: TextStyle(color: themeProvider.textSecondaryColor),
                      ),
                    ),
                    const SizedBox(height: 10),

                    if (selectedImageFile != null)
                      Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.file(
                              File(selectedImageFile!.path),
                              fit: BoxFit.cover,
                            ),
                          ),
                          Positioned(
                            top: 4,
                            right: 4,
                            child: GestureDetector(
                              onTap: () {
                                setDialogState(() {
                                  selectedImageFile = null;
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.all(2),
                                decoration: const BoxDecoration(
                                  color: Colors.black54,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.close, color: Colors.white, size: 18),
                              ),
                            ),
                          ),
                        ],
                      )
                  ],
                ),
              ),
              actions: [

                IconButton(
                  icon: Icon(Icons.photo_library_outlined, color: themeProvider.primaryColor),
                  onPressed: () async {
                    final image = await _pickImage();
                    if (image != null) {
                      setDialogState(() {
                        selectedImageFile = image;
                      });
                    }
                  },
                ),
                const Spacer(),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_postController.text.trim().isNotEmpty || selectedImageFile != null) {
                      setState(() {
                        _posts.insert(0, {
                          'sender': 'You',
                          'handle': '@me',
                          'avatarInitial': 'Y',
                          'message': _postController.text.trim(),
                          'time': 'Just now',
                          'likes': 0,
                          'reposts': 0,
                          'views': 0,
                          'imageFile': selectedImageFile,
                        });
                      });
                      _postController.clear();
                      Navigator.pop(context);
                    }
                  },
                  child: const Text('Post'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return Scaffold(
          backgroundColor: themeProvider.backgroundColor,
          appBar: AppBar(
            // ### KEY CHANGE IS HERE ###
            title: Text(
              'Community',
              style: TextStyle(
                // If it's dark mode, use the default theme color (null),
                // otherwise (in light mode), use blue.
                color: themeProvider.isDarkMode ? null : Colors.indigo,
              ),
            ),
            backgroundColor: themeProvider.backgroundColor,
            elevation: 0,
            scrolledUnderElevation: 1,
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: _openComposePostDialog,
            child: const Icon(Icons.add),
          ),
          body: ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: _posts.length,
            itemBuilder: (context, index) {
              return _buildPostCard(_posts[index], themeProvider);
            },
            separatorBuilder: (context, index) => Divider(
              height: 1,
              color: themeProvider.isDarkMode ? Colors.grey[800] : Colors.grey[200],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPostCard(Map<String, dynamic> post, ThemeProvider themeProvider) {

    final XFile? imageFile = post['imageFile'];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: themeProvider.primaryColor.withOpacity(0.2),
            child: Text(
              post['avatarInitial'],
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: themeProvider.primaryColor,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      post['sender'],
                      style: TextStyle(fontWeight: FontWeight.bold, color: themeProvider.textColor),
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        '${post['handle']} · ${post['time']}',
                        style: TextStyle(color: themeProvider.textSecondaryColor),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),

                if (post['message'].isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Text(
                      post['message'],
                      style: TextStyle(color: themeProvider.textColor, fontSize: 15, height: 1.4),
                    ),
                  ),
                const SizedBox(height: 12),


                if (imageFile != null)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12.0),
                    child: Image.file(
                      File(imageFile.path),
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
                  ),

                if (imageFile != null) const SizedBox(height: 12),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildActionButton(Icons.chat_bubble_outline, 'Reply', themeProvider),
                    _buildActionButton(Icons.repeat, post['reposts'].toString(), themeProvider),
                    _buildActionButton(Icons.favorite_border, post['likes'].toString(), themeProvider),
                    _buildActionButton(Icons.bar_chart, post['views'].toString(), themeProvider),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(IconData icon, String text, ThemeProvider themeProvider) {
    return Row(
      children: [
        Icon(icon, size: 18, color: themeProvider.textSecondaryColor),
        const SizedBox(width: 4),
        if(text != 'Reply')
          Text(text, style: TextStyle(color: themeProvider.textSecondaryColor, fontSize: 13)),
      ],
    );
  }
}