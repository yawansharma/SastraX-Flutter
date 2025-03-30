import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:sastra_x/Components/TextUserPassField.dart';
import 'package:sastra_x/UI/LoginUI.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginPage extends StatelessWidget {
  final userController = TextEditingController();
  final passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            children: [
              LoginUI() ,
              Container(
                padding: EdgeInsets.only(
                  left: 10,
                ),
                height: 400,
                width: double.maxFinite,
                child:
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                  'Welcome to SASTRAX',
                  style: GoogleFonts.lato
                    (
                    textStyle: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      color: Colors.black,
                    ),
                  ),
                ),
                    Text(
                      'Enter your Login Credentials',
                      style: GoogleFonts.lato
                        (
                        textStyle: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w900,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextUserPassField(controller: userController , hintText: "Register Number",passObscure: false),
                    const SizedBox(height : 20),
                    TextUserPassField(controller: passwordController, hintText: "Password",passObscure: true,),
                ],
                ),
              )
            ],
          ),
        ),
    );
  }
}