import 'package:flutter/material.dart';

class Style {
  Color darkColor = Color(0xff006f69);
  Color prinaryColor = Color(0xff3c9e97);
  Color lightColor = Color(0xff71cfc8);
  Color white = Color(0xffffffff);
  Color gray = Color(0xffe0e0e0);

  Widget showLogo() => Image.asset('assets/images/login.png');
  Widget showTu() => Image.asset('assets/images/tu.png');

  Widget titleH1(String string) => Text(
        string,
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: darkColor,
        ),
      );

  Widget titleH2(String string) => Text(
        string,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w500,
          color: darkColor,
        ),
      );

  Widget titleH3(String string) => Text(
        string,
        style: TextStyle(
          fontSize: 16,
          //fontWeight: FontWeight.bold,
          color: darkColor,
        ),
      );
  Style();
}
