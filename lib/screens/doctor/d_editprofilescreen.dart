import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'd_profile_screen.dart';

class DoctorEditProfileScreen extends StatefulWidget {
  static final routeName = '/doctor_edit_profile';
  @override
  _DoctorEditProfileScreenState createState() =>
      _DoctorEditProfileScreenState();
}

class _DoctorEditProfileScreenState extends State<DoctorEditProfileScreen> {
  final currentDoctor = FirebaseAuth.instance.currentUser;
  String _nameDoctor;
  String _genderDoctor;
  String _phoneNumberDoctor;
  String _emailDoctor;
  String _licenseNumber;
  String _specialty;
  String _heightDoctor;
  String _weightDoctor;
  var _isInit = true;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final args = ModalRoute.of(context).settings.arguments
          as ArgumentsDoctorEditProfileScreen;
      _nameDoctor = args.nameDoctor;
      _licenseNumber = args.licenseNumber;
      _specialty = args.specialty;
      _phoneNumberDoctor = args.phoneNumberDoctor;
      _genderDoctor = args.genderDoctor;
      _weightDoctor = args.weightDoctor;
      _heightDoctor = args.heightDoctor;
    }
    _isInit = false;
    super.didChangeDependencies();
  }

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
                  initialValue: _nameDoctor,
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
                    _nameDoctor = value;
                  },
                ),
                TextFormField(
                  initialValue: _genderDoctor,
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
                    _genderDoctor = value;
                  },
                ),
                TextFormField(
                  initialValue: _heightDoctor,
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
                    _heightDoctor = value;
                  },
                ),
                TextFormField(
                  initialValue: _weightDoctor,
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
                    _weightDoctor = value;
                  },
                ),
                TextFormField(
                  initialValue: _phoneNumberDoctor,
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
                    _phoneNumberDoctor = value;
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
                          .collection('doctors')
                          .doc(currentDoctor.uid)
                          .update({
                        'username': _nameDoctor,
                        'gender': _genderDoctor,
                        'phone_number': _phoneNumberDoctor,
                        'height': _heightDoctor,
                        'weight': _weightDoctor,
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
            ),
          ),
        ),
      ),
    );
  }
}
