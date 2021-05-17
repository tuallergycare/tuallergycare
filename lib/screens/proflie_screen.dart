import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:tuallergycare/screens/edit_profile_screen.dart';
import 'package:tuallergycare/utility/style.dart';
import 'package:tuallergycare/widgets/info_card.dart';
import 'package:image_picker/image_picker.dart';

const sex1 = "เพศ";
const sex2 = "ผู้ชาย";
const birthday1 = "วันเกิด";
const birthday2 = "27 เมษายน 2540";
const w1 = "น้ำหนัก";
const w2 = "70 กิโลกรัม";
const h1 = "ส่วนสูง";
const h2 = "180 เซนติเมตร";
const disease1 = "โรค";
const disease2 = "ภูมิแพ้จมูกอักเสบ";
const drug1 = "ยา";
const drug2 = "Budesonide\nLoratadine";
const skintest1 = "skintest";
const skintest2 = "German cockroaches\nRagweed";
const research1 = "ผลวินิจฉัย";
const research2 = "อาการแย่ลง";
const appointment1 = "ตารางนัด";
const appointment2 =
    "แพทย์หญิง สุดสวย\nวันที่ 02/09/2563\nคลินิคภูมิแพ้\nร.พ.ธรรมศาสตร์\nตึก A ชั้น 2";

class ProfileScreen extends StatefulWidget {
  static const routeName = '/profile';
  @override
  _ProfilescreenState createState() => _ProfilescreenState();
}

enum Profile { patient }

class _ProfilescreenState extends State<ProfileScreen> {
  final currentPatient = FirebaseAuth.instance.currentUser;
  final _picker = ImagePicker();
  File _patientImage;
  String _namePatient;
  String _birthday;
  String _height;
  String _weight;
  String _gender;
  String _phoneNumber;
  String _disease;
  List<String> _medicine = <String>[];
  List<dynamic> _skintest = <dynamic>[];
  String _research;
  Map _appointment;

  @override
  void initState() {
    super.initState();
  }

  Future<void> setImage() async {
    // final ref = FirebaseStorage.instance
    //     .ref()
    //     .child('user_image')
    //     .child(currentPatient.uid + '.jpg');

    // // await ref.putFile(patientImage);

    // final url = await ref.getDownloadURL();

    try {
      final patientImage = await _picker.getImage(
        source: ImageSource.camera,
        imageQuality: 50,
        maxWidth: 150,
      );
      setState(() {
        if (patientImage != null) {
          _patientImage = File(patientImage.path);
        }
      });
    } catch (e) {
      print(e.toString());
    }
  }

  // final ref = FirebaseStorage.instance
  //           .ref()
  //           .child('user_image')
  //           .child(authResult.user.uid + '.jpg');

  //       await ref.putFile(image).onComplete;

  //       final url = await ref.getDownloadURL();

  //       await Firestore.instance
  //           .collection('users')
  //           .document(authResult.user.uid)
  //           .setData({
  //         'username': username,
  //         'email': email,
  //         'image_url': url,
  //       });

  Future<void> OpenDialog() async {
    switch (await showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            children: <Widget>[
              Container(
                height: 230,
                width: 230,
                alignment: Alignment.center,
                child: QrImage(
                  data: currentPatient.uid,
                  version: QrVersions.auto,
                  size: 200,
                ),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, Profile.patient);
                },
                child: const Text(
                  'แพทย์จะเพิ่มคุณเป็นผู้ป่วยที่อยู่ในการดูแลได้ด้วยการสแกนคิวอาร์โค้ดของคุณ',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
            ],
          );
        })) {
    }
  }

  Future<void> loadDataPatient() async {
    try {
      await FirebaseFirestore.instance
          .collection('patients')
          .doc(currentPatient.uid)
          .get()
          .then((DocumentSnapshot documentSnapshot) {
        _namePatient = documentSnapshot['username'];
        _birthday = documentSnapshot['birth_day'];
        _gender = documentSnapshot['gender'];
        _phoneNumber = documentSnapshot['phone_number'];
        _height = documentSnapshot['height'];
        _weight = documentSnapshot['weight'];
        _disease = documentSnapshot['disease'];
        if (documentSnapshot['skintest'] != null) {
          _skintest = documentSnapshot['skintest'];
        } else {
          _skintest = [];
        }
        _research = documentSnapshot['research'];
        _appointment = documentSnapshot['appointment'];
      });

      await FirebaseFirestore.instance
          .collection('patients')
          .doc(currentPatient.uid)
          .collection('medicines')
          .get()
          .then((QuerySnapshot querySnapshot) {
        print(querySnapshot.docs.length);
        _medicine.clear();
        for (int i = 0; i < querySnapshot.docs.length; i++) {
          print(querySnapshot.docs.elementAt(i)['name_medicine']);
          try {
            _medicine.add(querySnapshot.docs.elementAt(i)['name_medicine']);
          } catch (e) {
            print(e);
          }
          print('Hello');
        }
      });
    } catch (e) {
      print(e);
    }
  }

  Widget buildInfoPatient(String nameTag, infoPatient) {
    print('medicines: $_medicine');
    return Container(
      alignment: Alignment.centerLeft,
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Container(
              child: Text(
                nameTag,
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: 25,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 7,
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: infoPatient != null
                    ? Text(
                        infoPatient,
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 25,
                        ),
                      )
                    : Text(
                        'กดปุ่ม\'แก้ไข\'เพื่อเพิ่มข้อมูล',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 20,
                        ),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Object>(
        stream: FirebaseFirestore.instance
            .collection('patients')
            .doc(currentPatient.uid)
            .snapshots(),
        builder: (context, snapshot) {
          return FutureBuilder<Object>(
              future: loadDataPatient(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }
                return Scaffold(
                  appBar: AppBar(
                    backgroundColor: Theme.of(context).primaryColor,
                    elevation: 0,
                    centerTitle: true,
                    title: const Text(
                      'โปรไฟล์',
                    ),
                    actions: <Widget>[
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          Navigator.pushNamed(
                              context, EditProfileScreen.routeName,
                              arguments: ArgumentsEditProfileScreen(
                                _namePatient,
                                _phoneNumber,
                                _birthday,
                                _gender,
                                _height,
                                _weight,
                              ));
                        },
                      ),
                      IconButton(
                          icon: const Icon(Icons.qr_code),
                          onPressed: () {
                            OpenDialog();
                          }),
                    ],
                  ),
                  body: Container(
                    child: SingleChildScrollView(
                      child: Stack(
                        children: [
                          CustomPaint(
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height,
                            ),
                            painter: HeaderContainer(),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                margin: EdgeInsets.only(top: 10),
                                padding: EdgeInsets.fromLTRB(0, 2, 0, 10),
                                width: MediaQuery.of(context).size.width / 2,
                                height: MediaQuery.of(context).size.width / 2,
                                decoration: _patientImage != null
                                    ? BoxDecoration(
                                        border: Border.all(
                                            color: Colors.white, width: 5),
                                        shape: BoxShape.circle,
                                        image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: FileImage(_patientImage),
                                        ),
                                      )
                                    : BoxDecoration(
                                        border: Border.all(
                                            color: Colors.white, width: 5),
                                        shape: BoxShape.circle,
                                        image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: _gender == 'ชาย'
                                              ? AssetImage(
                                                  'assets/images/male.png')
                                              : AssetImage(
                                                  'assets/images/female.png'),
                                        ),
                                      ),
                              ),
                              TextButton.icon(
                                onPressed: setImage,
                                icon: Icon(
                                  Icons.image,
                                  color: Theme.of(context).primaryColor,
                                ),
                                label: Text(
                                  'Add Image',
                                  style: TextStyle(
                                      color: Theme.of(context).primaryColor),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.all(10),
                                child: Text(
                                  _namePatient,
                                  style: TextStyle(
                                    fontSize: 30.0,
                                    color: Colors.teal,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Container(
                                  child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 40),
                                child: SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      buildInfoPatient('เพศ', _gender),
                                      buildInfoPatient('วันเกิด', _birthday),
                                      buildInfoPatient(
                                          'โทรศัพท์', _phoneNumber),
                                      buildInfoPatient('น้ำหนัก', _weight),
                                      buildInfoPatient('ส่วนสูง', _height),
                                      Container(
                                        alignment: Alignment.centerLeft,
                                        child: Row(
                                          children: [
                                            Expanded(
                                              flex: 3,
                                              child: Container(
                                                child: Text(
                                                  'โรค',
                                                  style: TextStyle(
                                                    color: Theme.of(context)
                                                        .primaryColor,
                                                    fontSize: 25,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              flex: 7,
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  border: Border(
                                                    bottom: BorderSide(
                                                      color: Theme.of(context)
                                                          .primaryColor,
                                                    ),
                                                  ),
                                                ),
                                                child: Padding(
                                                  padding: const EdgeInsets.all(
                                                      12.0),
                                                  child: _disease != null
                                                      ? Text(
                                                          _disease,
                                                          style: TextStyle(
                                                            color: Theme.of(
                                                                    context)
                                                                .primaryColor,
                                                            fontSize: 25,
                                                          ),
                                                        )
                                                      : Text(
                                                          'พบแพทย์เพื่อเพิ่มข้อมูล',
                                                          style: TextStyle(
                                                            color: Colors.grey,
                                                            fontSize: 20,
                                                          ),
                                                        ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        alignment: Alignment.centerLeft,
                                        child: Row(
                                          children: [
                                            Expanded(
                                              flex: 3,
                                              child: Container(
                                                child: Text(
                                                  'ยา',
                                                  style: TextStyle(
                                                    color: Theme.of(context)
                                                        .primaryColor,
                                                    fontSize: 25,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              flex: 7,
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  border: Border(
                                                    bottom: BorderSide(
                                                      color: Theme.of(context)
                                                          .primaryColor,
                                                    ),
                                                  ),
                                                ),
                                                child: Padding(
                                                  padding: const EdgeInsets.all(
                                                      12.0),
                                                  child: _medicine.length != 0
                                                      ? Column(
                                                          children: [
                                                            ListView.builder(
                                                              scrollDirection:
                                                                  Axis.vertical,
                                                              shrinkWrap: true,
                                                              itemBuilder:
                                                                  (context,
                                                                      index) {
                                                                return Text(
                                                                  _medicine[
                                                                      index],
                                                                  style:
                                                                      TextStyle(
                                                                    color: Theme.of(
                                                                            context)
                                                                        .primaryColor,
                                                                    fontSize:
                                                                        25,
                                                                  ),
                                                                );
                                                              },
                                                              itemCount:
                                                                  _medicine
                                                                      .length,
                                                            ),
                                                          ],
                                                        )
                                                      // Text(
                                                      //     _medicine,
                                                      //     style: TextStyle(
                                                      //       color: Theme.of(context)
                                                      //           .primaryColor,
                                                      //       fontSize: 25,
                                                      //     ),
                                                      //   )
                                                      : Text(
                                                          'พบแพทย์เพื่อเพิ่มข้อมูล',
                                                          style: TextStyle(
                                                            color: Colors.grey,
                                                            fontSize: 20,
                                                          ),
                                                        ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        alignment: Alignment.centerLeft,
                                        child: Row(
                                          children: [
                                            Expanded(
                                              flex: 3,
                                              child: Container(
                                                child: Text(
                                                  'skintest',
                                                  style: TextStyle(
                                                    color: Theme.of(context)
                                                        .primaryColor,
                                                    fontSize: 25,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              flex: 7,
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  border: Border(
                                                    bottom: BorderSide(
                                                      color: Theme.of(context)
                                                          .primaryColor,
                                                    ),
                                                  ),
                                                ),
                                                child: Padding(
                                                  padding: const EdgeInsets.all(
                                                      12.0),
                                                  child: _skintest.length != 0
                                                      ? Column(
                                                          children: [
                                                            ListView.builder(
                                                              scrollDirection:
                                                                  Axis.vertical,
                                                              shrinkWrap: true,
                                                              itemBuilder:
                                                                  (context,
                                                                      index) {
                                                                return Text(
                                                                  _skintest[
                                                                      index],
                                                                  style:
                                                                      TextStyle(
                                                                    color: Theme.of(
                                                                            context)
                                                                        .primaryColor,
                                                                    fontSize:
                                                                        25,
                                                                  ),
                                                                );
                                                              },
                                                              itemCount:
                                                                  _skintest
                                                                      .length,
                                                            ),
                                                          ],
                                                        )
                                                      // Text(
                                                      //     _medicine,
                                                      //     style: TextStyle(
                                                      //       color: Theme.of(context)
                                                      //           .primaryColor,
                                                      //       fontSize: 25,
                                                      //     ),
                                                      //   )
                                                      : Text(
                                                          'พบแพทย์เพื่อเพิ่มข้อมูล',
                                                          style: TextStyle(
                                                            color: Colors.grey,
                                                            fontSize: 20,
                                                          ),
                                                        ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        alignment: Alignment.centerLeft,
                                        child: Row(
                                          children: [
                                            Expanded(
                                              flex: 3,
                                              child: Container(
                                                child: Text(
                                                  'ผลวินิจฉัย',
                                                  style: TextStyle(
                                                    color: Theme.of(context)
                                                        .primaryColor,
                                                    fontSize: 25,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              flex: 7,
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  border: Border(
                                                    bottom: BorderSide(
                                                      color: Theme.of(context)
                                                          .primaryColor,
                                                    ),
                                                  ),
                                                ),
                                                child: Padding(
                                                  padding: const EdgeInsets.all(
                                                      12.0),
                                                  child: _research != null
                                                      ? Text(
                                                          _research,
                                                          style: TextStyle(
                                                            color: Theme.of(
                                                                    context)
                                                                .primaryColor,
                                                            fontSize: 25,
                                                          ),
                                                        )
                                                      : Text(
                                                          'พบแพทย์เพื่อเพิ่มข้อมูล',
                                                          style: TextStyle(
                                                            color: Colors.grey,
                                                            fontSize: 20,
                                                          ),
                                                        ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        alignment: Alignment.centerLeft,
                                        child: Row(
                                          children: [
                                            Expanded(
                                              flex: 3,
                                              child: Container(
                                                child: Text(
                                                  'นัดหมาย',
                                                  style: TextStyle(
                                                    color: Theme.of(context)
                                                        .primaryColor,
                                                    fontSize: 25,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              flex: 7,
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  border: Border(
                                                    bottom: BorderSide(
                                                      color: Theme.of(context)
                                                          .primaryColor,
                                                    ),
                                                  ),
                                                ),
                                                child: Padding(
                                                  padding: const EdgeInsets.all(
                                                      12.0),
                                                  child: _appointment != null
                                                      ? Text(
                                                          '${_appointment['time']}\n ${DateFormat.yMd().format(DateTime.fromMicrosecondsSinceEpoch(_appointment['day'].microsecondsSinceEpoch))}',
                                                          style: TextStyle(
                                                            color: Theme.of(
                                                                    context)
                                                                .primaryColor,
                                                            fontSize: 25,
                                                          ),
                                                        )
                                                      : Text(
                                                          'พบแพทย์เพื่อเพิ่มข้อมูล',
                                                          style: TextStyle(
                                                            color: Colors.grey,
                                                            fontSize: 20,
                                                          ),
                                                        ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ))
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              });
        });
  }
}

class HeaderContainer extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..color = Color.fromRGBO(59, 155, 149, 1);
    Path path = Path()
      ..relativeLineTo(0, 100)
      ..quadraticBezierTo(size.width / 2, 180, size.width, 100)
      ..relativeLineTo(0, -100)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class ArgumentsEditProfileScreen {
  final String name;
  final String weight;
  final String height;
  final String phoneNumber;
  final String gender;
  final String birthday;

  ArgumentsEditProfileScreen(
    this.name,
    this.phoneNumber,
    this.birthday,
    this.gender,
    this.height,
    this.weight,
  );
}
