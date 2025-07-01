import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/theme_model.dart';

class NeonContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final double? width;
  final double? height;
  final Color? color;

  const NeonContainer({
    Key? key,
    required this.child,
    this.padding,
    this.width,
    this.height,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, _) {
        return Container(
          width: width,
          height: height,
          padding: padding ?? EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: color ?? (themeProvider.isDarkMode
                ? AppTheme.darkSurface
                : Colors.white),
            borderRadius: BorderRadius.circular(15),
            border: themeProvider.isDarkMode
                ? Border.all(
              color: AppTheme.neonBlue.withOpacity(0.3),
              width: 1,
            )
                : null,
            boxShadow: themeProvider.isDarkMode
                ? [
              BoxShadow(
                color: AppTheme.neonBlue.withOpacity(0.2),
                blurRadius: 10,
                spreadRadius: 1,
              ),
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 5,
                offset: Offset(0, 2),
              ),
            ]
                : [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: child,
        );
      },
    );
  }
}
