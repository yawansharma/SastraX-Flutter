import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Models/theme_model.dart';
import 'more_options_page.dart';


class AboutTeamScreen extends StatelessWidget {
   AboutTeamScreen({super.key});

  final List<Map<String, dynamic>> _teamMembers = const [
    {
      'name': 'Amulya',
      'role': 'Team Lead',

      'avatar': 'A',
      'color': AppTheme.primaryPurple,
    },

  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: AppBar(
        title: const Text(
          'About Team',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppTheme.primaryPurple,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MoreOptionsScreen())),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header Section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(30),
              decoration: const BoxDecoration(
                gradient: AppTheme.primaryGradient,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Column(
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: AppTheme.elevatedShadow,
                    ),
                    child: const Icon(
                      Icons.group,
                      size: 50,
                      color: Colors.white,
                    ),
                  ).animate().scale(delay: 200.ms, curve: Curves.elasticOut),
                  
                  const SizedBox(height: 20),
                  
                  const Text(
                    'Meet Our Team',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ).animate().slideY(delay: 400.ms, begin: -0.3, end: 0),
                  
                  const SizedBox(height: 10),
                  
                  Text(
                    'The passionate developers behind SastraX',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white.withValues(alpha: 0.9),
                    ),
                    textAlign: TextAlign.center,
                  ).animate().fadeIn(delay: 600.ms),
                ],
              ),
            ),
            
            const SizedBox(height: 30),
            
            // Team Members
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: List.generate(_teamMembers.length, (index) {
                  final member = _teamMembers[index];
                  return _buildTeamMemberCard(member, index);
                }),
              ),
            ),
            
            const SizedBox(height: 30),
            
            // Footer
            Container(
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.all(25),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: AppTheme.cardShadow,
              ),
              child: Column(
                children: [
                  const Icon(
                    Icons.favorite,
                    color: AppTheme.errorRed,
                    size: 30,
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    'Made with ❤️ for Students',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textDarkBlue,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Thank you for using SastraX!',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ).animate().slideY(delay: 1000.ms, begin: 0.3, end: 0),
          ],
        ),
      ),
    );
  }

  Widget _buildTeamMemberCard(Map<String, dynamic> member, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          children: [
            // Avatar and Basic Info
            Row(
              children: [
                Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    color: member['color'],
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: member['color'].withValues(alpha: 0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      member['avatar'],
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ).animate().scale(delay: (200 + index * 100).ms, curve: Curves.elasticOut),
                
                const SizedBox(width: 20),
                
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        member['name'],
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textDarkBlue,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        member['role'],
                        style: TextStyle(
                          fontSize: 16,
                          color: member['color'],
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 20),
            
            // Description
            Text(
              member['description'],
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade700,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ).animate().fadeIn(delay: (400 + index * 100).ms),
            
            const SizedBox(height: 25),
            
            // Social Media Links
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildSocialButton(
                  icon: Icons.camera_alt,
                  color: Colors.pink,
                  url: member['instagram'],
                  label: 'Instagram',
                ),
                _buildSocialButton(
                  icon: Icons.work,
                  color: Colors.blue,
                  url: member['linkedin'],
                  label: 'LinkedIn',
                ),
                _buildSocialButton(
                  icon: Icons.article,
                  color: Colors.black,
                  url: member['medium'],
                  label: 'Medium',
                ),
              ],
            ).animate().slideY(delay: (600 + index * 100).ms, begin: 0.3, end: 0),
          ],
        ),
      ),
    ).animate().slideX(delay: (index * 150).ms, begin: 0.3, end: 0);
  }

  Widget _buildSocialButton({
    required IconData icon,
    required Color color,
    required String url,
    required String label,
  }) {
    return GestureDetector(
      onTap: () => _launchURL(url),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: color.withValues(alpha: 0.3),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: color,
              size: 24,
            ),
            const SizedBox(height: 5),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                color: color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      // Handle error - could show a snackbar or dialog
      debugPrint('Could not launch $url');
    }
  }
}
