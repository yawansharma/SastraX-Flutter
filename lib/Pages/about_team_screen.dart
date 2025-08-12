import 'dart:math';
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
      'avatar': 'Amulya', // This will be displayed as text "A"
      'color': AppTheme.primaryPurple,
      'description': 'Drives the vision and keeps us on track.',
      'instagram': 'https://instagram.com/',
      'linkedin': 'https://linkedin.com/',
      'medium': 'https://medium.com/'
    },
    {
      'name': 'Yashwanth',
      'role': 'Technical Head',
      'avatar': 'Yash', // This will be displayed as an image
      'color': AppTheme.primaryPurple,
      'description': 'The creative force behind the app.',
      'instagram': 'https://instagram.com/',
      'linkedin': 'https://linkedin.com/',
      'medium': 'https://medium.com/'
    },
  ];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final scale = MediaQuery.of(context).textScaleFactor;
    final avatarSize = min(70.0, size.width * 0.18);

    return SafeArea(
      child: Scaffold(
        backgroundColor: AppTheme.backgroundLight,
        appBar: AppBar(
          title: Text('About Team',
              style: TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 20 / scale)),
          backgroundColor: AppTheme.primaryPurple,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => MoreOptionsScreen()),
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(30),
                decoration: const BoxDecoration(
                  gradient: AppTheme.primaryGradient,
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(30),
                  ),
                ),
                child: Column(
                  children: [
                    Container(
                      width: avatarSize,
                      height: avatarSize,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: AppTheme.elevatedShadow,
                      ),
                      child: const Icon(Icons.group,
                          size: 50, color: Colors.white),
                    ).animate().scale(
                        delay: 200.ms, curve: Curves.elasticOut, duration: 400.ms),

                    const SizedBox(height: 20),

                    Text('Meet Our Team',
                        style: TextStyle(
                          fontSize: 28 / scale,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ))
                        .animate()
                        .slideY(delay: 400.ms, begin: -0.3),

                    const SizedBox(height: 10),

                    Text('The passionate developers behind SastraX',
                        style: TextStyle(
                          fontSize: 16 / scale,
                          color: Colors.white.withOpacity(0.9),
                        ),
                        textAlign: TextAlign.center)
                        .animate()
                        .fadeIn(delay: 600.ms),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: List.generate(
                    _teamMembers.length,
                        (i) => _buildTeamMemberCard(_teamMembers[i], i, avatarSize, scale),
                  ),
                ),
              ),

              const SizedBox(height: 30),

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
                    const Icon(Icons.favorite,
                        color: AppTheme.errorRed, size: 30),
                    const SizedBox(height: 15),
                    Text('Made with ❤️ for Students',
                        style: TextStyle(
                            fontSize: 18 / scale,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.textDarkBlue)),
                    const SizedBox(height: 10),
                    Text('Thank you for using SastraX!',
                        style: TextStyle(
                            fontSize: 14 / scale, color: Colors.grey.shade600)),
                  ],
                ),
              ).animate().slideY(delay: 1000.ms, begin: 0.3),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTeamMemberCard(
      Map<String, dynamic> m, int index, double avatarSize, double scale) {
    // Check if the avatar is a file path (starts with 'assets/')
    final bool isImage = m['avatar'].toString().startsWith('assets/');

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              children: [
                // Conditional logic to display either an image or a text avatar
                if (isImage)
                  Container(
                    width: avatarSize,
                    height: avatarSize,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: m['color'].withOpacity(0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                      image: DecorationImage(
                        image: AssetImage(m['avatar']),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ).animate().scale(
                      delay: (200 + index * 100).ms,
                      curve: Curves.elasticOut,
                      duration: 400.ms)
                else
                  Container(
                    width: avatarSize,
                    height: avatarSize,
                    decoration: BoxDecoration(
                      color: m['color'],
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: m['color'].withOpacity(0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                          (m['avatar'] as String).substring(0, 1),
                          style: TextStyle(
                              fontSize: 28 / scale,
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                    ),
                  ).animate().scale(
                      delay: (200 + index * 100).ms,
                      curve: Curves.elasticOut,
                      duration: 400.ms),

                const SizedBox(width: 16),

                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(m['name'],
                          style: TextStyle(
                              fontSize: 20 / scale,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.textDarkBlue)),
                      const SizedBox(height: 4),
                      Text(m['role'],
                          style: TextStyle(
                              fontSize: 16 / scale,
                              color: m['color'],
                              fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            if (m['description'] != null && m['description'].toString().isNotEmpty)
              Text(m['description'],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 14 / scale,
                      color: Colors.grey.shade700,
                      height: 1.5))
                  .animate()
                  .fadeIn(delay: (400 + index * 100).ms),

            const SizedBox(height: 20),

            Wrap(
              alignment: WrapAlignment.center,
              spacing: 12,
              runSpacing: 12,
              children: [
                _socialButton(
                    icon: Icons.camera_alt,
                    color: Colors.pink,
                    url: m['instagram'],
                    label: 'Instagram',
                    scale: scale),
                _socialButton(
                    icon: Icons.work,
                    color: Colors.blue,
                    url: m['linkedin'],
                    label: 'LinkedIn',
                    scale: scale),
                _socialButton(
                    icon: Icons.article,
                    color: Colors.black,
                    url: m['medium'],
                    label: 'Medium',
                    scale: scale),
              ],
            ).animate().slideY(
                delay: (600 + index * 100).ms,
                begin: 0.3,
                duration: 400.ms),
          ],
        ),
      ),
    ).animate().slideX(delay: (index * 150).ms, begin: 0.3);
  }

  Widget _socialButton({
    required IconData icon,
    required Color color,
    required String url,
    required String label,
    required double scale,
  }) {
    return GestureDetector(
      onTap: () => _launchURL(url),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(height: 4),
            Text(label,
                style: TextStyle(
                    fontSize: 10 / scale,
                    color: color,
                    fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }

  Future<void> _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      debugPrint('Could not launch $url');
    }
  }
}
