import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/theme_model.dart';

class NeonContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final double? width;
  final double? height;
  final Color? color;
  final Color borderColor;
  final List<BoxShadow>? boxShadow;

  const NeonContainer({
    Key? key,
    required this.child,
    this.padding,
    this.width,
    this.height,
    this.color,
    required this.borderColor,
    this.boxShadow, // 💡 And in the constructor.
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, _) {
        return Container(
          width: width,
          height: height,
          padding: padding ?? const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: color ??
                (themeProvider.isDarkMode
                    ? AppTheme.darkSurface
                    : Colors.white),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: borderColor.withOpacity(themeProvider.isDarkMode ? 0.6 : 0.3),
              width: 1.5,
            ),
            boxShadow: boxShadow ?? (themeProvider.isDarkMode
                ? [
              BoxShadow(
                color: borderColor.withOpacity(0.6),
                blurRadius: 12,
                spreadRadius: 2,
              ),
              BoxShadow(
                color: Colors.black.withOpacity(0.4),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ]
                : [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ]),
          ),
          child: child,
        );
      },
    );
  }
}