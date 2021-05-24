import 'package:expandable/expandable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tuallergycare/models/nosal.dart';
import 'package:tuallergycare/models/ocular.dart';
import 'package:tuallergycare/screens/tabs_screen.dart';
import 'package:tuallergycare/widgets/assess_warning.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AssessScreen extends StatefulWidget {
  static const routeName = '/assessment';

  @override
  _AssessScreenState createState() => _AssessScreenState();
}

class _AssessScreenState extends State<AssessScreen> {
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

  var _ocular = new Ocular();

  bool _isOcularFinished = false;

  bool _isOcularExpanded = false;

  var _nasal = new Nasal();

  bool _isNasalFinished = false;

  bool _isNasalExpanded = false;

  double _currentSliderValue = 0;

  bool _isConcludeFinished = false;

  bool _isCocludeExpanded = false;

  void editAssessment() async {
    final currentPateint = FirebaseAuth.instance.currentUser;
    Map<String, int> _assestment = {};

    // print(_isNasalFinished);
    // print(_isOcularFinished);
    // print(_isConcludeFinished);
    if (_isOcularFinished && _isNasalFinished && _isConcludeFinished) {
      // print(_ocular.getOcularLevel);
      // print(_nasal.getNasalLevel);
      // print(_currentSliderValue);
      _assestment.addAll(_nasal.getNasalLevel);
      _assestment.addAll(_ocular.getOcularLevel);
      _assestment.addAll({'vas_score': _currentSliderValue.toInt()});

      var idRecentAssessment;
      await FirebaseFirestore.instance
          .collection('patients')
          .doc(currentPateint.uid)
          .collection('assessments')
          .orderBy('created', descending: true)
          .limit(1)
          .get()
          .then((QuerySnapshot querySnapshot) {
        idRecentAssessment = querySnapshot.docs.first.id;
      });

      await FirebaseFirestore.instance
          .collection('patients')
          .doc(currentPateint.uid)
          .collection('assessments')
          .doc(idRecentAssessment)
          .update({
        'assessment': _assestment,
        'analysed': false,
      });
      //     .add({
      //   'assessment': _assestment,
      //   'created': Timestamp.now(),
      // });

      // await FirebaseFirestore.instance
      //     .collection('patients')
      //     .doc(currentPateint.uid)
      //     .collection('assessments')
      //     .orderBy('created', descending: true)
      //     .get()
      //     .then((QuerySnapshot querySnapshot) {
      //   querySnapshot.docs.forEach((doc) {
      //     print(doc.data());
      //   });
      // });

      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Container(
              height: 25,
              alignment: Alignment.center,
              child: Text(
                'กรุณากรอกแบบประเมินให้ครบ',
                style: TextStyle(fontSize: 20),
              )),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    var sameDate = ModalRoute.of(context).settings.arguments as bool;
    return Scaffold(
      appBar: AppBar(
        title: Text('แบบประเมิน'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Container(
        width: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            children: [
              ExpandableNotifier(
                controller:
                    ExpandableController(initialExpanded: _isOcularExpanded),
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
                                  color: _isOcularFinished
                                      ? Theme.of(context).primaryColor
                                      : Colors.black),
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
              //Nasal
              ExpandableNotifier(
                controller:
                    ExpandableController(initialExpanded: _isNasalExpanded),
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
                                  color: _isNasalFinished
                                      ? Theme.of(context).primaryColor
                                      : Colors.black),
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
                controller:
                    ExpandableController(initialExpanded: _isCocludeExpanded),
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
                              'โดยรวมแล้วอาการภูมิแพ้จมูกอักเสบวันนี้ รบกวนชีวิตประจำวันของท่านมากน้อยเพียงใด',
                              style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                  color: _isConcludeFinished
                                      ? Theme.of(context).primaryColor
                                      : Colors.black),
                            ),
                          ),
                          collapsed: Container(),
                          expanded: Container(
                            child: Column(
                              children: [
                                Slider(
                                  activeColor: Theme.of(context).primaryColor,
                                  value: _currentSliderValue,
                                  min: 0,
                                  max: 10,
                                  divisions: 10,
                                  label: _currentSliderValue.round().toString(),
                                  onChanged: (double value) {
                                    setState(() {
                                      _currentSliderValue = value;
                                      _isConcludeFinished = true;
                                      _isCocludeExpanded = true;
                                    });
                                  },
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
              ),
              SizedBox(
                height: 12,
              ),
              ElevatedButton(
                child: Padding(
                    padding: EdgeInsets.all(15),
                    child: sameDate
                        ? Text(
                            'แก้ไข',
                            style: TextStyle(
                              fontSize: 25,
                            ),
                          )
                        : Text(
                            'บันทึก',
                            style: TextStyle(
                              fontSize: 25,
                            ),
                          )),
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        Theme.of(context).primaryColor)),
                onPressed: sameDate
                    ? () => editAssessment()
                    : () async {
                        // FirebaseFirestore.instance.collection('assess').add({
                        //   'nasal': 4
                        // });
                        final currentPateint =
                            FirebaseAuth.instance.currentUser;
                        Map<String, int> _assestment = {};

                        // print(_isNasalFinished);
                        // print(_isOcularFinished);
                        // print(_isConcludeFinished);
                        if (_isOcularFinished &&
                            _isNasalFinished &&
                            _isConcludeFinished) {
                          // print(_ocular.getOcularLevel);
                          // print(_nasal.getNasalLevel);
                          // print(_currentSliderValue);
                          _assestment.addAll(_nasal.getNasalLevel);
                          _assestment.addAll(_ocular.getOcularLevel);
                          _assestment.addAll(
                              {'vas_score': _currentSliderValue.toInt()});
                          await FirebaseFirestore.instance
                              .collection('patients')
                              .doc(currentPateint.uid)
                              .collection('assessments')
                              .add({
                            'assessment': _assestment,
                            'created': Timestamp.now(),
                            'analysed': false,
                          });

                          // await FirebaseFirestore.instance
                          //     .collection('patients')
                          //     .doc(currentPateint.uid)
                          //     .collection('assessments')
                          //     .orderBy('created', descending: true)
                          //     .get()
                          //     .then((QuerySnapshot querySnapshot) {
                          //   querySnapshot.docs.forEach((doc) {
                          //     print(doc.data());
                          //   });
                          // });

                          Navigator.pop(context);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Container(
                                  height: 25,
                                  alignment: Alignment.center,
                                  child: Text(
                                    'กรุณากรอกแบบประเมินให้ครบ',
                                    style: TextStyle(fontSize: 20),
                                  )),
                              backgroundColor: Theme.of(context).errorColor,
                            ),
                          );
                        }
                      },
              )
            ],
          ),
        ),
      ),
    );
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
              onPressed: (int index) {
                for (int buttonIndex = 0;
                    buttonIndex < listValue.length;
                    buttonIndex++) {
                  if (buttonIndex == index) {
                    listValue[buttonIndex] = true;
                    _ocular.setOcular(title, index);
                  } else {
                    listValue[buttonIndex] = false;
                  }
                }

                if (_ocular.isFinished()) {
                  _isOcularFinished = true;
                  _isOcularExpanded = false;
                } else {
                  _isOcularExpanded = true;
                }

                setState(() {});
              },
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
              onPressed: (int index) {
                for (int buttonIndex = 0;
                    buttonIndex < listValue.length;
                    buttonIndex++) {
                  if (buttonIndex == index) {
                    listValue[buttonIndex] = true;
                    _nasal.setNasal(title, index);
                  } else {
                    listValue[buttonIndex] = false;
                  }
                }

                if (_nasal.isFinished()) {
                  _isNasalFinished = true;
                  _isNasalExpanded = false;
                } else {
                  _isNasalExpanded = true;
                }

                setState(() {});
              },
              isSelected: listValue,
            ),
          ),
        ],
      ),
    );
  }
}
