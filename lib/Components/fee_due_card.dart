// fee_due_card.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/theme_model.dart';

class FeeDueCard extends StatelessWidget {
  final double feeDue;

  const FeeDueCard({Key? key, required this.feeDue}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return Container(
          padding: const EdgeInsets.all(20),
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
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: feeDue > 0
                        ? themeProvider.isDarkMode
                        ? [Color(0xFFFF6B6B), Color(0xFFFF8E8E)]
                        : [Colors.red[400]!, Colors.red[600]!]
                        : themeProvider.isDarkMode
                        ? [AppTheme.neonBlue, AppTheme.electricBlue]
                        : [Colors.green[400]!, Colors.green[600]!],
                  ),
                  boxShadow: themeProvider.isDarkMode
                      ? [
                    BoxShadow(
                      color: (feeDue > 0
                          ? Color(0xFFFF6B6B)
                          : AppTheme.neonBlue)
                          .withOpacity(0.5),
                      blurRadius: 15,
                      spreadRadius: 2,
                    ),
                  ]
                      : null,
                ),
                child: Icon(
                  Icons.account_balance_wallet,
                  size: 30,
                  color: themeProvider.isDarkMode ? Colors.black : Colors.white,
                ),
              ),
              const SizedBox(height: 15),
              Text(
                'Fee Status',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: themeProvider.primaryColor,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                feeDue > 0 ? '₹${feeDue.toInt()}' : 'Paid',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: feeDue > 0
                      ? (themeProvider.isDarkMode
                      ? Color(0xFFFF6B6B)
                      : Colors.red)
                      : (themeProvider.isDarkMode
                      ? AppTheme.neonBlue
                      : Colors.green),
                ),
              ),
              if (feeDue > 0)
                Container(
                  margin: const EdgeInsets.only(top: 10),
                  padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: themeProvider.isDarkMode
                        ? const Color(0xFFFF6B6B).withOpacity(0.2)
                        : Colors.red[50],
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      color: themeProvider.isDarkMode
                          ? const Color(0xFFFF6B6B)
                          : Colors.red[200]!,
                    ),
                  ),
                  child: Text(
                    'Due Soon',
                    style: TextStyle(
                      fontSize: 10,
                      color: themeProvider.isDarkMode
                          ? const Color(0xFFFF6B6B)
                          : Colors.red,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
