import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:sastra_x/Pages/SGPA_calculator.dart'; // Correct import for CgpaCalculatorPage
import 'package:sastra_x/Pages/internals_page.dart';

import 'about_team_screen.dart';
import 'credits_page.dart';




class MoreOptionsScreen extends StatelessWidget {
  const MoreOptionsScreen({super.key});

  final List<Map<String, dynamic>> _options = const [
    {
      'title': 'Student Internals',
      'subtitle': 'View marks & grades',
      'icon': Icons.assessment,
      'color': Colors.blue, // This color is specific to this card's design
      'route': 'internals',
    },
    {
      'title': 'Credits',
      'subtitle': 'View Credits',
      'icon': Icons.assignment, // Changed icon to a more fitting one
      'color': Colors.green,
      'route': 'credits',
    },
    {
      'title': 'SGPA calculator',
      'subtitle': 'Calculate your SGPA', // More descriptive subtitle
      'icon': Icons.calculate_sharp,
      'color': Colors.purple,
      'route': 'sgpa',
    },
    {
      'title': 'Student Clubs',
      'subtitle': 'Explore clubs & societies', // More descriptive subtitle
      'icon': Icons.groups,
      'color': Colors.teal,
      'route': 'clubs',
    },
    {
      'title': 'Library',
      'subtitle': 'Digital library access',
      'icon': Icons.library_books,
      'color': Colors.brown,
      'route': 'library',
    },
    {
      'title': 'Transport',
      'subtitle': 'Bus routes & timings',
      'icon': Icons.directions_bus,
      'color': Colors.orange,
      'route': 'transport',
    },
    {
      'title': 'College Events',
      'subtitle': 'Stay updated on events', // More descriptive subtitle
      'icon': Icons.event,
      'color': Colors.pink,
      'route': 'events',
    },
    {
      'title': 'About Team',
      'subtitle': 'Meet the developers',
      'icon': Icons.info_outline,
      'color': Colors.indigo,
      'route': 'about_team',
    },
    {
      'title': 'Settings',
      'subtitle': 'App preferences',
      'icon': Icons.settings,
      'color': Colors.grey,
      'route': 'settings',
    },
    {
      'title': 'Help & Support',
      'subtitle': 'Get assistance', // More descriptive subtitle
      'icon': Icons.help_outline,
      'color': Colors.red,
      'route': 'help',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min, // Make column take minimum space
        children: [
          // Handle
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Title
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Icon(
                  Icons.apps,
                  // This icon will change color based on the current app theme's primary color
                  color: Theme.of(context).colorScheme.primary,

                  size: 32, // Increased icon size
                ),
                const SizedBox(width: 16), // Increased spacing
                const Text(
                  'More Options',
                  style: TextStyle(
                    fontSize: 28, // Increased font size
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ).animate().slideY(begin: -0.3, end: 0), // Animation for title

          // Options Grid
          Flexible( // Use Flexible to allow the GridView to take available height but not overflow
            child: Container(
              constraints: BoxConstraints(
                // Limit max height to 70% of screen height to prevent overflow on smaller screens
                maxHeight: MediaQuery.of(context).size.height * 0.7,
              ),
              child: GridView.builder(
                shrinkWrap: true, // Important for nested scrollables
                padding: const EdgeInsets.symmetric(horizontal: 20),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 20, // Increased spacing
                  mainAxisSpacing: 20, // Increased spacing
                  childAspectRatio: 1.2, // Adjusted aspect ratio for better card size
                ),
                itemCount: _options.length,
                itemBuilder: (context, index) {
                  final option = _options[index];
                  return _buildOptionCard(context, option, index);
                },
              ),
            ),
          ),

          const SizedBox(height: 20), // Spacing at the bottom
        ],
      ),
    );
  }

  Widget _buildOptionCard(BuildContext context, Map<String, dynamic> option, int index) {
    // Explicitly cast the dynamic 'color' to Color to ensure type safety
    final Color cardColor = option['color'] as Color;

    return GestureDetector(
      onTap: () => _handleOptionTap(context, option['route']),
      child: Container(
        decoration: BoxDecoration(
          color: cardColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: cardColor.withOpacity(0.3),
          ),
          boxShadow: [
            BoxShadow(
              color: cardColor.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20), // Increased padding around icon
              decoration: BoxDecoration(
                color: cardColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Icon(
                option['icon'],
                size: 40, // Increased icon size
                color: cardColor, // This color is specific to the card, not the theme's primary color
              ),
            ),
            const SizedBox(height: 16), // Increased spacing
            Text(
              option['title'],
              style: TextStyle(
                fontSize: 16, // Increased font size
                fontWeight: FontWeight.bold,
                color: cardColor,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6), // Increased spacing
            Text(
              option['subtitle'],
              style: TextStyle(
                fontSize: 12, // Increased font size
                color: Colors.grey.shade600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ).animate().scale( // Animation for each card
        delay: (index * 50).ms, // Staggered animation
        curve: Curves.elasticOut,
      ),
    );
  }

  void _handleOptionTap(BuildContext context, String route) {

    Navigator.pop(context);

    switch (route) {
      case 'internals':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => InternalsPage()),
        );
        break;
      case 'credits':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const CreditsScreen()),
        );
        break;
      case 'about_team':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AboutTeamScreen()),
        );
        break;
      case 'sgpa':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const CgpaCalculatorPage()), // Ensure const for stateless
        );
        break; // Added break for 'sgpa' case

      /*case 'clubs':
      case 'library':
      case 'transport':
      case 'events':
      case 'settings':
      case 'help':*/
      default: // Catches any routes not explicitly handled above
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${route.replaceAll('_', ' ').toUpperCase()} feature coming soon!'),
            backgroundColor: Colors.blue,
            behavior: SnackBarBehavior.floating, // Makes it float above content
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)), // Rounded corners
            margin: const EdgeInsets.all(16), // Margin from edges for floating snackbar
          ),
        );
        break;
    }
  }
}