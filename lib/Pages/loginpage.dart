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
  void _showLoginPopup() {
    showDialog(
      context: context,
      barrierDismissible: false, // set to true if you want tap outside to close
      builder: (BuildContext context) {
        return Center(
          child: Container(
            width: 200,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(),
                const SizedBox(height: 15),
                Text(
                  "Logging in...",
                  style: GoogleFonts.lato(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

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
                errorText: userErrorMessage, // Pass error message
              ),
              const SizedBox(height: 5),
              TextUserPassField(
                controller: passwordController,
                hintText: "Password",
                passObscure: true,
                errorText: passwordErrorMessage, // Pass error message
              ),
              const SizedBox(height: 20),
              Center(
                child: FloatingActionButton(onPressed: () {
                  if (userController.text.isEmpty || passwordController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Please enter Register Number and Password'),
                        backgroundColor: Colors.redAccent,
                      ),
                    );
                  } else {
                    // Show CAPTCHA dialog
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return Center(
                          child: Material(
                            borderRadius: BorderRadius.circular(20),
                            child: Container(
                              constraints: BoxConstraints(maxWidth: 250),
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Colors.blue[100],
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: SingleChildScrollView(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const SizedBox(height: 10),
                                    Container(
                                      width: 110,
                                      height: 50,
                                      color: Colors.black,
                                    ),
                                    const SizedBox(height: 15),
                                    SizedBox(
                                      width: double.infinity,
                                      child: TextField(
                                        controller: captchaController,
                                        decoration: InputDecoration(
                                          hintText: "Enter CAPTCHA",
                                          hintStyle: TextStyle(fontSize: 12),
                                          contentPadding: EdgeInsets.symmetric(
                                            vertical: 10,
                                            horizontal: 12,
                                          ),
                                          filled: true,
                                          fillColor: Colors.white,
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(10),
                                            borderSide: BorderSide(color: Colors.grey.shade300),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(10),
                                            borderSide: BorderSide(color: Colors.grey.shade600),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    FloatingActionButton.extended(
                                      onPressed: () {
                                        if (captchaController.text.isEmpty) {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(
                                              content: Text('Please enter CAPTCHA'),
                                              backgroundColor: Colors.redAccent,
                                            ),
                                          );
                                          return;
                                        }

                                        Navigator.pop(context); // close the dialog
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) => HomePage()),
                                        );
                                      },
                                      label: Text(
                                        "S U B M I T",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                      backgroundColor: Colors.blue.shade400,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
                  backgroundColor: Colors.blue,
                  splashColor: Colors.blue,
                child: Text("L O G I N " , style : GoogleFonts.lato(
                  fontWeight: FontWeight.w900,
                  fontSize: 10,
                )),
                  ),
              )
            ],
          ),
        ),
      ),
    );
  }
}