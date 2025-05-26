import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class InternalPage extends StatefulWidget {
  const InternalPage({super.key});

  @override
  State<InternalPage> createState() => _InternalPageState();
}

class _InternalPageState extends State<InternalPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurpleAccent,
        leading: GestureDetector(child: const Icon(Icons.arrow_back_ios ) ,
            onTap: ()
           {
               Navigator.pop(context);
           }),
      ),
    );
  }
}
