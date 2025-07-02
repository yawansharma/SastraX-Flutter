import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'Pages/loginpage.dart';
import 'models/theme_model.dart';
import 'pages/home_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'SASTRAX Student App',
            theme: themeProvider?.currentTheme,
            home: LoginPage(),
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}
