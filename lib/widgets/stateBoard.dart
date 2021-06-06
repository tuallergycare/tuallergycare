import 'dart:async';

import 'package:async/async.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

// enum StatusPatient {
//   noStatus,
//   t0,
//   t1,
//   t2,
//   t3,
// }

// String showSuggestion(StatusPatient status) {
//   if (status == StatusPatient.noStatus) {
//     return 'ผู้ป่วยควรใช้ยาอย่างต่อเนื่อง';
//   }
//   if (status == StatusPatient.t1) {
//     return 'ผู้ป่วยควรใช้ยาอย่างต่อเนื่อง';
//   }
//   if (status == StatusPatient.t2) {
//     return 'ผู้ป่วยควรใช้ยาอย่างต่อเนื่อง';
//   }
//   if (status == StatusPatient.t3) {
//     return 'ผู้ป่วยควรพบแพทย์';
//   }
// }

class StateBoard extends StatefulWidget {
  @override
  _StateBoardState createState() => _StateBoardState();
}

class _StateBoardState extends State<StateBoard> {
  final currentPatient = FirebaseAuth.instance.currentUser;
  var initStatusPatient;
  var presentStatusPatient;
  var hasStatus = false;
  var hasCongrestionNasal = false;
  var hasNewAssessment = false;
  var editStatus = false;
  int initNumAssessment = 0;
  int numOfAssessments = 0;
  double avgVasScore = 0;
  Map<String, dynamic> lastData;
  List<int> lastVasScores = [];
  var hasAnalysed;
  var idRecentAssessment;

  @override
  void initState() {
    checkStatusAndAssessment();
    super.initState();
  }

  Future<void> checkStatusAndAssessment() async {
    // final currentPateint = FirebaseAuth.instance.currentUser;
    // await FirebaseFirestore.instance
    //     .collection('patients')
    //     .doc(currentPatient.uid)
    //     .collection('assessments')
    //     .get()
    //     .then((QuerySnapshot querySnapshot) {
    //   print(querySnapshot.size);
    // });

    await FirebaseFirestore.instance
        .collection('patients')
        .doc(currentPatient.uid)
        .get()
        .then((DocumentSnapshot snapshot) {
      if (snapshot['status'] == null) {
        initStatusPatient = null;
        presentStatusPatient = null;
        hasStatus = false;
        // print('hs');
      } else {
        initStatusPatient = snapshot['status'].toString();
        presentStatusPatient = initStatusPatient;
        hasStatus = true;
        // print('dh');
      }
      // print(initStatusPatient);
    });

    await FirebaseFirestore.instance
        .collection('patients')
        .doc(currentPatient.uid)
        .collection('assessments')
        .get()
        .then((QuerySnapshot querySnapshot) {
      initNumAssessment = querySnapshot.size;
      // print('farInit: $initNumAssessment');
    });
  }

  Future<void> analyzeAssessments() async {
    await FirebaseFirestore.instance
        .collection('patients')
        .doc(currentPatient.uid)
        .collection('assessments')
        .get()
        .then((QuerySnapshot querySnapshot) {
      numOfAssessments = querySnapshot.size;
    });
    print('init: $initNumAssessment');
    print('numOf: $numOfAssessments');
    // print('initIN: $initNumAssessment');
    //   print('numOfIN: $numOfAssessments');

    await await FirebaseFirestore.instance
        .collection('patients')
        .doc(currentPatient.uid)
        .collection('assessments')
        .orderBy('created', descending: true)
        .limit(1)
        .get()
        .then((QuerySnapshot querySnapshot) {
      idRecentAssessment = querySnapshot.docs.first.id;
      hasAnalysed = querySnapshot.docs.first.data()['analysed'];
    });

    try {
      if (numOfAssessments != null &&
          numOfAssessments >= 3 &&
          // initNumAssessment != numOfAssessments &&
          hasAnalysed == false &&
          initNumAssessment != 0) {
        // print('initIN: $initNumAssessment');
        // print('numOfIN: $numOfAssessments');
        initNumAssessment = numOfAssessments;

        await FirebaseFirestore.instance
            .collection('patients')
            .doc(currentPatient.uid)
            .collection('assessments')
            .doc(idRecentAssessment)
            .update({
          'analysed': true,
        });

        await FirebaseFirestore.instance
            .collection('patients')
            .doc(currentPatient.uid)
            .collection('assessments')
            .orderBy('created', descending: true)
            .limit(3)
            .get()
            .then((QuerySnapshot querySnapshot) {
          // print('nosalC: ${querySnapshot.docs.last.data()['assessment']['congrestion_nasal']}');
          print('status: $presentStatusPatient');
          print(
              'nosalC: ${querySnapshot.docs.first['assessment']['congrestion_nasal']}');
          if (querySnapshot.docs.first.data()['assessment']
                  ['congrestion_nasal'] >
              0) {
            // print('nosalC: ${querySnapshot.docs.last.data()['assessment']['congrestion_nasal']}');
            hasCongrestionNasal = true;
            // print('hasC: $hasCongrestionNasal');
          } else {
            hasCongrestionNasal = false;
            // print('hasC: $hasCongrestionNasal');
          }

          if (lastVasScores.isNotEmpty) {
            lastVasScores.clear();
          }

          querySnapshot.docs
              .forEach((QueryDocumentSnapshot queryDocumentSnapshot) {
            lastVasScores
                .add(queryDocumentSnapshot.data()['assessment']['vas_score']);
          });
          avgVasScore =
              (lastVasScores[0] + lastVasScores[1] + lastVasScores[2]) / 3;
          print(lastVasScores);
          print(avgVasScore);

          defindStatus(hasCongrestionNasal, avgVasScore);
        });

        // if(presentStatusPatient == 'T0'){
        //   await FirebaseFirestore.instance
        //     .collection('patients')
        //     .doc(currentPatient.uid)
        //     .update({'status': presentStatusPatient, 'research': 'อาการน้อย'});
        // } else if(presentStatusPatient == 'T1'){
        //   await FirebaseFirestore.instance
        //     .collection('patients')
        //     .doc(currentPatient.uid)
        //     .update({'status': presentStatusPatient, 'research': 'อาการปานกลาง'});
        // } else if(presentStatusPatient == 'T2'){
        //   await FirebaseFirestore.instance
        //     .collection('patients')
        //     .doc(currentPatient.uid)
        //     .update({'status': presentStatusPatient, 'research': 'อาการค่อนข้างรุนแรง'});
        // } else if(presentStatusPatient == 'T3'){
        //   await FirebaseFirestore.instance
        //     .collection('patients')
        //     .doc(currentPatient.uid)
        //     .update({'status': presentStatusPatient, 'research': 'อาการรุนแรงที่สุด'});
        // }

        await FirebaseFirestore.instance
            .collection('patients')
            .doc(currentPatient.uid)
            .update({'status': presentStatusPatient});


      }
    } catch (e) {
      print('Error Assess Call');
      print(e);
    }
  }

  void defindStatus(bool hasCongrestionNasal, double avgVasScore) {
    if (hasCongrestionNasal == true) {
      switch (presentStatusPatient) {
        case 'T0':
          presentStatusPatient = 'T1';
          break;
        case 'T1':
          presentStatusPatient = 'T2';
          break;
        case 'T2':
          presentStatusPatient = 'T3';
          break;
      }
    } else if (avgVasScore < 5) {
      switch (presentStatusPatient) {
        case 'T1':
          presentStatusPatient = 'T0';
          break;
        case 'T2':
          presentStatusPatient = 'T1';
          break;
        case 'T3':
          presentStatusPatient = 'T3';
          break;
      }
    } else if (avgVasScore >= 5) {
      switch (presentStatusPatient) {
        case 'T0':
          presentStatusPatient = 'T1';
          break;
        case 'T1':
          presentStatusPatient = 'T2';
          break;
        case 'T2':
          presentStatusPatient = 'T3';
          break;
      }
    }
    print('defindState: $presentStatusPatient');
  }

  String selectedImage(String presentStatusPatient) {
    print('stateImg: $presentStatusPatient');
    switch (presentStatusPatient) {
      case 'T0':
        return 'assets/images/smile.png';
        break;
      case 'T1':
        return 'assets/images/sad.png';
        break;
      case 'T2':
        return 'assets/images/cry.png';
        break;
      case 'T3':
        return 'assets/images/scary.png';
        break;
      default:
        return 'assets/images/smile.png';
        break;
    }
  }

  String definitionOfStatusPatient(String presentStatusPatient) {
    switch (presentStatusPatient) {
      case 'T0':
        return 'มีอาการน้อย';
        break;
      case 'T1':
        return 'มีอาการปานกลาง';
        break;
      case 'T2':
        return 'มีอาการค่อนข้างรุนแรง';
        break;
      case 'T3':
        return 'มีอาการรุนแรง';
        break;
      default:
        return 'กรุณาพบแพทย์เผื่อระบุสถานะ';
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Object>(
        stream: StreamGroup.merge([
          FirebaseFirestore.instance
              .collection('patients')
              .doc(currentPatient.uid)
              .collection('assessments')
              .snapshots(),
          FirebaseFirestore.instance
              .collection('patients')
              .doc(currentPatient.uid)
              .snapshots(includeMetadataChanges: true)
        ]),
        // stream:FirebaseFirestore.instance
        //         .collection('patients')
        //         .doc(currentPatient.uid)
        //         .collection('assessments')
        //         .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.connectionState == ConnectionState.active) {
            print('build af asses');
            return FutureBuilder(
                future: analyzeAssessments(),
                builder: (context, futureSnapshot) {
                  if (futureSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return Container(
                    height: 170,
                    color: Theme.of(context).primaryColor,
                    padding: EdgeInsets.only(top: 50),
                    child: Container(
                      child: Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Container(
                                margin: EdgeInsets.fromLTRB(25, 0, 0, 10),
                                height: 100,
                                // padding: EdgeInsets.all(15),
                                child: hasStatus
                                    ? Image.asset(
                                        selectedImage(presentStatusPatient),
                                        fit: BoxFit.cover)
                                    : SizedBox(
                                        width: 40,
                                      )),
                            Container(
                              margin: EdgeInsets.fromLTRB(30, 0, 0, 0),
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    child: Text(
                                      hasStatus
                                          ? 'สถานะของผู้ป่วย'
                                          : 'ยังไม่มีสถานะผู้ป่วย',
                                      style: TextStyle(
                                        // fontWeight: FontWeight.bold,
                                        fontSize: 28,
                                        color: Theme.of(context).accentColor,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 4,
                                  ),
                                  Container(
                                    child: Text(
                                      definitionOfStatusPatient(
                                          presentStatusPatient),
                                      style: TextStyle(
                                        // fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                        color: Theme.of(context).accentColor,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              onPressed: () async {
                                Navigator.popUntil(
                                    context,
                                    ModalRoute.withName(
                                        Navigator.defaultRouteName));
                                await FirebaseAuth.instance.signOut();
                                print('canpop ${Navigator.canPop(context)}');
                              },
                              icon: Icon(
                                Icons.exit_to_app,
                                color: Colors.white,
                              ),
                            ),
                            // TextButton(
                            //     onPressed: () async {
                            //       Navigator.popUntil(
                            //           context,
                            //           ModalRoute.withName(
                            //               Navigator.defaultRouteName));
                            //       await FirebaseAuth.instance.signOut();
                            //       print('canpop ${Navigator.canPop(context)}');
                            //     },
                            //     child: Text('ออกจากระบบ'))
                          ],
                        ),
                      ),
                    ),
                  );
                });
          }
        });
  }
}
