import 'package:flutter/material.dart';
import 'package:tuallergycare/screens/first_assess_screen.dart';
import 'package:tuallergycare/utility/style.dart';
import 'package:tuallergycare/widgets/picker_time.dart';
import 'package:tuallergycare/widgets/radio_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class RegisterScreen extends StatefulWidget {
  static const routeName = '/register';
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  String _name;
  String _email;
  String _password;
  String _phoneNumber;
  String _gender;
  String _birthday;

  final _auth = FirebaseAuth.instance;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("ลงทะเบียน")),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'ชื่อ-นามสกุล',
                  ),
                  validator: (String value) {
                    if (value.isEmpty) {
                      return 'กรุณากรอกชื่อ-นามสกุล';
                    }
                    return null;
                  },
                  onSaved: (String value) {
                    _name = value;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'อีเมล'),
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
                  onSaved: (String value) {
                    _email = value;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'เบอร์โทรศัพท์'),
                  maxLength: 10,
                  keyboardType: TextInputType.phone,
                  validator: (String value) {
                    if (value.isEmpty) {
                      return 'กรุณากรอกเบอร์โทรศัพท์';
                    }
                    return null;
                  },
                  onSaved: (String value) {
                    _phoneNumber = value;
                  },
                ),
                Container(
                  child: InputDatePickerFormField(
                    // initialDate: DateTime.now(),
                    fieldLabelText: 'วันเกิด',
                    firstDate: DateTime(DateTime.now().year - 100),
                    lastDate: DateTime(DateTime.now().year + 100),
                    onDateSaved: (date) {
                      _birthday = DateFormat('MM/dd/yyyy').format(date);
                    },
                  ),
                ),
                // DatePickerWidget(),
                Container(
                    alignment: Alignment.centerLeft,
                    margin: EdgeInsets.only(top: 16),
                    child: Column(
                      children: <Widget>[
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'เพศ',
                            style: TextStyle(
                              fontSize: 17,
                            ),
                          ),
                        ),
                        ListTile(
                          title: const Text('ชาย'),
                          leading: Radio(
                            activeColor: Theme.of(context).primaryColor,
                            value: 'ชาย',
                            groupValue: _gender,
                            onChanged: (value) {
                              setState(() {
                                _gender = value;
                              });
                            },
                          ),
                        ),
                        ListTile(
                          title: const Text('หญิง'),
                          leading: Radio(
                            activeColor: Theme.of(context).primaryColor,
                            value: 'หญิง',
                            groupValue: _gender,
                            onChanged: (value) {
                              setState(() {
                                _gender = value;
                              });
                            },
                          ),
                        ),
                      ],
                    )),
                // RadioButtonGroupWidget(),
                TextFormField(
                  decoration: InputDecoration(labelText: 'รหัสผ่าน'),
                  keyboardType: TextInputType.visiblePassword,
                  validator: (String value) {
                    if (value.isEmpty || value.length < 7) {
                      return 'รหัสผ่านต่างมีความยาวอย่างน้อย 7 ตัวอักษร';
                    }
                    return null;
                  },
                  onSaved: (String value) {
                    _password = value;
                  },
                ),
                Container(
                  margin: EdgeInsets.only(top: 30),
                  child: ElevatedButton(
                    onPressed: () async {
                      if (!_formKey.currentState.validate()) {
                        return;
                      }
                      _formKey.currentState.save();

                      try {
                        UserCredential authResult =
                            await _auth.createUserWithEmailAndPassword(
                          email: _email,
                          password: _password,
                        );

                        await FirebaseFirestore.instance
                          .collection('patients')
                          .doc(authResult.user.uid)
                          .set({
                              'username': _name,
                              'email': _email,
                              'password:': _password,
                              'birth_day': _birthday,
                              'gender': _gender,
                              'phone_number': _phoneNumber,
                              'image': null,
                              'status': null,
                              'isFirstLogin': true,
                              'height': null,
                              'weight': null,
                              'disease':null,
                              'medicine': null,
                              'skintest': null,
                              'research': null,
                              'appointment': null,
                            });
                      } catch (err) {
                        print(err);
                      }

                      Navigator.pushNamed(context, FirstAssessScreen.routeName);
                    },
                    child: Text(
                      'ลงทะเบียน',
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Style().darkColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
