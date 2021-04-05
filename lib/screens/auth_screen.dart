import 'package:flutter/material.dart';
import 'package:tuallergycare/screens/register_screen.dart';
import 'package:tuallergycare/screens/tabs_screen.dart';
import 'package:tuallergycare/utility/style.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  static const routeName = '/authentication';
  double screen;
  bool statusRedEye = true;

  @override
  Widget build(BuildContext context) {
    screen = MediaQuery.of(context).size.width;
    print('screen = $screen');

    TextButton buildRegister() => TextButton(
        onPressed: () => Navigator.of(context).pushNamed(RegisterScreen.routeName,),
        child: Text(
          'สร้างบัญชีใหม่',
          style: TextStyle(color: Style().darkColor),
        ));

    TextButton buildforgetPassword() => TextButton(
        onPressed: () => Navigator.pushNamed(context, '/forgetpassword'),
        child: Text(
          'ลืมรหัสผ่าน',
          style: TextStyle(color: Style().darkColor),
        ));

    Container buildLogin() {
      return Container(
        margin: EdgeInsets.only(top: 16),
        width: screen * 0.75,
        child: ElevatedButton(
          onPressed: () => Navigator.of(context).pushNamed(TabsScreen.routeName,),
          child: Text('เข้าสู่ระบบ'),
          style: ElevatedButton.styleFrom(
            primary: Style().darkColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      );
    }

    Container buildUser() {
      return Container(
        decoration: BoxDecoration(color: Style().white),
        margin: EdgeInsets.only(top: 16),
        width: screen * 0.75,
        child: TextField(
          style: TextStyle(color: Style().darkColor),
          decoration: InputDecoration(
            hintStyle: TextStyle(color: Style().darkColor),
            hintText: 'เบอร์โทรศัพท์',
            prefixIcon: Icon(Icons.perm_identity, color: Style().darkColor),
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

    Container buildPassword() {
      return Container(
        margin: EdgeInsets.only(top: 16),
        width: screen * 0.75,
        child: TextField(
          obscureText: statusRedEye,
          style: TextStyle(color: Style().darkColor),
          decoration: InputDecoration(
            suffixIcon: IconButton(
                icon: statusRedEye
                    ? Icon(Icons.remove_red_eye)
                    : Icon(Icons.remove_red_eye_outlined),
                onPressed: () {
                  setState(() {
                    statusRedEye = !statusRedEye;
                  });
                  //print('statusRedEye= $statusRedEye ');
                }),
            hintStyle: TextStyle(color: Style().darkColor),
            hintText: 'รหัสผ่าน',
            prefixIcon: Icon(
              Icons.lock_outline,
              color: Style().darkColor,
            ),
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

    Container buildlogo() {
      return Container(
        width: screen * 0.4,
        child: Style().showLogo(),
      );
    }

    return Scaffold(
      floatingActionButton: buildRegister(),
      body: Container(
        decoration: BoxDecoration(color: Style().white),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Style().titleH1('TU ALLERGY CARE'),
                buildUser(),
                buildPassword(),
                buildLogin(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
