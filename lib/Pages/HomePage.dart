import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sastra_x/Components/MenuBarTile.dart';
import 'package:sastra_x/Pages/InternalPage.dart';
import 'package:sastra_x/Pages/loginpage.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.deepPurple[300],
        title: Text(
          "SastraX",
          style: GoogleFonts.lato(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      drawer: Drawer(
        backgroundColor: Colors.deepPurple[200],
        width: 250,
        child: ListView(
          children: [
            Container(
              color: Colors.deepPurple[200],
              child: DrawerHeader(
              child: Column(
                children: [
                  const SizedBox(height : 2),
                  const CircleAvatar(radius: 45 , child: Image(image: AssetImage('assets/icon/Logo.png')),backgroundColor: Colors.transparent,),
                  const SizedBox(height: 17),
                  Text("Hello , STUDENTNAME " , style: GoogleFonts.lato(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),),
                ],
              ),
              ),
            ),
            const SizedBox(height: 5),
            MenuBarTile(name: 'I N T E R N A L S ', targetPage: InternalPage()),
            const SizedBox(height : 5),
            MenuBarTile(name : 'L O G O U T ' , targetPage : LoginPage()),
            const SizedBox(height : 5),
            MenuBarTile(name: 'H E L L O', targetPage: LoginPage()),
            const SizedBox(height : 5),
            MenuBarTile(name: 'H E L L O', targetPage: LoginPage()),
          ],
        )
        )
      );
  }
}
