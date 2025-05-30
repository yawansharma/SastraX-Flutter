import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AttendanceBar extends StatelessWidget {
  final double attendancePercent;
  final String subjectName ;
  const AttendanceBar({super.key , required this.attendancePercent , required this.subjectName
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.deepPurple[100],
        borderRadius: BorderRadius.circular(20)
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AutoSizeText(
            subjectName,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 25,
            ),
            maxLines: 1,
          ),
          SizedBox(height: 10),
          LinearProgressIndicator(
            backgroundColor: Colors.white,
            value: attendancePercent,
            minHeight: 20,
            color: attendancePercent >= 0.80 ? Colors.green : Colors.red,
          ),
          Positioned.fill(child: Center(
            child: Text(
              '${(attendancePercent * 100).toStringAsFixed(1)}%',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold ,
                color: Colors.black,
              ),
            ),
          )),
          SizedBox(height: 10),
        ],
      ),
    );
  }
}
