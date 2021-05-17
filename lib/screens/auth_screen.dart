import 'package:flutter/material.dart';
import 'package:tuallergycare/screens/register_screen.dart';
import 'package:tuallergycare/screens/select_user_screen.dart';
import 'package:tuallergycare/screens/tabs_screen.dart';
import 'package:tuallergycare/utility/style.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthScreen extends StatefulWidget {
  static const routeName = '/authentication';
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  double screen;
  bool statusRedEye = true;
  String _email;
  String _password;

  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    screen = MediaQuery.of(context).size.width;
    // print('screen = $screen');

    TextButton buildRegister() => TextButton(
        onPressed: () => Navigator.of(context).pushNamed(
              RegisterScreen.routeName,
            ),
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

    return Scaffold(
      // floatingActionButton: buildRegister(),
      body: Container(
        decoration: BoxDecoration(color: Style().white),
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: screen * 0.6,
                    child: Style().showLogo(),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Style().titleH1('TU ALLERGY CARE'),
                  Container(
                    decoration: BoxDecoration(color: Style().white),
                    margin: EdgeInsets.only(top: 16),
                    width: screen * 0.75,
                    child: TextFormField(
                      onSaved: (value) {
                        _email = value;
                      },
                      validator: (String value) {
                        if (value.isEmpty) {
                          return 'กรุณากรอกอีเมล';
                        }
                        if (!RegExp(
                                r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
                            .hasMatch(value)) {
                          return 'Please enter a valid email Address';
                        }
                        return null;
                      },
                      style: TextStyle(color: Style().darkColor),
                      decoration: InputDecoration(
                        hintStyle: TextStyle(color: Style().darkColor),
                        hintText: 'อีเมล',
                        prefixIcon:
                            Icon(Icons.perm_identity, color: Style().darkColor),
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
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 16),
                    width: screen * 0.75,
                    child: TextFormField(
                      onSaved: (value) {
                        _password = value;
                      },
                      validator: (String value) {
                        if (value.isEmpty || value.length < 7) {
                          return 'รหัสผ่านต่างมีความยาวอย่างน้อย 7 ตัวอักษร';
                        }
                        return null;
                      },
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
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 16),
                    width: screen * 0.75,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (!_formKey.currentState.validate()) {
                          return;
                        }
                        _formKey.currentState.save();
                        print(_email);
                        print(_password);
                        try {
                          UserCredential authResult =
                              await _auth.signInWithEmailAndPassword(
                            email: _email,
                            password: _password,
                          );
                        } catch (err) {
                          print(err);
                        }
                      },
                      child: Text('เข้าสู่ระบบ'),
                      style: ElevatedButton.styleFrom(
                        primary: Style().darkColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  TextButton(
                      onPressed: () => Navigator.of(context).pushNamed(
                            SelectUserScreen.routeName,
                          ),
                      child: Text(
                        'สร้างบัญชีใหม่',
                        style: TextStyle(color: Style().darkColor),
                      ))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
