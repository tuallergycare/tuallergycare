import 'dart:io';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
//import 'package:image_picker/image_picker.dart';
import 'package:tuallergycare/screens/doctor/d_editprofilescreen.dart';
import 'package:tuallergycare/utility/style.dart';

class DoctorProfileScreen extends StatefulWidget {
  static const routeName = '/doctorProfilescreen';
  @override
  DoctorProfileScreenState createState() => DoctorProfileScreenState();
}

enum Profile { doctor }

class DoctorProfileScreenState extends State<DoctorProfileScreen> {
  final currentDoctor = FirebaseAuth.instance.currentUser;
  // File _patientImage;
  // final _picker = ImagePicker();
  var _nameDoctor;
  var _genderDoctor;
  var _emailDoctor;
  var _phoneNumberDoctor;
  var _licenseNumber;
  var _specialty;
  var _heightDoctor;
  var _weightDoctor;
  var _imageDoctor;

  @override
  void initState() {
    super.initState();
  }

  File _doctorImage;

  final picker = ImagePicker();

  Future getImagefromcamera() async {
    final pickedImage = await picker.getImage(
      source: ImageSource.camera,
      imageQuality: 100,
      maxWidth: 300,
    );

    if (pickedImage != null) {
      _doctorImage = File(pickedImage.path);

      final ref = FirebaseStorage.instance
          .ref()
          .child('user_image')
          .child('doctoc_image')
          .child(currentDoctor.uid + '.jpg');

      await ref.putFile(_doctorImage);

      final url = await ref.getDownloadURL();

      await FirebaseFirestore.instance
          .collection('doctors')
          .doc(currentDoctor.uid)
          .update({'image': url});
    }
  }

//  Future<void> setImage() async {
  // final ref = FirebaseStorage.instance
  //     .ref()
  //     .child('user_image')
  //     .child(currentPatient.uid + '.jpg');

  // // await ref.putFile(patientImage);

  // final url = await ref.getDownloadURL();

  //   try {
  //     final patientImage = await _picker.getImage(
  //       source: ImageSource.camera,
  //       imageQuality: 50,
  //       maxWidth: 150,
  //     );
  //     setState(() {
  //       if (patientImage != null) {
  //         _patientImage = File(patientImage.path);
  //       }
  //     });
  //   } catch (e) {
  //     print(e.toString());
  //   }
  // }

  Future<void> loadDataDoctor() async {
    try {
      await FirebaseFirestore.instance
          .collection('doctors')
          .doc(currentDoctor.uid)
          .get()
          .then((DocumentSnapshot documentSnapshot) {
        _nameDoctor = documentSnapshot['username'];
        _genderDoctor = documentSnapshot['gender'];
        _phoneNumberDoctor = documentSnapshot['phone_number'];
        _heightDoctor = documentSnapshot['height'];
        _weightDoctor = documentSnapshot['weight'];
        _licenseNumber = documentSnapshot['license'];
        _specialty = documentSnapshot['specialty'];
        _imageDoctor = documentSnapshot['image'];
      });
    } catch (e) {
      print(e);
    }
  }

  Widget buildInfoDoctor(String nameTag, infoPatient) {
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
                  fontSize: 18,
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
                          fontSize: 18,
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
            .collection('doctors')
            .doc(currentDoctor.uid)
            .snapshots(),
        builder: (context, snapshot) {
          return FutureBuilder(
              future: loadDataDoctor(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return Scaffold(
                  appBar: AppBar(
                    elevation: 0,
                    centerTitle: true,
                    title: const Text("โปรไฟล์"),
                    actions: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            DoctorEditProfileScreen.routeName,
                            arguments: ArgumentsDoctorEditProfileScreen(
                              this._nameDoctor,
                              this._weightDoctor,
                              this._heightDoctor,
                              this._phoneNumberDoctor,
                              this._genderDoctor,
                              this._licenseNumber,
                              this._specialty,
                            ),
                          );
                        },
                      ),
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
                                //   decoration: _patientImage != null
                                //       ? BoxDecoration(
                                //           border: Border.all(color: Colors.white, width: 5),
                                //           shape: BoxShape.circle,
                                //           image: DecorationImage(
                                //             fit: BoxFit.cover,
                                //             image: FileImage(_patientImage),
                                //           ),
                                //         )
                                //       : BoxDecoration(
                                //           border: Border.all(color: Colors.white, width: 5),
                                //           shape: BoxShape.circle,
                                //           image: DecorationImage(
                                //             fit: BoxFit.cover,
                                //             image: _genderDoctor == 'ชาย'
                                //                 ? AssetImage('assets/images/avamys.png')
                                //                 : AssetImage('assets/images/sad.png'),
                                //           ),
                                //         ),
                                // ),
                                decoration: _imageDoctor != null
                                    ? BoxDecoration(
                                        border: Border.all(
                                            color: Colors.white, width: 5),
                                        shape: BoxShape.circle,
                                        image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: NetworkImage(_imageDoctor),
                                        ),
                                      )
                                    : BoxDecoration(
                                        border: Border.all(
                                            color: Colors.white, width: 5),
                                        shape: BoxShape.circle,
                                        image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: AssetImage(
                                              'assets/images/doctor.png'),
                                        ),
                                      ),
                              ),
                              TextButton.icon(
                                onPressed: () {
                                  getImagefromcamera();
                                },
                                //   setImage,
                                icon: Icon(
                                  Icons.image,
                                  color: Theme.of(context).primaryColor,
                                ),
                                label: Text(
                                  'Add Image',
                                  style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.all(10),
                                child: Text(
                                  _nameDoctor,
                                  style: TextStyle(
                                    fontSize: 30.0,
                                    color: Theme.of(context).primaryColor,
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
                                        buildInfoDoctor('เพศ', _genderDoctor),
                                        buildInfoDoctor(
                                            'ส่วนสูง', _heightDoctor),
                                        buildInfoDoctor(
                                            'น้ำหนัก', _weightDoctor),
                                        buildInfoDoctor(
                                            'โทรศัพท์', _phoneNumberDoctor),
                                        buildInfoDoctor(
                                            'เลขที่ใบอนุญาต', _licenseNumber),
                                        buildInfoDoctor(
                                            'ความเชี่ยวชาญ', _specialty),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
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

class ArgumentsDoctorEditProfileScreen {
  String nameDoctor;
  String weightDoctor;
  String heightDoctor;
  String phoneNumberDoctor;
  String genderDoctor;
  String licenseNumber;
  String specialty;

  ArgumentsDoctorEditProfileScreen(
    this.nameDoctor,
    this.weightDoctor,
    this.heightDoctor,
    this.phoneNumberDoctor,
    this.genderDoctor,
    this.licenseNumber,
    this.specialty,
  );
}
