import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
//import 'package:sastra_x/Pages/loginpage.dart';

class MenuBarTile extends StatelessWidget {
  final String name ;
  final Widget targetPage ;
  MenuBarTile({super.key,required this.name ,  required this.targetPage});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.logout),
      title: GestureDetector(
        onTap: (){
          Navigator.pop(context);
          Navigator.push(context, MaterialPageRoute(builder: (context) => targetPage));
        },
        child: Text(name , style: GoogleFonts.lato(
          fontWeight: FontWeight.bold ,
          color: Colors.black,
        ),
        ),
      ),
    );
  }
}
