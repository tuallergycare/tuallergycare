import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tuallergycare/screens/assess_screen.dart';
import 'package:tuallergycare/screens/information_screen/medicine/medicine_info_screen.dart';
import 'package:tuallergycare/screens/medicine_screen.dart';
import 'package:tuallergycare/widgets/button_home.dart';
import 'package:tuallergycare/widgets/stateBoard.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final currentPatient = FirebaseAuth.instance.currentUser;
    final DateTime today = DateTime.now();
    String day;
    String month;
    String year;
    double screen = MediaQuery.of(context).size.width;
    int difDate = 0;
    var sameDate = false;

    Future<void> checkDateAssestment() async {
      DateTime recentDate;

      await FirebaseFirestore.instance
          .collection('patients')
          .doc(currentPatient.uid)
          .collection('assessments')
          .orderBy('created', descending: true)
          .limit(1)
          .get()
          .then((QuerySnapshot querySnapshot) {
        recentDate = DateTime.fromMicrosecondsSinceEpoch(
            querySnapshot.docs.first.data()['created'].microsecondsSinceEpoch);
        difDate = today.difference(recentDate).inDays;
        if (difDate == 0) {
          sameDate = true;
        } else {
          sameDate = false;
        }
      });
    }

    switch (today.weekday) {
      case 1:
        day = 'วันจันทร์';
        break;
      case 2:
        day = 'วันอังคาร';
        break;
      case 3:
        day = 'วันพุธ';
        break;
      case 4:
        day = 'วันพฤหัสบดี';
        break;
      case 5:
        day = 'วันศุกร์';
        break;
      case 6:
        day = 'วันเสาร์';
        break;
      case 7:
        day = 'วันอาทิตย์';
        break;
      default:
    }

    switch (today.month) {
      case 1:
        month = 'มกราคม';
        break;
      case 2:
        month = 'กุมภาพันธ์';
        break;
      case 3:
        month = 'มีนาคม';
        break;
      case 4:
        month = 'เมษายน';
        break;
      case 5:
        month = 'พฤษภาคม';
        break;
      case 6:
        month = 'มิถุนายน';
        break;
      case 7:
        month = 'กรกฎาคม';
        break;
      case 8:
        month = 'สิงหาคม';
        break;
      case 9:
        month = 'กันยายน';
        break;
      case 10:
        month = 'ตุลาคม';
        break;
      case 11:
        month = 'พฤศจิกายน';
        break;
      case 12:
        month = 'ธันวาคม';
        break;
      default:
    }

    year = (today.year + 543).toString();

    return StreamBuilder<Object>(
        stream: FirebaseFirestore.instance
            .collection('patients')
            .doc(currentPatient.uid)
            .collection('assessments')
            .snapshots(),
        builder: (context, snapshot) {
          return FutureBuilder(
              future: checkDateAssestment(),
              builder: (context, snapshot) {
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        child: StateBoard(),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.all(15),
                        child: Text(
                          '${day}ที่ ${today.day} ${month} ${year}',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 30),
                        child: ButtonHome(
                          message: "ยากินวันนี้",
                          height: screen * 0.25,
                          width: screen * 0.95,
                          color: Colors.blue,
                          icon: Icons.book,
                          iconSize: 60.0,
                          //radius: 46.0,
                          onClick: () {
                            Navigator.pushNamed(
                                context, MedicineScreen.routeName);
                          },
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 30),
                        child: ButtonHome(
                          message: "ประเมินอาการ",
                          height: screen * 0.25,
                          width: screen * 0.95,
                          color: sameDate ? Colors.yellow[800] : Colors.pink,
                          icon: Icons.text_snippet_rounded,
                          iconSize: 60.0,
                          //radius: 46.0,
                          onClick: () {
                            Navigator.of(context).pushNamed(
                                AssessScreen.routeName,
                                arguments: sameDate);
                          },
                        ),
                      ),
                      TextButton(
                          onPressed: () async {
                            Navigator.popUntil(
                                context,
                                ModalRoute.withName(
                                    Navigator.defaultRouteName));
                            await FirebaseAuth.instance.signOut();
                            print('canpop ${Navigator.canPop(context)}');
                          },
                          child: Text('ออกจากระบบ'))
                    ],
                  ),
                );
              });
        });
  }
}
