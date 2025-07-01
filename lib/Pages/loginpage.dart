import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:sastra_x/Components/TextUserPassField.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sastra_x/Pages/HomePage.dart';
import 'package:sastra_x/UI/LoginUI.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:http/http.dart' as http;

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

  @override
  void initState() {
    super.initState();

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

  Future<void> _validateCaptcha() async {
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
        Uri.parse('https://firewire-logs-brooklyn-rough.trycloudflare.com/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          // Since you said no username/password needed to verify captcha alone,
          // send dummy values or adjust your backend accordingly
          'regno': 'dummy',
          'pwd': 'dummy',
          'captcha': captchaController.text.trim(),
        }),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        // Success: close dialog and go to HomePage
        Navigator.pop(context);
        Navigator.push(context, MaterialPageRoute(builder: (_) => HomePage()));
      } else {
        // Attempt to decode error message JSON
        try {
          final result = jsonDecode(response.body);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(result['message'] ?? 'Captcha verification failed'),
              backgroundColor: Colors.redAccent,
            ),
          );
        } catch (e) {
          // If decoding fails, show raw response
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: ${response.body}'),
              backgroundColor: Colors.redAccent,
            ),
          );
        }
      }
    } catch (e) {
      // Network or unexpected error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Network or server error: $e'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
                  textStyle: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            TextUserPassField(
              controller: userController,
              hintText: "Register Number",
              passObscure: false,
              errorText: userErrorMessage,
            ),
            const SizedBox(height: 5),
            TextUserPassField(
              controller: passwordController,
              hintText: "Password",
              passObscure: true,
              errorText: passwordErrorMessage,
            ),
            const SizedBox(height: 20),
            Center(
              child: FloatingActionButton(
                onPressed: () {
                  if (userController.text.isEmpty || passwordController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please enter Register Number and Password'),
                        backgroundColor: Colors.redAccent,
                      ),
                    );
                    return;
                  }

                  String captchaUrl =
                      'https://firewire-logs-brooklyn-rough.trycloudflare.com/captcha?ts=${DateTime.now().millisecondsSinceEpoch}';

                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return StatefulBuilder(
                        builder: (BuildContext context, StateSetter setDialogState) {
                          return Center(
                            child: Material(
                              borderRadius: BorderRadius.circular(20),
                              child: Container(
                                constraints: const BoxConstraints(maxWidth: 290),
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: Colors.blue[100],
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const SizedBox(height: 10),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          width: 180,
                                          height: 50,
                                          child: CachedNetworkImage(
                                            imageUrl: captchaUrl,
                                            fit: BoxFit.cover,
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
                                        IconButton(
                                          onPressed: () {
                                            setDialogState(() {
                                              captchaUrl =
                                              'https://firewire-logs-brooklyn-rough.trycloudflare.com/captcha?ts=${DateTime.now().millisecondsSinceEpoch}';
                                            });
                                          },
                                          icon: const Icon(Icons.refresh),
                                        ),
                                      ],
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
                },
                backgroundColor: Colors.blue,
                splashColor: Colors.blue,
                child: Text(
                  "L O G I N ",
                  style: GoogleFonts.lato(fontWeight: FontWeight.w900, fontSize: 10),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
