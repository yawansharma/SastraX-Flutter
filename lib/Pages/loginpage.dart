import 'package:flutter/material.dart';
import 'package:sastra_x/Components/TextUserPassField.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sastra_x/Pages/HomePage.dart';
import 'package:sastra_x/UI/LoginUI.dart';

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

    // Add listeners to clear error messages as the user types
    userController.addListener(() {
      setState(() {
        if (userController.text.isNotEmpty) {
          userErrorMessage = null; // Clear error when typing starts
        }
      });
    });

    passwordController.addListener(() {
      setState(() {
        if (passwordController.text.isNotEmpty) {
          passwordErrorMessage = null; // Clear error when typing starts
        }
      });
    });

    captchaController.addListener(() {
      setState(() {
        if (captchaController.text.isNotEmpty) {
          captchaErrorMessage = null; // Clear error when typing starts
        }
      });
    });
  }

  void _validateFields() {
    setState(() {
      // Reset error messages before validation
      userErrorMessage = null;
      passwordErrorMessage = null;
      captchaErrorMessage = null;
    });

    // Check if fields are empty
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

    // If no errors, proceed with login
    if (userErrorMessage == null && passwordErrorMessage == null && captchaErrorMessage == null) {
      Navigator.push(context,MaterialPageRoute(builder: (context) => HomePage()));
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
                errorText: userErrorMessage, // Pass error message
              ),
              const SizedBox(height: 20),
              TextUserPassField(
                controller: passwordController,
                hintText: "Password",
                passObscure: true,
                errorText: passwordErrorMessage, // Pass error message
              ),
              const SizedBox(height: 30),
              Row(
                children: [
                  const SizedBox(
                    height: 20,
                    width: 10,
                  ),
                  Container(
                    height: 60,
                    width: 120,
                    color: Colors.deepPurpleAccent,
                  ),
                  IconButton(onPressed: () {}, icon: const Icon(Icons.refresh, size: 30)),
                  Expanded(
                    child: TextUserPassField(
                      controller: captchaController,
                      hintText: "Captcha",
                      passObscure: false,
                      errorText: captchaErrorMessage, // Pass error message
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Center(
                child: ElevatedButton(onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
                },style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurpleAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  )
                ), child: Text("L O G I N" , style: GoogleFonts.lato(
                  fontWeight: FontWeight.bold ,
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
