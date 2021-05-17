import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tuallergycare/screens/doctor/d_adddrug_screen.dart';
import 'package:tuallergycare/screens/doctor/d_appointment.dart';
import 'package:tuallergycare/screens/doctor/d_diagnose.dart';
import 'package:tuallergycare/screens/doctor/d_home_screen.dart';
import 'package:tuallergycare/screens/doctor/d_skintest.dart';
import 'package:tuallergycare/utility/style.dart';

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
            PatientFirstAssessment(),
            PatientGraph(),
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

  File _patientImage;
  String _namePatient;
  String _birthday;
  String _height;
  String _weight;
  String _gender;
  String _phoneNumber;
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
    // return Container(
    //   alignment: Alignment.centerLeft,
    //   child: Row(
    //     children: [
    //       Expanded(
    //         flex: 3,
    //         child: Container(
    //           child: Text(
    //             "ยา",
    //             style: TextStyle(
    //               color: Theme.of(context).primaryColor,
    //               fontSize: 18,
    //             ),
    //           ),
    //         ),
    //       ),
    //       Expanded(
    //         flex: 7,
    //         child: Row(
    //           children: [
    //             Container(
    //               decoration: BoxDecoration(
    //                 border: Border(
    //                   bottom: BorderSide(
    //                     color: Theme.of(context).primaryColor,
    //                   ),
    //                 ),
    //               ),
    //               child: Padding(
    //                 padding: const EdgeInsets.all(12.0),
    //                 child: _medicine.length != 0
    //                     ? Column(
    //                         children: [
    //                           ListView.builder(
    //                             scrollDirection: Axis.vertical,
    //                             shrinkWrap: true,
    //                             itemBuilder: (context, index) {
    //                               return Text(
    //                                 _medicine[index],
    //                                 style: TextStyle(
    //                                   color: Theme.of(context).primaryColor,
    //                                   fontSize: 25,
    //                                 ),
    //                               );
    //                             },
    //                             itemCount: _medicine.length,
    //                           ),
    //                         ],
    //                       )
    //                     // Text(
    //                     //     _medicine,
    //                     //     style: TextStyle(
    //                     //       color: Theme.of(context)
    //                     //           .primaryColor,
    //                     //       fontSize: 25,
    //                     //     ),
    //                     //   )
    //                     : Text(
    //                         'พบแพทย์เพื่อเพิ่มข้อมูล',
    //                         style: TextStyle(
    //                           color: Colors.grey,
    //                           fontSize: 20,
    //                         ),
    //                       ),
    //               ),
    //             ),
    //             Expanded(
    //               flex: 1,
    //               child: IconButton(
    //                 icon: const Icon(
    //                   Icons.edit,
    //                   size: 18,
    //                   color: Colors.grey,
    //                 ),
    //                 onPressed: () => Navigator.of(context).pushNamed(
    //                   AddDrugScreen.routeName,
    //                 ),
    //               ),
    //             ),
    //           ],
    //         ),
    //       ),
    //     ],
    //   ),
    // );
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
      stream: FirebaseFirestore.instance.collection('patients').doc(patientId).snapshots(),
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
                              decoration: _patientImage != null
                                  ? BoxDecoration(
                                      border:
                                          Border.all(color: Colors.white, width: 5),
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: FileImage(_patientImage),
                                      ),
                                    )
                                  : BoxDecoration(
                                      border:
                                          Border.all(color: Colors.white, width: 5),
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: _gender == 'ชาย'
                                            ? AssetImage('assets/images/male.png')
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
                                      buildInfoPatient('โรค', _disease),
                                      buildInfoPatientEditDrug(),
                                      buildInfoPatientEditSkintest(),
                                      buildInfoPatientEditReseach(),
                                      buildInfoPatientEditAppointment(),
                                      // buildInfoPatientEdit(
                                      //   'ยา',
                                      //   _medicine,
                                      // ),
                                      // buildInfoPatientEdit('skintest', _skintest),
                                      // buildInfoPatientEdit('ผลวินิจฉัย', _research),
                                      // buildInfoPatientEdit('ตารางนัด', _appointment)
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
      }
    );
  }
}

//แบบประเมินผู้ป่วยครั้งแรก
class PatientFirstAssessment extends StatefulWidget {
  @override
  _PatientFirstAssessmentState createState() => _PatientFirstAssessmentState();
}

class _PatientFirstAssessmentState extends State<PatientFirstAssessment> {
  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}

//กราฟผู้ป่วย
class PatientGraph extends StatefulWidget {
  @override
  _PatientGraphState createState() => _PatientGraphState();
}

class _PatientGraphState extends State<PatientGraph> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
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
