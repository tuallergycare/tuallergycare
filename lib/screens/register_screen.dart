import 'package:flutter/material.dart';
import 'package:tuallergycare/utility/style.dart';

class RegisterScreen extends StatefulWidget {
  static const routeName = '/register';
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  @override
  Widget build(BuildContext context) {
    double screen;

    Container buildName() {
      return Container(
        // decoration: BoxDecoration(color: Style().white),
        margin: EdgeInsets.only(top: 16),
        width: screen * 0.75,
        child: TextField(
          style: TextStyle(color: Style().darkColor),
          decoration: InputDecoration(
            hintStyle: TextStyle(color: Style().darkColor),
            hintText: 'ชื่อ',
            // prefixIcon: Icon(
            //   Icons.fingerprint,
            //   color: Style().darkColor,
            // ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(color: Style().darkColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(color: Style().lightColor),
            ),
          ),
        ),
      );
    }

    Container buildSurname() {
      return Container(
        //decoration: BoxDecoration(color: Style().white),
        margin: EdgeInsets.only(top: 16),
        width: screen * 0.75,
        child: TextField(
          style: TextStyle(color: Style().darkColor),
          decoration: InputDecoration(
            hintStyle: TextStyle(color: Style().darkColor),
            hintText: 'นามสกุล',
            // prefixIcon: Icon(
            //   Icons.perm_identity,
            //   color: Style().darkColor,
            //  ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(color: Style().darkColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(color: Style().lightColor),
            ),
          ),
        ),
      );
    }

    Container buildEmail() {
      return Container(
        // decoration: BoxDecoration(color: Style().white),
        margin: EdgeInsets.only(top: 16),
        width: screen * 0.75,
        child: TextField(
          style: TextStyle(color: Style().darkColor),
          decoration: InputDecoration(
            hintStyle: TextStyle(color: Style().darkColor),
            hintText: 'อีเมล',
            // prefixIcon: Icon(Icons.perm_identity, color: Style().darkColor),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(color: Style().darkColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(color: Style().lightColor),
            ),
          ),
        ),
      );
    }

    Container buildBD() {
      return Container(
        // decoration: BoxDecoration(color: Style().white),
        margin: EdgeInsets.only(top: 16),
        width: screen * 0.75,
        child: TextField(
          style: TextStyle(color: Style().darkColor),
          decoration: InputDecoration(
            hintStyle: TextStyle(color: Style().darkColor),
            hintText: 'วันเกิด',
            // prefixIcon: Icon(Icons.perm_identity, color: Style().darkColor),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(color: Style().darkColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(color: Style().lightColor),
            ),
          ),
        ),
      );
    }

    Container buildW() {
      return Container(
        // decoration: BoxDecoration(color: Style().white),
        margin: EdgeInsets.only(top: 16),
        width: screen * 0.75,
        child: TextField(
          style: TextStyle(color: Style().darkColor),
          decoration: InputDecoration(
            hintStyle: TextStyle(color: Style().darkColor),
            hintText: 'น้ำหนัก',
            // prefixIcon: Icon(Icons.perm_identity, color: Style().darkColor),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(color: Style().darkColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(color: Style().lightColor),
            ),
          ),
        ),
      );
    }

    Container buildH() {
      return Container(
        // decoration: BoxDecoration(color: Style().white),
        margin: EdgeInsets.only(top: 16),
        width: screen * 0.75,
        child: TextField(
          style: TextStyle(color: Style().darkColor),
          decoration: InputDecoration(
            hintStyle: TextStyle(color: Style().darkColor),
            hintText: 'ส่วนสูง',
            // prefixIcon: Icon(Icons.perm_identity, color: Style().darkColor),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(color: Style().darkColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(color: Style().lightColor),
            ),
          ),
        ),
      );
    }

    Container buildnewRegister() {
      return Container(
        margin: EdgeInsets.only(top: 16),
        width: screen * 0.75,
        child: ElevatedButton(
          onPressed: () {},
          child: Text('ลงทะเบียน'),
          style: ElevatedButton.styleFrom(
            primary: Style().darkColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      );
    }

    screen = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Style().darkColor,
          title: Text('ลงทะเบียน'),
        ),
        body: Center(
          child: Column(
            children: [
              // Row(
              //   children: [
              //     buildName(),
              //     buildSurname(),
              //   ],
              // ),
              Column(
                children: [
                  buildName(),
                  buildSurname(),
                  buildEmail(),
                  buildBD(),
                  buildW(),
                  buildH(),
                  buildnewRegister(),
                ],
              ),
            ],
          ),
        ));
  }
}
