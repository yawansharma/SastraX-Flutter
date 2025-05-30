import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sastra_x/Components/AttendanceBar.dart';
import 'package:sastra_x/Components/MenuBarTile.dart';
import 'package:sastra_x/Pages/InternalPage.dart';
import 'package:sastra_x/Pages/loginpage.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final attendanceWidgets = [
    AttendanceBar(subjectName: 'Operating System', attendancePercent: 1.0),
    AttendanceBar(subjectName: 'Data Base Management System', attendancePercent: 0.72),
    AttendanceBar(subjectName: 'Computer Organisationa and Architecture', attendancePercent: 0.91),
    AttendanceBar(subjectName: 'Methods for Applied Mathematics', attendancePercent: 0.91)
  ];

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
                    const SizedBox(height: 2),
                    const CircleAvatar(
                      radius: 45,
                      child: Image(image: AssetImage('assets/icon/Logo.png')),
                      backgroundColor: Colors.transparent,
                    ),
                    const SizedBox(height: 17),
                    Text(
                      "Hello , STUDENTNAME ",
                      style: GoogleFonts.lato(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 5),
            MenuBarTile(name: 'I N T E R N A L S ', targetPage: InternalPage()),
            const SizedBox(height: 5),
            MenuBarTile(name: 'L O G O U T ', targetPage: LoginPage()),
            const SizedBox(height: 5),
            MenuBarTile(name: 'H E L L O', targetPage: LoginPage()),
            const SizedBox(height: 5),
            MenuBarTile(name: 'B Y E', targetPage: LoginPage()),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 20),
        child: Column(
          children: [
            const SizedBox(height: 30),
            Center(
              child: Column(
                children: [
                  Container(
                    width: 380,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(17),
                    ),
                    child: IntrinsicHeight(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              color: Colors.deepPurple[200],
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(17),
                                bottomLeft: Radius.circular(17),
                              ),
                            ),
                            child: const CircleAvatar(
                              radius: 35,
                              backgroundColor: Colors.transparent,
                              child: Image(image: AssetImage('assets/icon/Avatar.png')),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.deepPurple[100],
                                borderRadius: const BorderRadius.only(
                                  topRight: Radius.circular(17),
                                  bottomRight: Radius.circular(17),
                                ),
                              ),
                              child: const Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Chandresh J',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 23,
                                    ),
                                    softWrap: true,
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    '127014015',
                                    style: TextStyle(
                                      fontSize: 23,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    'B.Tech Information and Communication Technology',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                    softWrap: true,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
                    width: 380,
                    decoration: BoxDecoration(
                      color: Colors.deepPurple[300],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'ATTENDANCE',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        const SizedBox(height: 10),
                        ...attendanceWidgets
                            .map((bar) => Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: bar,
                        ))
                            .toList(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
