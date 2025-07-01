import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:sastra_x/Components/TextUserPassField.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sastra_x/Pages/HomePage.dart';
import 'package:sastra_x/UI/LoginUI.dart';
<<<<<<< HEAD
import 'dart:convert';
=======
import 'package:cached_network_image/cached_network_image.dart';
>>>>>>> a9bcdc3633c83c9962b75bfbec27c11c56ee4e90
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

  String captchaUrl =
      'https://consulting-guatemala-optional-reload.trycloudflare.com/captcha?ts=${DateTime.now().millisecondsSinceEpoch}';

  @override
  void initState() {
    super.initState();

<<<<<<< HEAD
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

=======
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
>>>>>>> a9bcdc3633c83c9962b75bfbec27c11c56ee4e90
    if (captchaController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter CAPTCHA'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

<<<<<<< HEAD
    if (userErrorMessage == null &&
        passwordErrorMessage == null &&
        captchaErrorMessage == null) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
=======
    try {
      final response = await http.post(
        Uri.parse('https://consulting-guatemala-optional-reload.trycloudflare.com/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'regno': userController.text.trim(),
          'pwd': passwordController.text.trim(),
          'captcha': captchaController.text.trim(),
        }),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        Navigator.pop(context);
        Navigator.push(context, MaterialPageRoute(builder: (_) => HomePage()));
      } else {
        try {
          final result = jsonDecode(response.body);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(result['message'] ?? 'Captcha verification failed'),
              backgroundColor: Colors.redAccent,
            ),
          );
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: ${response.body}'),
              backgroundColor: Colors.redAccent,
            ),
          );
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Network or server error: $e'),
          backgroundColor: Colors.redAccent,
        ),
      );
>>>>>>> a9bcdc3633c83c9962b75bfbec27c11c56ee4e90
    }
  }

  void _showCaptchaDialog() {
    captchaUrl =
    'https://consulting-guatemala-optional-reload.trycloudflare.com/captcha?ts=${DateTime.now().millisecondsSinceEpoch}';
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
                            // Center - CAPTCHA image
                            Center(
                              child: SizedBox(
                                width: 180,
                                height: 50,
                                child: CachedNetworkImage(
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
                            // Back icon
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
                            // Refresh icon
                            Positioned(
                              right: 0,
                              child: IconButton(
                                icon: const Icon(Icons.refresh),
                                onPressed: () {
                                  captchaController.clear();
                                  setDialogState(() {
                                    captchaUrl =
                                    'https://consulting-guatemala-optional-reload.trycloudflare.com/captcha?ts=${DateTime.now().millisecondsSinceEpoch}';
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
                  _showCaptchaDialog();
                },
                backgroundColor: Colors.blue,
                splashColor: Colors.blue,
                child: Text(
                  "L O G I N ",
                  style: GoogleFonts.lato(fontWeight: FontWeight.w900, fontSize: 10),
                ),
              ),
<<<<<<< HEAD
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
=======
            ),
          ],
>>>>>>> a9bcdc3633c83c9962b75bfbec27c11c56ee4e90
        ),
      ),
    );
  }
}
