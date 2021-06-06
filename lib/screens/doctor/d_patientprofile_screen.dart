import 'dart:io';
import 'dart:math';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expandable/expandable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:tuallergycare/screens/doctor/d_adddrug_screen.dart';
import 'package:tuallergycare/screens/doctor/d_appointment.dart';
import 'package:tuallergycare/screens/doctor/d_diagnose.dart';
import 'package:tuallergycare/screens/doctor/d_disease.dart';
import 'package:tuallergycare/screens/doctor/d_home_screen.dart';
import 'package:tuallergycare/screens/doctor/d_skintest.dart';
import 'package:tuallergycare/screens/doctor/d_status_screen.dart';
import 'package:tuallergycare/utility/style.dart';
import 'package:tuallergycare/widgets/assess_warning.dart';

class PatientProfileScreen extends StatefulWidget {
  static const routeName = '/patientprofilescreen';

  @override
  _PatientProfileScreenState createState() => _PatientProfileScreenState();
}

class _PatientProfileScreenState extends State<PatientProfileScreen> {
  @override
  Widget build(BuildContext context) {
    String idPatient = ModalRoute.of(context).settings.arguments as String;
    print('idPatientProfile: $idPatient');
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('รายละเอียดผู้ป่วย'),
          bottom: TabBar(
            //isScrollable: true,
            indicatorColor: Colors.white,
            indicatorWeight: 5,
            tabs: [
              Tab(text: 'ข้อมูล'),
              Tab(text: 'แบบประเมิน'),
              Tab(text: 'กราฟ'),
            ],
          ),
          elevation: 10,
          titleSpacing: 10,
        ),
        body: TabBarView(
          children: [
            PatientInfo(idPatient),
            PatientFirstAssessment(idPatient),
            PatientGraph(idPatient),
          ],
        ),
      ),
    );
  }
}

//ข้อมูล
class PatientInfo extends StatefulWidget {
  final String patientId;
  PatientInfo(this.patientId);

  @override
  _PatientInfoState createState() => _PatientInfoState(patientId);
}

class _PatientInfoState extends State<PatientInfo> {
  String patientId;
  _PatientInfoState(this.patientId);
  final currentDoctor = FirebaseAuth.instance.currentUser;
  File _patientImage;
  String _namePatient;
  String _birthday;
  String _height;
  String _weight;
  String _gender;
  String _imagePatient;
  String _phoneNumber;
  String _status;
  String _disease;
  List<dynamic> _medicine = <String>[];
  List<dynamic> _skintest = <dynamic>[];
  String _research;
  Map _appointment;

  @override
  void initState() {
    super.initState();
  }

  Widget buildInfoPatient(String nameTag, infoPatient) {
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
                        'ไม่มีข้อมูล',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 18,
                        ),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }

//แก้ไขยา
  Widget buildInfoPatientEditDrug() {
    _medicine.forEach((element) {
      print('e: $element');
    });
    return Container(
      alignment: Alignment.centerLeft,
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Container(
              child: Text(
                'ยา',
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
              // constraints: BoxConstraints(
              // minHeight: 100),

              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: _medicine.length != 0
                    ? Column(
                        children: [
                          MediaQuery.removePadding(
                            removeBottom: true,
                            context: context,
                            child: ListView.builder(
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                return Text(
                                  _medicine[index],
                                  style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontSize: 18,
                                  ),
                                );
                              },
                              itemCount: _medicine.length,
                            ),
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
                        'เพิ่มข้อมูล',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 20,
                        ),
                      ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: IconButton(
              icon: const Icon(
                Icons.edit,
                size: 18,
                color: Colors.grey,
              ),
              onPressed: () => Navigator.of(context).pushNamed(
                AddDrugScreen.routeName,
                arguments: patientId,
              ),
            ),
          ),
        ],
      ),
    );
  }

  //แก้ไขskintest

  List<String> selectedSkintestList = [];
  List<String> skintestList = [
    "Acaia",
    "American cockroaches",
    "Bermuda grass",
    "Blomia tropicalis",
    "Cat",
    "Df",
    "Dog",
    "Dp",
    "German cockroaches",
    "Ragweed",
    "Timothy grass",
  ];

  _showSkintestDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Skin Test"),
            content: MultiSelectChip(
              skintestList,
              onSelectionChanged: (selectedList) {
                selectedSkintestList = selectedList;
              },
            ),
            actions: <Widget>[
              TextButton(
                child: Text(
                  "บันทึก",
                  style: TextStyle(
                    color: Style().prinaryColor,
                  ),
                ),
                onPressed: () async {
                  // selectedSkintestList.forEach((element) {
                  //   print(element);
                  // });

                  await FirebaseFirestore.instance
                      .collection('patients')
                      .doc(patientId)
                      .update({'skintest': selectedSkintestList});

                  selectedSkintestList.clear();
                  setState(() {});
                  Navigator.pop(context);
                },
              )
            ],
          );
        });
  }

  Widget buildInfoPatientEditSkintest() {
    return Container(
      alignment: Alignment.centerLeft,
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Container(
              child: Text(
                'skintest',
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
                child: _skintest.length != 0
                    ? Column(
                        children: [
                          MediaQuery.removePadding(
                            context: context,
                            removeBottom: true,
                            child: ListView.builder(
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                return Text(
                                  _skintest[index],
                                  style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontSize: 18,
                                  ),
                                );
                              },
                              itemCount: _skintest.length,
                            ),
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
                        'เพิ่มข้อมูล',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 20,
                        ),
                      ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: IconButton(
              icon: const Icon(
                Icons.edit,
                size: 18,
                color: Colors.grey,
              ),
              onPressed: () => _showSkintestDialog(),
            ),
          ),
        ],
      ),
    );
  }

  //แก้ไขนัดหมายผู้ป่วย
  Widget buildInfoPatientEditAppointment() {
    return Container(
      alignment: Alignment.centerLeft,
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Container(
              child: Text(
                'นัดหมาย',
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
                child: _appointment != null
                    ? Text(
                        '${_appointment['time']}\n ${DateFormat.yMd().format(DateTime.fromMicrosecondsSinceEpoch(_appointment['day'].microsecondsSinceEpoch))}',
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 18,
                        ),
                      )
                    : Text(
                        'เพิ่มข้อมูล',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 20,
                        ),
                      ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: IconButton(
              icon: const Icon(
                Icons.edit,
                size: 18,
                color: Colors.grey,
              ),
              onPressed: () => Navigator.of(context).pushNamed(
                Appointment.routeName,
                arguments: patientId,
              ),
            ),
          )
        ],
      ),
    );
  }

  //แก้ไขสถานะผู้ป่วย
  Widget buildInfoPatientEditStatus() {
    return Container(
      alignment: Alignment.centerLeft,
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Container(
              child: Text(
                'สถานะ',
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
                child: _status != null
                    ? Text(
                        _status,
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 18,
                        ),
                      )
                    : Text(
                        'เพิ่มข้อมูล',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 20,
                        ),
                      ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: IconButton(
              icon: const Icon(
                Icons.edit,
                size: 18,
                color: Colors.grey,
              ),
              onPressed: () => Navigator.of(context).pushNamed(
                StatusScreen.routeName,
                arguments: patientId,
              ),
            ),
          ),
        ],
      ),
    );
  }

//แก้ไขผลวินิจฉัย
  Widget buildInfoPatientEditReseach() {
    return Container(
      alignment: Alignment.centerLeft,
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Container(
              child: Text(
                'ผลวินิจฉัย',
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
                child: _research != null
                    ? Text(
                        _research,
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 18,
                        ),
                      )
                    : Text(
                        'เพิ่มข้อมูล',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 20,
                        ),
                      ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: IconButton(
              icon: const Icon(
                Icons.edit,
                size: 18,
                color: Colors.grey,
              ),
              onPressed: () => Navigator.of(context).pushNamed(
                Diagnose.routeName,
                arguments: patientId,
              ),
            ),
          ),
        ],
      ),
    );
  }

  //แก้ไขข้อมูลโรค
  Widget buildInfoPatientEditDisease() {
    return Container(
      alignment: Alignment.centerLeft,
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Container(
              child: Text(
                'โรค',
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
                child: _disease != null
                    ? Text(
                        _disease,
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 18,
                        ),
                      )
                    : Text(
                        'เพิ่มข้อมูล',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 20,
                        ),
                      ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: IconButton(
              icon: const Icon(
                Icons.edit,
                size: 18,
                color: Colors.grey,
              ),
              onPressed: () => Navigator.of(context).pushNamed(
                Disease.routeName,
                arguments: patientId,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> loadDataPatient() async {
    try {
      await FirebaseFirestore.instance
          .collection('patients')
          .doc(patientId)
          .get()
          .then((DocumentSnapshot documentSnapshot) {
        _namePatient = documentSnapshot['username'];
        _birthday = documentSnapshot['birth_day'];
        _gender = documentSnapshot['gender'];
        _phoneNumber = documentSnapshot['phone_number'];
        _height = documentSnapshot['height'];
        _weight = documentSnapshot['weight'];
        _imagePatient = documentSnapshot['image'];
        _status = documentSnapshot['status'];
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
          .doc(patientId)
          .collection('medicines')
          .get()
          .then((QuerySnapshot querySnapshot) {
        print('numOfMedi: ${querySnapshot.docs.length}');
        _medicine.clear();
        for (int i = 0; i < querySnapshot.docs.length; i++) {
          print(querySnapshot.docs.elementAt(i)['name_medicine']);
          try {
            _medicine.add(querySnapshot.docs.elementAt(i)['name_medicine']);
          } catch (e) {
            print('putMedicineErrr');
            print(e);
          }
        }
      });
    } catch (e) {
      print('loadMedicineErrr');
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    print('patientId: $patientId');
    print('medi: ${_medicine.length}');
    return StreamBuilder<Object>(
        stream: FirebaseFirestore.instance
            .collection('patients')
            .doc(patientId)
            .snapshots(),
        builder: (context, snapshot) {
          return FutureBuilder(
              future: loadDataPatient(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Scaffold(
                    body: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
                return Scaffold(
                  body: Container(
                    child: SingleChildScrollView(
                      child: Stack(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                margin: EdgeInsets.only(top: 10),
                                padding: EdgeInsets.fromLTRB(0, 2, 0, 10),
                                width: MediaQuery.of(context).size.width / 2,
                                height: MediaQuery.of(context).size.width / 2,
                                decoration: _imagePatient != null
                                    ? BoxDecoration(
                                        border: Border.all(
                                            color: Colors.white, width: 5),
                                        shape: BoxShape.circle,
                                        image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: NetworkImage(_imagePatient),
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
                              Container(
                                padding: EdgeInsets.all(10),
                                child: Text(
                                  _namePatient,
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
                                        buildInfoPatient('เพศ', _gender),
                                        buildInfoPatient('วันเกิด', _birthday),
                                        buildInfoPatient(
                                            'เบอร์โทรศัพท์', _phoneNumber),
                                        buildInfoPatient('น้ำหนัก', _weight),
                                        buildInfoPatient('ส่วนสูง', _height),
                                        buildInfoPatientEditStatus(),
                                        buildInfoPatientEditDisease(),
                                        buildInfoPatientEditDrug(),
                                        buildInfoPatientEditSkintest(),
                                        buildInfoPatientEditReseach(),
                                        buildInfoPatientEditAppointment(),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        Container(
                                          child: ElevatedButton(
                                            style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all<
                                                      Color>(Colors.red),
                                            ),
                                            onPressed: () {
                                              showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  // print('เพิ่มผู้ป่วย');
                                                  return AlertDialog(
                                                    title: Text(
                                                        'ต้องการลบผู้ป่วย?'),
                                                    actions: <Widget>[
                                                      TextButton(
                                                        child: Text(
                                                          'ยืนยัน',
                                                          style: TextStyle(
                                                            fontSize: 18,
                                                            color: Colors.black,
                                                          ),
                                                        ),
                                                        onPressed: () async {
                                                          var _idPatients = [];
                                                          await FirebaseFirestore
                                                              .instance
                                                              .collection(
                                                                  'doctors')
                                                              .doc(currentDoctor
                                                                  .uid)
                                                              .get()
                                                              .then((doc) {
                                                            _idPatients =
                                                                doc.data()[
                                                                    'patients'];
                                                          });

                                                          _idPatients.remove(
                                                              patientId);

                                                          await FirebaseFirestore
                                                              .instance
                                                              .collection(
                                                                  'doctors')
                                                              .doc(currentDoctor
                                                                  .uid)
                                                              .update({
                                                            'patients':
                                                                _idPatients
                                                          });

                                                          Navigator.of(context)
                                                              .pop();
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                      ),
                                                      TextButton(
                                                        child: Text(
                                                          'ยกเลิก',
                                                          style: TextStyle(
                                                            fontSize: 18,
                                                            color: Colors.black,
                                                          ),
                                                        ),
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                          // Navigator.of(context)
                                                          //     .pop();
                                                          // print(scanData.code);
                                                        },
                                                      ),
                                                    ],
                                                  );
                                                },
                                              );
                                            },
                                            child: Text(
                                              'ลบผู้ป่วย',
                                              style: TextStyle(fontSize: 20),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 20,
                                        )
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

//แบบประเมินผู้ป่วยครั้งแรก
class PatientFirstAssessment extends StatefulWidget {
  final String patientId;
  PatientFirstAssessment(this.patientId);

  @override
  _PatientFirstAssessmentState createState() =>
      _PatientFirstAssessmentState(patientId);
}

class _PatientFirstAssessmentState extends State<PatientFirstAssessment> {
  final String patientId;
  _PatientFirstAssessmentState(this.patientId);
  var _isOcularExpanded = false;
  var _isNasalExpanded = false;
  var _isConcludeExpanded = false;
  var hasAssessment = true;
  DateTime createdAssessment;

  List<bool> _itchyOcularLevel = [
    false,
    false,
    false,
    false,
  ];

  List<bool> _redOcularLevel = [
    false,
    false,
    false,
    false,
  ];

  List<bool> _tearingOcularLevel = [
    false,
    false,
    false,
    false,
  ];

  List<bool> _congestionNasalLevel = [
    false,
    false,
    false,
    false,
  ];

  List<bool> _itchyNasalLevel = [
    false,
    false,
    false,
    false,
  ];

  List<bool> _runnyNasalLevel = [
    false,
    false,
    false,
    false,
  ];

  List<bool> _sneezingNasalLevel = [
    false,
    false,
    false,
    false,
  ];

  double _currentSliderValue = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Future loadRecentAssessment() async {
    var data;
    var size;
    try {
      await FirebaseFirestore.instance
          .collection('patients')
          .doc(patientId)
          .collection('assessments')
          .orderBy('created', descending: true)
          .limit(1)
          .get()
          .then((QuerySnapshot querySnapshot) {
        if (querySnapshot.size == 0) {
          hasAssessment = false;
        }
        print(hasAssessment);
        if (hasAssessment) {
          data = querySnapshot.docs.first.data();

          _itchyOcularLevel.setAll(data['assessment']['itchy_ocular'], [true]);
          _redOcularLevel.setAll(data['assessment']['red_ocular'], [true]);
          _tearingOcularLevel
              .setAll(data['assessment']['tearing_ocular'], [true]);
          _congestionNasalLevel
              .setAll(data['assessment']['congrestion_nasal'], [true]);
          _itchyNasalLevel.setAll(data['assessment']['itchy_nasal'], [true]);
          _runnyNasalLevel.setAll(data['assessment']['runny_nasal'], [true]);
          _sneezingNasalLevel
              .setAll(data['assessment']['sneezing_nasal'], [true]);
          _currentSliderValue = data['assessment']['vas_score'].toDouble();
          createdAssessment = DateTime.fromMicrosecondsSinceEpoch(
              data['created'].microsecondsSinceEpoch);
          print(createdAssessment);
        }
      });
    } catch (e) {
      print(e);
    }
  }

  Widget buildToggleOcularButton(
    String title,
    List<bool> listValue,
  ) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            child: Text(
              title,
              style: TextStyle(fontSize: 27),
            ),
          ),
          Container(
            child: ToggleButtons(
              textStyle: TextStyle(
                fontSize: 30,
              ),
              fillColor: Theme.of(context).primaryColor,
              selectedColor: Colors.white,
              children: [
                Text(
                  '0',
                ),
                Text(
                  '1',
                ),
                Text(
                  '2',
                ),
                Text(
                  '3',
                ),
              ],
              onPressed: (int index) {},
              isSelected: listValue,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildToggleNasalButton(
    String title,
    List listValue,
  ) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            child: Text(
              title,
              style: TextStyle(fontSize: 27),
            ),
          ),
          Container(
            child: ToggleButtons(
              textStyle: TextStyle(
                fontSize: 30,
              ),
              fillColor: Theme.of(context).primaryColor,
              selectedColor: Colors.white,
              children: [
                Text(
                  '0',
                ),
                Text(
                  '1',
                ),
                Text(
                  '2',
                ),
                Text(
                  '3',
                ),
              ],
              onPressed: (int index) {},
              isSelected: listValue,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Object>(
        future: loadRecentAssessment(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.connectionState == ConnectionState.active) {}
          return Scaffold(
            body: hasAssessment
                ? Container(
                    width: double.infinity,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            child: Text(
                              'แบบประเมินล่าสุดของผู้ป่วย',
                              style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                          Container(
                            child: Text(
                              'ทำเมื่อ ${DateFormat.yMd().format(
                                DateTime.fromMicrosecondsSinceEpoch(
                                    createdAssessment.microsecondsSinceEpoch),
                              )}',
                              style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                          ExpandableNotifier(
                            controller: ExpandableController(
                                initialExpanded: _isOcularExpanded),
                            child: Padding(
                              padding: EdgeInsets.all(10),
                              child: Container(
                                child: Card(
                                  child: ScrollOnExpand(
                                    scrollOnExpand: true,
                                    scrollOnCollapse: true,
                                    child: ExpandablePanel(
                                      header: Padding(
                                        padding: EdgeInsets.all(10),
                                        child: Text(
                                            'อาการทางตา Tatal Ocular symptom score(TOSS)',
                                            style: TextStyle(
                                              fontSize: 25,
                                              fontWeight: FontWeight.bold,
                                              // color: _isOcularFinished
                                              //     ? Theme.of(context).primaryColor
                                              //     : Colors.black),
                                              color: Theme.of(context)
                                                  .primaryColor,
                                            )),
                                      ),
                                      collapsed: Container(),
                                      expanded: Container(
                                        child: Column(
                                          children: [
                                            AssessWarning(),
                                            SizedBox(
                                              height: 20,
                                            ),
                                            buildToggleOcularButton(
                                              'ระคายเคืองตา',
                                              _itchyOcularLevel,
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            buildToggleOcularButton(
                                              'ตาแดง',
                                              _redOcularLevel,
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            buildToggleOcularButton(
                                              'น้ำตาไหล',
                                              _tearingOcularLevel,
                                            ),
                                          ],
                                        ),
                                      ),
                                      builder: (_, collapsed, expanded) {
                                        return Padding(
                                          padding: EdgeInsets.only(
                                              left: 10, right: 10, bottom: 10),
                                          child: Expandable(
                                            collapsed: collapsed,
                                            expanded: expanded,
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          ExpandableNotifier(
                            controller: ExpandableController(
                                initialExpanded: _isNasalExpanded),
                            child: Padding(
                              padding: EdgeInsets.all(10),
                              child: Container(
                                child: Card(
                                  child: ScrollOnExpand(
                                    scrollOnExpand: true,
                                    scrollOnCollapse: true,
                                    child: ExpandablePanel(
                                      header: Padding(
                                        padding: EdgeInsets.all(10),
                                        child: Text(
                                          'อาการทางจมูก Total Nasal symptom score(TNSS)',
                                          style: TextStyle(
                                              fontSize: 25,
                                              fontWeight: FontWeight.bold,
                                              color: Theme.of(context)
                                                  .primaryColor),
                                        ),
                                      ),
                                      collapsed: Container(),
                                      expanded: Container(
                                        child: Column(
                                          children: [
                                            AssessWarning(),
                                            SizedBox(
                                              height: 20,
                                            ),
                                            buildToggleNasalButton(
                                              'คัดจมูก',
                                              _congestionNasalLevel,
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            buildToggleNasalButton(
                                              'คันจมูก',
                                              _itchyNasalLevel,
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            buildToggleNasalButton(
                                              'จาม',
                                              _sneezingNasalLevel,
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            buildToggleNasalButton(
                                              'น้ำมูกไหล',
                                              _runnyNasalLevel,
                                            ),
                                          ],
                                        ),
                                      ),
                                      builder: (_, collapsed, expanded) {
                                        return Padding(
                                          padding: EdgeInsets.only(
                                              left: 10, right: 10, bottom: 10),
                                          child: Expandable(
                                            collapsed: collapsed,
                                            expanded: expanded,
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          //Coclude
                          ExpandableNotifier(
                            controller: ExpandableController(
                                initialExpanded: _isConcludeExpanded),
                            child: Padding(
                              padding: EdgeInsets.all(10),
                              child: Container(
                                child: Card(
                                  child: ScrollOnExpand(
                                    scrollOnExpand: true,
                                    scrollOnCollapse: true,
                                    child: ExpandablePanel(
                                      header: Padding(
                                        padding: EdgeInsets.all(10),
                                        child: Text(
                                          'โดยรวมแล้วอาการภูมิแพ้จมูกอักเสบวันนี้ รบกวนชีวิตประจำวันของผู้ป่วยมากน้อยเพียงใด',
                                          style: TextStyle(
                                              fontSize: 25,
                                              fontWeight: FontWeight.bold,
                                              color: Theme.of(context)
                                                  .primaryColor),
                                        ),
                                      ),
                                      collapsed: Container(),
                                      expanded: Container(
                                        child: Column(
                                          children: [
                                            Slider(
                                              activeColor: Theme.of(context)
                                                  .primaryColor,
                                              value: _currentSliderValue,
                                              min: 0,
                                              max: 10,
                                              divisions: 10,
                                              label: _currentSliderValue
                                                  .round()
                                                  .toString(),
                                              onChanged: (double value) {},
                                            )
                                          ],
                                        ),
                                      ),
                                      builder: (_, collapsed, expanded) {
                                        return Padding(
                                          padding: EdgeInsets.only(
                                              left: 10, right: 10, bottom: 10),
                                          child: Expandable(
                                            collapsed: collapsed,
                                            expanded: expanded,
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                : Center(
                    child: Container(
                      child: Text(
                        'ผู้ป่วยยังไม่ได้ทำแบบประเมิน',
                        style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87),
                      ),
                    ),
                  ),
          );
        });
  }
}

//กราฟผู้ป่วย
class PatientGraph extends StatefulWidget {
  final String idPatient;
  PatientGraph(this.idPatient);
  @override
  _PatientGraphState createState() => _PatientGraphState(idPatient);
}

class _PatientGraphState extends State<PatientGraph> {
  final String idPatient;
  _PatientGraphState(this.idPatient);
  DateTime today = DateTime.now();
  List<MedicineNote> _medicineNotes = [];
  List<RecordMedicine> _recordMedicines = [];

  List<AssessmentNote> _assessmentNotes = [];

  CalendarController _calendarController;

  Future<void> loadHistoryMidecineAndAssessment() async {
    try {
      await FirebaseFirestore.instance
          .collection('patients')
          .doc(idPatient)
          .collection('medicines')
          .get()
          .then((QuerySnapshot querySnapshot) {
        print(querySnapshot.size);
        querySnapshot.docs.forEach(
          (element) {
            _medicineNotes.add(
              new MedicineNote(
                element.id,
                element.data()['name_medicine'],
                element.data()['type_medicine'],
                element.data()['time_to_take'],
                [],
              ),
            );
          },
        );
      });
    } catch (e) {
      print('Note Err');
      print(e);
    }

    try {
      for (var i = 0; i < _medicineNotes.length; i++) {
        await FirebaseFirestore.instance
            .collection('patients')
            .doc(idPatient)
            .collection('medicines')
            .doc(_medicineNotes.elementAt(i).id)
            .collection('medicine_time')
            .orderBy('create_at', descending: true)
            .limit(62)
            .get()
            .then((QuerySnapshot querySnapshot) {
          if (querySnapshot.size > 0) {
            querySnapshot.docs.forEach((element) {
              _recordMedicines.add(
                new RecordMedicine(
                  element.data()['morning_dose'],
                  element.data()['evening_dose'],
                  element.data()['before_bed_dose'],
                  DateTime.fromMicrosecondsSinceEpoch(
                      element.data()['create_at'].microsecondsSinceEpoch),
                ),
              );
            });
            _medicineNotes.elementAt(i).record.addAll(_recordMedicines);
            _recordMedicines.clear();
          }
        });
      }
    } catch (e) {
      print('Record Err');
      print(e);
    }
    print(_medicineNotes.first.name);
    print(_medicineNotes.first.timeToTake);
    print(_medicineNotes.first.record.length);

    try {
      await FirebaseFirestore.instance
          .collection('patients')
          .doc(idPatient)
          .collection('assessments')
          .orderBy('created', descending: true)
          .limit(62)
          .get()
          .then((QuerySnapshot querySnapshot) {
        querySnapshot.docs.forEach((element) {
          _assessmentNotes.add(
            new AssessmentNote(
              element.data()['assessment']['vas_score'],
              DateTime.fromMicrosecondsSinceEpoch(
                  element.data()['created'].microsecondsSinceEpoch),
            ),
          );
        });

        print('assestFirstVas: ${_assessmentNotes.first.vasScore}');
        print('assestFirstCre: ${_assessmentNotes.first.created}');
      });
    } catch (e) {
      print('Load Assess Err');
      print(e);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _calendarController = CalendarController();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Object>(
        future: loadHistoryMidecineAndAssessment(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
          return SingleChildScrollView(
            child: Container(
              child: Column(children: [
                SizedBox(
                  height: 10,
                ),
                Card(
                  child: TableCalendar(
                    startDay: DateTime(today.year, today.month - 2, today.day),
                    endDay: today,
                    calendarController: _calendarController,
                    headerStyle: HeaderStyle(
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                      ),
                      headerMargin: EdgeInsets.only(
                        bottom: 10,
                      ),
                      titleTextStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                      formatButtonShowsNext: false,
                      formatButtonDecoration: BoxDecoration(
                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      formatButtonTextStyle: TextStyle(
                        color: Colors.white,
                      ),
                      leftChevronIcon: Icon(
                        Icons.chevron_left,
                        color: Colors.white,
                      ),
                      rightChevronIcon: Icon(
                        Icons.chevron_right,
                        color: Colors.white,
                      ),
                    ),
                    calendarStyle: CalendarStyle(),
                    builders: CalendarBuilders(
                      dowWeekdayBuilder: (context, weekday) {
                        return Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.green[100]),
                          ),
                          child: Text(
                            weekday,
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 15),
                          ),
                        );
                      },
                      dayBuilder: (context, date, events) {
                        var numMed = 0;
                        var morningDose;
                        var eveningDose;
                        var beforeBedDose;

                        var takeMorningDose;
                        var takeEveningDose;
                        var takeBeforeBedDose;

                        var result;

                        var isComplete = false;
                        var isIncomplete = false;
                        var isNone = false;

                        List<String> results = [];

                        numMed = _medicineNotes.length;

                        results.clear();

                        for (var i = 0; i < numMed; i++) {
                          if (_medicineNotes.elementAt(i).type == 'inhalers') {
                            morningDose = _medicineNotes
                                .elementAt(i)
                                .timeToTake['morning_dose'];
                            eveningDose = _medicineNotes
                                .elementAt(i)
                                .timeToTake['evening_dose'];

                            _medicineNotes
                                .elementAt(i)
                                .record
                                .forEach((element) {
                              // print('timeeee : ${element.created}');
                              if (date
                                          .toLocal()
                                          .difference(element.created)
                                          .inDays ==
                                      0 &&
                                  date.toLocal().day == element.created.day) {
                                // print(date.toLocal().difference(element.created).inDays);
                                // print('DDDate: ${date.toLocal()}');
                                // print(element.created.timeZoneName);
                                //checkMorning
                                takeMorningDose = element.morningDose;

                                //checkEvening
                                takeEveningDose = element.eveningDose;

                                if (morningDose == takeMorningDose &&
                                    eveningDose == takeEveningDose) {
                                  result = 'complete';
                                } else {
                                  result = 'incompleted';
                                }

                                if (takeMorningDose == false &&
                                    takeEveningDose == false) {
                                  result = 'none';
                                }

                                if (i == 0) {
                                  print(takeMorningDose);
                                  print(takeEveningDose);
                                }

                                results.add(result);
                                result = '';
                                morningDose = false;
                                eveningDose = false;

                                takeMorningDose = false;
                                takeEveningDose = false;
                              } else {}
                            });
                          } else {
                            morningDose = _medicineNotes
                                .elementAt(i)
                                .timeToTake['morning_dose'];
                            eveningDose = _medicineNotes
                                .elementAt(i)
                                .timeToTake['evening_dose'];
                            beforeBedDose = _medicineNotes
                                .elementAt(i)
                                .timeToTake['before_bed_dose'];

                            _medicineNotes
                                .elementAt(i)
                                .record
                                .forEach((element) {
                              // print('DDDate: $date');
                              // print(element.created);
                              if (date
                                          .toLocal()
                                          .difference(element.created)
                                          .inDays ==
                                      0 &&
                                  date.toLocal().day == element.created.day) {
                                //checkMorning
                                takeMorningDose = element.morningDose;

                                //checkEvening
                                takeEveningDose = element.eveningDose;

                                //checkBeforeBed
                                takeBeforeBedDose = element.beforeBedDose;

                                if (morningDose == takeMorningDose &&
                                    eveningDose == takeEveningDose &&
                                    beforeBedDose == takeBeforeBedDose) {
                                  result = 'complete';
                                } else {
                                  result = 'incompleted';
                                }

                                if (takeMorningDose == false &&
                                    takeEveningDose == false &&
                                    takeBeforeBedDose == false) {
                                  result = 'none';
                                }

                                if (i == 0) {
                                  print(takeMorningDose);
                                  print(takeEveningDose);
                                  print(takeBeforeBedDose);
                                }

                                results.add(result);
                                result = '';
                                morningDose = false;
                                eveningDose = false;
                                beforeBedDose = false;

                                takeMorningDose = false;
                                takeEveningDose = false;
                                takeBeforeBedDose = false;
                              } else {}
                            });
                          }
                        }

                        if (results.length != 0) {
                          print('date: ${date.day}');
                          print('results ${results}');

                          if (results
                              .every((element) => element == 'complete')) {
                            isComplete = true;
                          }

                          if (isComplete != true) {
                            if (results.contains('complete') ||
                                results.contains('incompleted')) {
                              isIncomplete = true;
                            } else {
                              isNone = true;
                            }
                          }

                          print('isComplete: $isComplete');
                          print('isIncomplete: $isIncomplete');
                          print('isNone: $isNone');
                        }

                        //Assessment

                        var vas = -1;

                        var isZero = false;
                        var isLessThenFive = false;
                        var isMoreThanFive = false;
                        var isNull = false;

                        for (var i = 0; i < _assessmentNotes.length; i++) {
                          if (date
                                      .toLocal()
                                      .difference(
                                          _assessmentNotes.elementAt(i).created)
                                      .inDays ==
                                  0 &&
                              date.toLocal().day ==
                                  _assessmentNotes.elementAt(i).created.day) {
                            vas = _assessmentNotes.elementAt(i).vasScore;
                          }
                          // if (date
                          //                 .toLocal()
                          //                 .difference(element.created)
                          //                 .inDays ==
                          //             0 &&
                          //         date.toLocal().day == element.created.day)
                        }

                        // print('vas: ${vas}');
                        if (vas == -1) {
                          isNull = true;
                        }

                        if (vas == 0) {
                          isZero = true;
                        }
                        if (vas < 5 && vas != 0) {
                          isLessThenFive = true;
                        }
                        if (vas >= 5) {
                          isMoreThanFive = true;
                        }

                        return Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.green[100]),
                            ),
                            child: Column(
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.only(top: 4, bottom: 7),
                                  child: Container(
                                    child: Text(date.day.toString()),
                                  ),
                                ),
                                Container(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      ClipPath(
                                        clipper: TriangleClipper(),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: isNull
                                                ? Colors.grey[350]
                                                : isMoreThanFive
                                                    ? Colors.red[300]
                                                    : isLessThenFive
                                                        ? Colors.yellow[300]
                                                        : Colors.white,
                                          ),
                                          height: 26,
                                          width: 26,
                                          child: CustomPaint(
                                            painter: ClipperBorderPainter(),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.all(5),
                                        child: Container(
                                          decoration: ShapeDecoration(
                                            shape: CircleBorder(
                                                side: BorderSide(
                                                    color: Colors.black,
                                                    width: 0.3)),
                                            color: isComplete
                                                ? Colors.blue[400]
                                                : isIncomplete
                                                    ? Colors.blue[200]
                                                    : Colors.white,
                                          ),
                                          width: 16,
                                          height: 16,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ));
                      },
                      outsideDayBuilder: (context, date, events) {
                        return Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.green[100]),
                            ),
                            child: Column(
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.only(top: 4, bottom: 7),
                                  child: Container(
                                      child: Text(
                                    date.day.toString(),
                                    style: TextStyle(color: Colors.black45),
                                  )),
                                ),
                              ],
                            ));
                      },
                      unavailableDayBuilder: (context, date, events) {
                        return Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.green[100]),
                            ),
                            child: Column(
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.only(top: 4, bottom: 7),
                                  child: Container(
                                      child: Text(
                                    date.day.toString(),
                                    style: TextStyle(color: Colors.black45),
                                  )),
                                ),
                              ],
                            ));
                      },
                      outsideHolidayDayBuilder: (context, date, events) {
                        return Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.green[100]),
                            ),
                            child: Column(
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.only(top: 4, bottom: 7),
                                  child: Container(
                                      child: Text(
                                    date.day.toString(),
                                    style: TextStyle(color: Colors.black45),
                                  )),
                                ),
                              ],
                            ));
                      },
                      outsideWeekendDayBuilder: (context, date, events) {
                        return Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.green[100]),
                            ),
                            child: Column(
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.only(top: 4, bottom: 7),
                                  child: Container(
                                      child: Text(
                                    date.day.toString(),
                                    style: TextStyle(color: Colors.black45),
                                  )),
                                ),
                              ],
                            ));
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(30, 20, 30, 5),
                  child: Container(
                      child: Column(
                    children: [
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'หมายเหตุ: การใช้ยา',
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 20,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        child: Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.all(5),
                              child: Container(
                                decoration: ShapeDecoration(
                                  shape: CircleBorder(
                                      side: BorderSide(
                                          color: Colors.black, width: 0.3)),
                                  color: Colors.white,
                                ),
                                width: 16,
                                height: 16,
                              ),
                            ),
                            Container(
                              child: Text(
                                'ไม่ได้ใช้ยาหรือทำบันทึก',
                                style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        child: Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.all(5),
                              child: Container(
                                decoration: ShapeDecoration(
                                  shape: CircleBorder(
                                    side: BorderSide(
                                      color: Colors.black,
                                      width: 0.3,
                                    ),
                                  ),
                                  color: Colors.blue[200],
                                ),
                                width: 16,
                                height: 16,
                              ),
                            ),
                            Container(
                              child: Text(
                                'ใช้ยาไม่ครบ',
                                style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        child: Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.all(5),
                              child: Container(
                                decoration: ShapeDecoration(
                                  shape: CircleBorder(
                                    side: BorderSide(
                                      color: Colors.black,
                                      width: 0.3,
                                    ),
                                  ),
                                  color: Colors.blue[400],
                                ),
                                width: 16,
                                height: 16,
                              ),
                            ),
                            Container(
                              child: Text(
                                'ใช้ยาครบ',
                                style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )),
                ),

                /////// หมายเหตุประเมินอาการ
                Padding(
                  padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                  child: Container(
                      child: Column(
                    children: [
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'หมายเหตุ: คะแนนการประเมินอาการ',
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 20,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        child: Row(
                          children: [
                            ClipPath(
                              clipper: TriangleClipper(),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey[350],
                                ),
                                height: 26,
                                width: 26,
                                child: CustomPaint(
                                  painter: ClipperBorderPainter(),
                                ),
                              ),
                            ),
                            Container(
                              child: Text(
                                'ไม่ได้ทำแบบประเมิน',
                                style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        child: Row(
                          children: [
                            ClipPath(
                              clipper: TriangleClipper(),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                ),
                                height: 26,
                                width: 26,
                                child: CustomPaint(
                                  painter: ClipperBorderPainter(),
                                ),
                              ),
                            ),
                            Container(
                              child: Text(
                                'เท่ากับ 0',
                                style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        child: Row(
                          children: [
                            ClipPath(
                              clipper: TriangleClipper(),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.yellow[300],
                                ),
                                height: 26,
                                width: 26,
                                child: CustomPaint(
                                  painter: ClipperBorderPainter(),
                                ),
                              ),
                            ),
                            Container(
                              child: Text(
                                'น้อยกว่า 5',
                                style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        child: Row(
                          children: [
                            ClipPath(
                              clipper: TriangleClipper(),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.red[300],
                                ),
                                height: 26,
                                width: 26,
                                child: CustomPaint(
                                  painter: ClipperBorderPainter(),
                                ),
                              ),
                            ),
                            Container(
                              child: Text(
                                'มากกว่าหรือเท่ากับ 5',
                                style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )),
                )
              ]),
            ),
          );
        });
  }
}

class TriangleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.moveTo(size.width * 1 / 2, size.height * 1 / 4);
    path.lineTo(size.width * 1 / 6, size.height * 3 / 4);
    path.lineTo(size.width * 5 / 6, size.height * 3 / 4);

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}

class ClipperBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 0.4
      ..style = PaintingStyle.stroke;

    final path = Path();
    path.moveTo(size.width * 1 / 2, size.height * 1 / 4);
    path.lineTo(size.width * 1 / 6, size.height * 3 / 4);
    path.lineTo(size.width * 5 / 6, size.height * 3 / 4);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class MultiSelectChip extends StatefulWidget {
  final List<String> skintestList;
  final Function(List<String>) onSelectionChanged;

  MultiSelectChip(this.skintestList, {this.onSelectionChanged});

  @override
  _MultiSelectChipState createState() => _MultiSelectChipState();
}

class _MultiSelectChipState extends State<MultiSelectChip> {
  List<String> selectedChoices = [];
  _buildSkintextSelectList() {
    List<Widget> choices = [];
    widget.skintestList.forEach((item) {
      choices.add(Container(
        padding: const EdgeInsets.all(2.0),
        child: ChoiceChip(
          label: Text(item),
          labelStyle: TextStyle(color: Colors.black, fontSize: 16.0),
          selected: selectedChoices.contains(item),
          onSelected: (selected) {
            setState(() {
              selectedChoices.contains(item)
                  ? selectedChoices.remove(item)
                  : selectedChoices.add(item);
              widget.onSelectionChanged(selectedChoices);
            });
          },
          selectedColor: Style().prinaryColor,
        ),
      ));
    });
    return choices;
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: _buildSkintextSelectList(),
    );
  }
}

class MedicineNote {
  String id;
  String name;
  String type;
  Map timeToTake;
  List<RecordMedicine> record;

  MedicineNote(
    this.id,
    this.name,
    this.type,
    this.timeToTake,
    this.record,
  );
}

class RecordMedicine {
  bool morningDose;
  bool eveningDose;
  bool beforeBedDose;
  DateTime created;

  RecordMedicine(
    this.morningDose,
    this.eveningDose,
    this.beforeBedDose,
    this.created,
  );
}

class AssessmentNote {
  int vasScore;
  DateTime created;

  AssessmentNote(
    this.vasScore,
    this.created,
  );
}
