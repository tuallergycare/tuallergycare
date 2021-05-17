import 'package:flutter/material.dart';
import 'package:tuallergycare/screens/doctor/d_form_screen.dart';
import 'package:tuallergycare/screens/register_screen.dart';
import 'package:tuallergycare/utility/style.dart';

class SelectUserScreen extends StatefulWidget {
  static const routeName = '/selectuserscreen';
  @override
  _SelectUserScreenState createState() => _SelectUserScreenState();
}

class _SelectUserScreenState extends State<SelectUserScreen> {
  double screen;
  bool statusRedEye = true;

  @override
  Widget build(BuildContext context) {
    screen = MediaQuery.of(context).size.width;

    Container selectPatient() {
      return Container(
        margin: EdgeInsets.only(top: 16),
        width: screen * 0.75,
        height: screen * 0.18,
        child: ElevatedButton(
          onPressed: () => Navigator.of(context).pushNamed(
            RegisterScreen.routeName,
          ),
          child: Text(
            'ผู้ป่วย',
            style: TextStyle(
              fontSize: 20,
            ),
          ),
          style: ElevatedButton.styleFrom(
            primary: Style().darkColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
        ),
      );
    }

    Container selectDoctor() {
      return Container(
        margin: EdgeInsets.only(top: 16),
        width: screen * 0.75,
        height: screen * 0.18,
        child: ElevatedButton(
          onPressed: () => Navigator.of(context).pushNamed(
            DoctorFormScreen.routeName,
          ),
          child: Text(
            'แพทย์',
            style: TextStyle(
              fontSize: 20,
            ),
          ),
          style: ElevatedButton.styleFrom(
            primary: Style().darkColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text('เลือกประเภทผู้ใช้'),),
      body: Container(
        decoration: BoxDecoration(color: Style().white),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset('assets/images/login.png'),
                Style().titleH1('TU ALLERGY CARE'),
                selectPatient(),
                selectDoctor()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
