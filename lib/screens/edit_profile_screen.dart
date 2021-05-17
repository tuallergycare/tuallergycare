import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tuallergycare/screens/proflie_screen.dart';

class EditProfileScreen extends StatefulWidget {
  static final routeName = '/edit_profile';
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
   final currentPatient = FirebaseAuth.instance.currentUser;
  String _name;
  String _weight;
  String _height;
  String _phoneNumber;
  String _gender;
  var _isInit = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if(_isInit){
      final args =
        ModalRoute.of(context).settings.arguments as ArgumentsEditProfileScreen;
    _name = args.name;
    _weight = args.weight;
    _height = args.height;
    _phoneNumber = args.phoneNumber;
    _gender = args.gender;
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('แก้ไขโปรไฟล์'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(16),
          child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    initialValue: _name,
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
                    initialValue: _phoneNumber,
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
                  TextFormField(
                    initialValue: _gender,
                    decoration: InputDecoration(
                      labelText: 'เพศ',
                    ),
                    keyboardType: TextInputType.number,
                    validator: (String value) {
                      if (value.isEmpty) {
                        return 'กรุณากรอกเพศ';
                      }
                      return null;
                    },
                    onSaved: (String value) {
                      _gender = value;
                    },
                  ),
                  TextFormField(
                    initialValue: _height,
                    decoration: InputDecoration(
                      labelText: 'ส่วนสูง',
                    ),
                    keyboardType: TextInputType.number,
                    validator: (String value) {
                      if (value.isEmpty) {
                        return 'กรุณากรอกส่วนสูง';
                      }
                      return null;
                    },
                    onSaved: (String value) {
                      _height = value;
                    },
                  ),
                  TextFormField(
                    initialValue: _weight,
                    decoration: InputDecoration(
                      labelText: 'น้ำหนัก',
                    ),
                    keyboardType: TextInputType.number,
                    validator: (String value) {
                      if (value.isEmpty) {
                        return 'กรุณากรอกน้ำหนัก';
                      }
                      return null;
                    },
                    onSaved: (String value) {
                      _weight = value;
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

                        await FirebaseFirestore.instance
                          .collection('patients')
                          .doc(currentPatient.uid)
                          .update({
                              'username': _name,
                              'gender': _gender,
                              'phone_number': _phoneNumber,
                              'height': _height,
                              'weight': _weight,
                            });
                            Navigator.pop(context);
                      },
                      child: Text(
                        'บันทึก',
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        primary: Theme.of(context).primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ],
              )),
        ),
      ),
    );
  }
}
