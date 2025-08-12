import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:sastra_x/Pages/home_page.dart';

import 'about_team_screen.dart';
import 'about_team_screen.dart';
import 'credits_page.dart';
import 'SGPA_calculator.dart';
import 'internals_page.dart';

class MoreOptionsScreen extends StatelessWidget {
  const MoreOptionsScreen({super.key});

  static const List<Map<String, dynamic>> _options = [
    {
      'title': 'Student Internals',
      'subtitle': 'View marks & grades',
      'icon': Icons.assessment,
      'color': Colors.blue,
      'route': 'internals',
    },
    {
      'title': 'Credits',
      'subtitle': 'View Credits',
      'icon': Icons.assignment,
      'color': Colors.green,
      'route': 'credits',
    },
    {
      'title': 'SGPA calculator',
      'subtitle': 'Calculate your SGPA',
      'icon': Icons.calculate_sharp,
      'color': Colors.purple,
      'route': 'sgpa',
    },
    {
      'title': 'Student Clubs',
      'subtitle': 'Explore clubs & societies',
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
      'subtitle': 'Stay updated on events',
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
      'subtitle': 'Get assistance',
      'icon': Icons.help_outline,
      'color': Colors.red,
      'route': 'help',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DraggableScrollableSheet(
        initialChildSize: 0.85,
        minChildSize: 0.45,
        maxChildSize: 0.95,
        builder: (ctx, scrollCtrl) {
          return Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
            ),
            child: CustomScrollView(
              controller: scrollCtrl,
              slivers: [
                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      Container(
                        width: 40,
                        height: 4,
                        margin: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.arrow_back, color: Colors.black),
                              onPressed: () => Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (_) => HomePage(regNo:"" )),
                              ),
                            ),

                            Icon(Icons.apps,
                                color: Theme.of(context).colorScheme.primary,
                                size: 30),
                            const SizedBox(width: 16),
                            const Text(
                              'More Options',
                              style: TextStyle(
                                  fontSize: 26, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ).animate().slideY(begin: -0.25, duration: 350.ms),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  sliver: SliverGrid(
                    delegate: SliverChildBuilderDelegate(
                          (ctx, i) => _OptionCard(
                        data: _options[i],
                        onTap: () => _handleTap(context, _options[i]['route']),
                        index: i,
                      ),
                      childCount: _options.length,
                    ),
                    gridDelegate:
                    const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 210,
                      mainAxisSpacing: 20,
                      crossAxisSpacing: 20,
                      childAspectRatio: 0.95,
                    ),
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 24)),
              ],
            ),
          );
        },
      ),
    );
  }

  void _handleTap(BuildContext ctx, String route) {
    Navigator.pop(ctx);
    switch (route) {
      case 'internals':
        Navigator.push(ctx, MaterialPageRoute(builder: (_) => InternalsPage()));
        break;
      case 'credits':
        Navigator.push(ctx, MaterialPageRoute(builder: (_) => const CreditsScreen()));
        break;
      case 'about_team':
        Navigator.push(ctx, MaterialPageRoute(builder: (_) => AboutTeamScreen()));
        break;
      case 'sgpa':
        Navigator.push(ctx, MaterialPageRoute(builder: (_) => const SgpaCalculatorPage()));
        break;
      case 'transport':
        Navigator.push(ctx, MaterialPageRoute(builder: (_) => const MoreOptionsScreen()));
        break;
      case 'clubs':
        Navigator.push(ctx, MaterialPageRoute(builder: (_) => const MoreOptionsScreen()));
        break;
        Navigator.push(ctx, MaterialPageRoute(builder: (_) => InternalsPage()));
        break;
      default:
        ScaffoldMessenger.of(ctx).showSnackBar(
          SnackBar(
            content: Text(
              '${route.replaceAll('_', ' ').toUpperCase()} feature coming soon!',
            ),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            margin: const EdgeInsets.all(16),
          ),
        );
    }
  }
}

class _OptionCard extends StatelessWidget {
  const _OptionCard({
    required this.data,
    required this.onTap,
    required this.index,
  });

  final Map<String, dynamic> data;
  final VoidCallback onTap;
  final int index;

  @override
  Widget build(BuildContext context) {
    final Color color = data['color'] as Color;

    return GestureDetector(
      onTap: onTap,
      child: LayoutBuilder(
        builder: (ctx, constraints) {
          return Container(
            decoration: BoxDecoration(
              color: color.withOpacity(0.10),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: color.withOpacity(0.30)),
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.10),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.20),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Icon(
                      data['icon'],
                      size: 36,
                      color: color,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    data['title'],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    data['subtitle'],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
          ).animate().scale(
              delay: (index * 50).ms,
              curve: Curves.elasticOut,
              duration: 400.ms);
        },
      ),
    );
  }
}
