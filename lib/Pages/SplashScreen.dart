import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:http/http.dart' as http;

// Placeholder classes to make the example runnable
class TextUserPassField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool passObscure;
  final String? errorText;
  final Color textColor;
  final Color hintColor;

  const TextUserPassField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.passObscure,
    this.errorText,
    required this.textColor,
    required this.hintColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: TextField(
        controller: controller,
        obscureText: passObscure,
        style: TextStyle(color: textColor),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: hintColor),
          errorText: errorText,
        ),
      ),
    );
  }
}

class LoginUI extends StatelessWidget {
  const LoginUI({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      color: Colors.blue.shade900,
      child: const Center(
        child: Text(
          "LOGIN UI",
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  final String regNo;
  const HomePage({super.key, required this.regNo});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Home Page")),
      body: Center(child: Text("Welcome, user $regNo")),
    );
  }
}

class AppTheme {
  static const Color primaryPurple = Colors.deepPurple;
  static const Color textDarkBlue = Colors.blue;
  static const Color backgroundLight = Colors.white;
  static const Color errorRed = Colors.red;
}

class ThemeProvider extends ChangeNotifier {
  bool isDarkMode = false;
  void toggleTheme() {
    isDarkMode = !isDarkMode;
    notifyListeners();
  }
}

// This is the new initial screen that handles the 5ms delay.
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  void initState() {
    super.initState();
    // This is the 5-millisecond delay you requested.
    // After this short duration, it will navigate to the SplashScreen.
    Future.delayed(const Duration(milliseconds: 5), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const SplashScreen(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    // This screen is just a blank container while we wait for the delay.
    return const Scaffold(
      backgroundColor: Colors.white,
    );
  }
}

// The SplashScreen is now a separate screen that is navigated to from MainScreen.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double _opacity = 0.0;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        _opacity = 1.0;
      });
    });

    // The duration the splash screen will be displayed before
    // navigating to the login screen.
    const splashDuration = 3000;

    Future.delayed(const Duration(milliseconds: splashDuration), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => LoginPage(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade900,
      body: Center(
        child: AnimatedOpacity(
          opacity: _opacity,
          duration: const Duration(milliseconds: 1000),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(
                Icons.school,
                size: 100,
                color: Colors.white,
              ),
              SizedBox(height: 20),
              Text(
                "SASTRAX",
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 2,
                ),
              ),
              SizedBox(height: 10),
              Text(
                "Your learning companion",
                style: TextStyle(
                  fontSize: 16,
                  fontStyle: FontStyle.italic,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final userController = TextEditingController();
  final passwordController = TextEditingController();
  final captchaController = TextEditingController();

  String? userErrorMessage;
  String? passwordErrorMessage;
  String? captchaErrorMessage;

  String captchaBaseUrl = 'https://withdrawal-northern-herb-undo.trycloudflare.com';
  late String captchaUrl;

  @override
  void initState() {
    super.initState();
    _refreshCaptcha();

    userController.addListener(() {
      if (userController.text.isNotEmpty) {
        setState(() => userErrorMessage = null);
      }
    });

    passwordController.addListener(() {
      if (passwordController.text.isNotEmpty) {
        setState(() => passwordErrorMessage = null);
      }
    });

    captchaController.addListener(() {
      if (captchaController.text.isNotEmpty) {
        setState(() => captchaErrorMessage = null);
      }
    });
  }

  void _refreshCaptcha() {
    setState(() {
      captchaUrl = '$captchaBaseUrl/captcha?ts=${DateTime.now().millisecondsSinceEpoch}';
    });
  }

  Future<void> _validateCaptcha() async {
    FocusScope.of(context).unfocus();
    if (captchaController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter CAPTCHA'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    try {
      final response = await http.post(
        Uri.parse('$captchaBaseUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'regno': userController.text.trim(),
          'pwd': passwordController.text.trim(),
          'captcha': captchaController.text.trim(),
        }),
      );

      if (response.statusCode == 200) {
        Navigator.pop(context); // Close dialog
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => HomePage(regNo: userController.text)),
        );
      } else {
        final result = jsonDecode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['message'] ?? 'Captcha verification failed'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Network or server error: $e'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  void _showCaptchaDialog() {
    _refreshCaptcha();
    captchaController.clear();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setDialogState) {
            return Center(
              child: Material(
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 330),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.blue[100],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 10),
                      SizedBox(
                        height: 60,
                        width: double.infinity,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Center(
                              child: SizedBox(
                                width: 180,
                                height: 50,
                                child:
                                // You can test with Image.network too
                                // Image.network(captchaUrl),
                                CachedNetworkImage(
                                  key: ValueKey(captchaUrl), // Forces refresh
                                  imageUrl: captchaUrl,
                                  fit: BoxFit.contain,
                                  placeholder: (context, url) => const Center(
                                    child: SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(strokeWidth: 2),
                                    ),
                                  ),
                                  errorWidget: (context, url, error) => Container(
                                    color: Colors.red,
                                    child: const Center(
                                      child: Text(
                                        "Error",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              left: 0,
                              child: IconButton(
                                icon: const Icon(Icons.arrow_back_ios_new),
                                onPressed: () {
                                  captchaController.clear();
                                  Navigator.pop(context);
                                },
                              ),
                            ),
                            Positioned(
                              right: 0,
                              child: IconButton(
                                icon: const Icon(Icons.refresh),
                                onPressed: () {
                                  captchaController.clear();
                                  setDialogState(() {
                                    captchaUrl = '$captchaBaseUrl/captcha?ts=${DateTime.now().millisecondsSinceEpoch}';
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 15),
                      TextField(
                        controller: captchaController,
                        decoration: InputDecoration(
                          hintText: "Enter CAPTCHA",
                          hintStyle: const TextStyle(fontSize: 12),
                          contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      FloatingActionButton.extended(
                        onPressed: _validateCaptcha,
                        label: const Text(
                          "S U B M I T",
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        backgroundColor: Colors.blue.shade400,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      backgroundColor: themeProvider.isDarkMode ? Colors.black : Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const LoginUI(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Enter your Login Credentials',
                style: GoogleFonts.lato(
                  textStyle: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                    color: themeProvider.isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
              ),
            ),
            TextUserPassField(
              controller: userController,
              hintText: "Register Number",
              passObscure: false,
              errorText: userErrorMessage,
              textColor: themeProvider.isDarkMode ? Colors.white : Colors.black,
              hintColor: themeProvider.isDarkMode ? Colors.white70 : Colors.grey,
            ),
            const SizedBox(height: 5),
            TextUserPassField(
              controller: passwordController,
              hintText: "Password",
              passObscure: true,
              errorText: passwordErrorMessage,
              textColor: themeProvider.isDarkMode ? Colors.white : Colors.black,
              hintColor: themeProvider.isDarkMode ? Colors.white70 : Colors.grey,
            ),
            const SizedBox(height: 20),
            Center(
              child: FloatingActionButton(
                onPressed: () {
                  FocusScope.of(context).unfocus();
                  if (userController.text.isEmpty || passwordController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please enter Register Number and Password'),
                        backgroundColor: Colors.redAccent,
                      ),
                    );
                    return;
                  }
                  _showCaptchaDialog();
                },
                backgroundColor: Colors.blue,
                splashColor: Colors.blue,
                child: Text(
                  "L O G I N ",
                  style: GoogleFonts.lato(fontWeight: FontWeight.w900, fontSize: 10),
                ),
              ),
            ),
            Center(
              child: FloatingActionButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => HomePage(regNo: userController.text)));
                },
                mini: true,
                child: const Icon(Icons.arrow_forward),
              ),
            )
          ],
        ),
      ),
    );
  }
}
