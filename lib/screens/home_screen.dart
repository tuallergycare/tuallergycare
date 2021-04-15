import 'package:flutter/material.dart';
import 'package:tuallergycare/screens/assess_screen.dart';
import 'package:tuallergycare/widgets/button_home.dart';
import 'package:tuallergycare/widgets/stateBoard.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final DateTime today = DateTime.now();
    String day;
    String month;
    String year;
    double screen = MediaQuery.of(context).size.width;

    switch (today.weekday) {
      case 1:
        day = 'วันจันทร์';
        break;
      case 2:
        day = 'วันอังคาร';
        break;
      case 3:
        day = 'วันพุธ';
        break;
      case 4:
        day = 'วันพฤหัสบดี';
        break;
      case 5:
        day = 'วันศุกร์';
        break;
      case 6:
        day = 'วันเสาร์';
        break;
      case 7:
        day = 'วันอาทิตย์';
        break;
      default:
    }

    switch (today.month) {
      case 1:
        month = 'มกราคม';
        break;
      case 2:
        month = 'กุมภาพันธ์';
        break;
      case 3:
        month = 'มีนาคม';
        break;
      case 4:
        month = 'เมษายน';
        break;
      case 5:
        month = 'พฤษภาคม';
        break;
      case 6:
        month = 'มิถุนายน';
        break;
      case 7:
        month = 'กรกฎาคม';
        break;
      case 8:
        month = 'สิงหาคม';
        break;
      case 9:
        month = 'กันยายน';
        break;
      case 10:
        month = 'ตุลาคม';
        break;
      case 11:
        month = 'พฤศจิกายน';
        break;
      case 12:
        month = 'ธันวาคม';
        break;
      default:
    }

    year = (today.year + 543).toString();

    return Column(
      children: [
        Container(
          child: StateBoard(),
        ),
        Container(
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.all(15),
          child: Text(
            '${day}ที่ ${today.day} ${month} ${year}',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 30),
          child: ButtonHome(
            message: "ยากินวันนี้",
            height: screen*0.25,
            width: screen*0.95,
            color: Colors.blue,
            icon: Icons.book,
            iconSize: 60.0,
            //radius: 46.0,
            onClick: () {
             
            },
          ),
        ),

        Container(
          margin: EdgeInsets.only(top: 30),
          child: ButtonHome(
            message: "ประเมินอาการ",
            height: screen*0.25,
            width: screen*0.95,
            color: Colors.pink,
            icon: Icons.text_snippet_rounded,
            iconSize: 60.0,
            //radius: 46.0,
            onClick: () {
              Navigator.of(context).pushNamed(AssessScreen.routeName);
            },
          ),
        ),
        
        TextButton(
            onPressed: () async{
              await FirebaseAuth.instance.signOut();
            },
            child: Text('ออกจากระบบ'))
      ],
    );
  }
}
