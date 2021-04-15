import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  var hasAssessments = false;
  int initNumAssessment = 0;
  int numOfAssessments = 0;
  double avgVasScore = 0;
  Map<String, dynamic> lastData;
  List<int> lastVasScores = [];

  @override
  void initState() {
    super.initState();
    checkStatusAndAssessment();
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
      hasAssessments = snapshot.data().containsKey('assessments');
      print(snapshot.data());
      if (snapshot['status'] == null) {
        initStatusPatient = null;
        presentStatusPatient = null;
        hasStatus = false;
      } else {
        initStatusPatient = snapshot['status'].toString();
        presentStatusPatient = initStatusPatient;
        hasStatus = true;
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
      print(initNumAssessment);
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
    if (numOfAssessments != null &&
        numOfAssessments >= 3 &&
        initNumAssessment != numOfAssessments) {
      initNumAssessment = numOfAssessments;
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
            print('nosalC: ${querySnapshot.docs.first['assessment']['congrestion_nasal']}');
        if (querySnapshot.docs.first.data()['assessment']['congrestion_nasal'] >
            0) {
              // print('nosalC: ${querySnapshot.docs.last.data()['assessment']['congrestion_nasal']}');
          hasCongrestionNasal = true;
          print('hasC: $hasCongrestionNasal');
        } else {
          hasCongrestionNasal = false;
          print('hasC: $hasCongrestionNasal');
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
  }

  String selectedImage(String presentStatusPatient) {
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
        stream: FirebaseFirestore.instance
            .collection('patients')
            .doc(currentPatient.uid)
            .collection('assessments')
            .snapshots(),
        builder: (ctx, snapshot) {
          return FutureBuilder(
              future: analyzeAssessments(),
              builder: (context, futureSnapshot) {
                if (futureSnapshot.connectionState == ConnectionState.waiting) {
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
                                        ? 'สถานะของผู้ป่วย $presentStatusPatient'
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
                        ],
                      ),
                    ),
                  ),
                );
              });
        });
  }
}
