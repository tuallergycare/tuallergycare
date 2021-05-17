import 'package:flutter/material.dart';

class DrugEmptyState extends StatelessWidget {
  const DrugEmptyState({Key key,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
       
        children: <Widget>[
          Image.asset(
            'assets/images/medicinebox.png',
            height: 120,
            width: 120,
            fit: BoxFit.cover,
          ),
          SizedBox(height: 8),
          Text(
            'ผู้ป่วยยังไม่มียา',
            style: TextStyle(
              fontWeight: FontWeight.w300, fontSize: 16, //letterSpacing: 1.2
            ),
          )
        ],
      ),
    );
  }
}
