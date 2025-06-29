import 'package:flutter/material.dart';
import 'package:sastra_x/Components/TextUserPassField.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sastra_x/Pages/HomePage.dart';
import 'package:sastra_x/UI/LoginUI.dart';
import 'dart:convert';
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
  String? captchaUrl;

  @override
  void initState() {
    super.initState();

    // Fetch the CAPTCHA initially
    fetchCaptcha();

    // Add listeners to clear error messages as the user types
    userController.addListener(() {
      setState(() {
        if (userController.text.isNotEmpty) {
          userErrorMessage = null;
        }
      });
    });

    passwordController.addListener(() {
      setState(() {
        if (passwordController.text.isNotEmpty) {
          passwordErrorMessage = null;
        }
      });
    });

    captchaController.addListener(() {
      setState(() {
        if (captchaController.text.isNotEmpty) {
          captchaErrorMessage = null;
        }
      });
    });
  }

  Future<void> fetchCaptcha() async {
    try {
      final response = await http.get(Uri.parse('https://your-api.com/captcha'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          captchaUrl = '${data['captcha_url']}?ts=${DateTime.now().millisecondsSinceEpoch}';
        });
      } else {
        print('Failed to load CAPTCHA');
      }
    } catch (e) {
      print('Error fetching CAPTCHA: $e');
    }
  }

  void _validateFields() {
    setState(() {
      userErrorMessage = null;
      passwordErrorMessage = null;
      captchaErrorMessage = null;
    });

    if (userController.text.isEmpty) {
      setState(() {
        userErrorMessage = 'This field cannot be empty';
      });
    }

    if (passwordController.text.isEmpty) {
      setState(() {
        passwordErrorMessage = 'This field cannot be empty';
      });
    }

    if (captchaController.text.isEmpty) {
      setState(() {
        captchaErrorMessage = 'This field cannot be empty';
      });
    }

    if (userErrorMessage == null &&
        passwordErrorMessage == null &&
        captchaErrorMessage == null) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              LoginUI(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Welcome to SastraX',
                  style: GoogleFonts.lato(
                    textStyle: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
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
              const SizedBox(height: 10),
              TextUserPassField(
                controller: userController,
                hintText: "Register Number",
                passObscure: false,
                errorText: userErrorMessage,
              ),
              const SizedBox(height: 20),
              TextUserPassField(
                controller: passwordController,
                hintText: "Password",
                passObscure: true,
                errorText: passwordErrorMessage,
              ),
              const SizedBox(height: 30),
              Row(
                children: [
                  const SizedBox(
                    height: 20,
                    width: 10,
                  ),
                  // CAPTCHA image container
                  captchaUrl != null
                      ? Image.network(
                          captchaUrl!,
                          height: 60,
                          width: 120,
                          fit: BoxFit.fill,
                        )
                      : Container(
                          height: 60,
                          width: 120,
                          color: Colors.deepPurpleAccent,
                        ),
                  IconButton(
                    onPressed: fetchCaptcha,
                    icon: const Icon(Icons.refresh, size: 30),
                  ),
                  Expanded(
                    child: TextUserPassField(
                      controller: captchaController,
                      hintText: "Captcha",
                      passObscure: false,
                      errorText: captchaErrorMessage,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: _validateFields,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurpleAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Text(
                    "L O G I N",
                    style: GoogleFonts.lato(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
