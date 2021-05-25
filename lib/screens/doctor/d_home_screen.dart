import 'dart:ffi';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:tuallergycare/screens/doctor/d_patientprofile_screen.dart';
import 'package:tuallergycare/screens/doctor/d_qrcode.dart';
import 'package:tuallergycare/utility/style.dart';
//import 'package:qr_code_scanner/qr_code_scanner.dart';

class DoctorHomeScreen extends StatefulWidget {
  static const routeName = '/doctorhomescreen';
  @override
  State<StatefulWidget> createState() {
    return DoctorHomeScreenState();
  }
}

class DoctorHomeScreenState extends State<DoctorHomeScreen> {
  final currentUser = FirebaseAuth.instance.currentUser;
  String qrCode = 'Unknown';
  @override
  void initState() {
    super.initState();
  }
  // String qrCode = 'Unknown';
  @override
  Widget build(BuildContext context) {
    print('root');
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            'หน้าหลัก',
            textAlign: TextAlign.center,
          ),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.person_add_alt_rounded),
              tooltip: 'Scan QR Code',
              onPressed: (){
                Navigator.pushNamed(context, Scanner.routeName);
              },
            ),
            IconButton(
              onPressed: () async {
                Navigator.popUntil(
                    context, ModalRoute.withName(Navigator.defaultRouteName));
                await FirebaseAuth.instance.signOut();
                print('canpop ${Navigator.canPop(context)}');
              },
              icon: Icon(Icons.exit_to_app),
            )
          ],
          bottom: TabBar(
            //isScrollable: true,
            indicatorColor: Colors.white,
            indicatorWeight: 5,
            tabs: [
              Tab(text: 'รายชื่อผู้ป่วยที่นัดวันนี้'),
              Tab(text: 'รายชื่อผู้ป่วยทั้งหมด'),
            ],
          ),
          elevation: 10,
          titleSpacing: 10,
        ),
        body: TabBarView(
          children: [
            PatientToday(),
            PatientAll(),
          ],
        ),
      ),
    );

    //    Future<void> scanQRCode() async {
    //   try {
    //     final qrCode = await FlutterBarcodeScanner.scanBarcode(
    //       '#ff6666',
    //       'Cancel',
    //       true,
    //       ScanMode.QR,
    //     );

    //     if (!mounted) return;

    //     FirebaseFirestore.instance.collection('doctor').doc(currentUser.uid).update({'patient': qrCode});

    //     setState(() {
    //       this.qrCode = qrCode;
    //     });
    //   } on PlatformException {
    //     qrCode = 'Failed to get platform version.';
    //   }
    // }
  }
}

class Patient {
  String id;
  String username;
  String weight;
  String height;
  String phoneNumber;
  String gender;
  String birthday;
  String status;
  String image;
  String research;
  List skinTest;
  Map appointment;

  Patient(
    this.id,
    this.username,
    this.weight,
    this.height,
    this.phoneNumber,
    this.gender,
    this.birthday,
    this.status,
    this.image,
    this.research,
    this.skinTest,
    this.appointment,
  );
}

//รายชื่อผู้ป่วยที่นัดวันนี้
class PatientToday extends StatefulWidget {
  @override
  _PatientTodayState createState() => _PatientTodayState();
}

class _PatientTodayState extends State<PatientToday> {
  CalendarController _calendar;
  List<dynamic> _idPatients = [];
  List<Patient> _patients = [];
  final currentUser = FirebaseAuth.instance.currentUser;
  DateTime today = DateTime.now();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _calendar = CalendarController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _calendar.dispose();
    super.dispose();
  }

  void selectPatient(BuildContext context, String id) {
    Navigator.of(context)
        .pushNamed(PatientProfileScreen.routeName, arguments: id);
  }

  Future<void> getPatient() async {
    if (_patients.length != 0) {
      _patients.clear();
    }
    try {
      await FirebaseFirestore.instance
          .collection('doctors')
          .doc(currentUser.uid)
          .get()
          .then((doc) {
        _idPatients = doc.data()['patients'];
      });
      for (var i = 0; i < _idPatients.length; i++) {
        await FirebaseFirestore.instance
            .collection('patients')
            .doc(_idPatients.elementAt(i))
            .get()
            .then((doc) {
          //     recentDate = DateTime.fromMicrosecondsSinceEpoch(querySnapshot
          //     .docs.first
          //     .data()['create_at']
          //     .microsecondsSinceEpoch);
          // difDate.add(now.difference(recentDate).inDays);
          print('iiiii: ${_idPatients.elementAt(i)}');
          print('ddddddd: ${doc.data()['username']}');
          if (doc.data()['appointment'] != null) {
            var date = DateTime.fromMicrosecondsSinceEpoch(
                doc.data()['appointment']['day'].microsecondsSinceEpoch);
            var difdate = today.difference(date).inDays;
            print('today ${today.day}');
            print('date ${date.day}');
            print(difdate);
            if (today.day == date.day) {
              print('inPaTodat');
              _patients.add(new Patient(
                doc.id,
                doc.data()['username'],
                doc.data()['weight'],
                doc.data()['height'],
                doc.data()['phone_number'],
                doc.data()['gender'],
                doc.data()['birth_day'],
                doc.data()['status'],
                doc.data()['image'],
                doc.data()['research'],
                doc.data()['skintest'],
                doc.data()['appointment'],
              ));
            }
          }
        });
      }
      print('idPatients: ${_idPatients.length}');
      print('idPatients: $_idPatients');
      print('patients: ${_patients.length}');
    } catch (e) {
      print('getPatiError');
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Object>(
        stream: FirebaseFirestore.instance.collection('patients').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
          if (snapshot.connectionState == ConnectionState.active) {
            return FutureBuilder(
                future: getPatient(),
                builder: (context, snapshot) {
                  return Scaffold(
                    body: ListView(
                      children: <Widget>[
                        //ปฏิทิน
                        TableCalendar(
                          calendarController: _calendar,
                          initialCalendarFormat: CalendarFormat.week,
                          startingDayOfWeek: StartingDayOfWeek.sunday,
                          formatAnimation: FormatAnimation.slide,
                          headerStyle: HeaderStyle(
                            centerHeaderTitle: true,
                            formatButtonVisible: false,
                            titleTextStyle: TextStyle(
                                color: Style().darkColor, fontSize: 16),
                            leftChevronIcon: Icon(
                              Icons.arrow_back_ios,
                              color: Style().darkColor,
                              size: 15,
                            ),
                            rightChevronIcon: Icon(
                              Icons.arrow_forward_ios,
                              color: Style().darkColor,
                              size: 15,
                            ),
                            leftChevronMargin: EdgeInsets.only(left: 70),
                            rightChevronMargin: EdgeInsets.only(right: 70),
                          ),
                          calendarStyle: CalendarStyle(
                              weekendStyle: TextStyle(color: Colors.black),
                              weekdayStyle: TextStyle(color: Colors.black)),
                          daysOfWeekStyle: DaysOfWeekStyle(
                              weekendStyle: TextStyle(color: Style().darkColor),
                              weekdayStyle:
                                  TextStyle(color: Style().darkColor)),
                        ),
                        //ผู้ป่วย
                        Container(
                          padding: EdgeInsets.only(right: 15.0),
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height - 100,
                          child: GridView.builder(
                            gridDelegate:
                                SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent: 400,
                              childAspectRatio: 1,
                              crossAxisSpacing: 5,
                              mainAxisSpacing: 5,
                            ),
                            itemBuilder: (ctx, index) {
                              print("build all");
                              try {
                                return _buildCard(
                                  _patients.elementAt(index).id,
                                  _patients.elementAt(index).username,
                                  _patients.elementAt(index).gender,
                                  _patients
                                      .elementAt(index)
                                      .appointment['time'],
                                  _patients.elementAt(index).status,
                                  _patients.elementAt(index).image,
                                );
                              } catch (e) {
                                print('build Patient All');
                                print(e);
                              }
                            },
                            itemCount: _patients.length,
                          ),
                        ),
                      ],
                    ),
                  );
                });
          }
        });
  }

  Widget _buildCard(String id, String name, String gender, String time,
      String status, String img) {
    var statusIcon;
    if (status == 'T0') {
      statusIcon = 'assets/images/status_green.png';
    } else if (status == 'T1') {
      statusIcon = 'assets/images/status_yellow.png';
    } else if (status == 'T2') {
      statusIcon = 'assets/images/status_orange.png';
    } else {
      statusIcon = 'assets/images/status_red.png';
    }
    return Padding(
      padding: EdgeInsets.only(top: 5.0, bottom: 5.0, left: 15.0, right: 5.0),
      child: InkWell(
        // onTap: () {},
        onTap: () => selectPatient(context, id),
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.0),
              boxShadow: [
                BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 3.0,
                    blurRadius: 5.0)
              ],
              color: Colors.white),
          child: Column(
            children: [
              Center(
                child: Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: Hero(
                    tag: img != null
                        ? img
                        : gender == 'ชาย'
                            ? 'assets/images/male.png'
                            : 'assets/images/female.png',
                    child: Stack(children: [
                      Container(
                        height: 75,
                        width: 75,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(60)),
                          image: DecorationImage(
                            image: img != null
                                ? AssetImage(img)
                                : gender == 'ชาย'
                                    ? AssetImage('assets/images/male.png')
                                    : AssetImage('assets/images/female.png'),
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            height: 25,
                            width: 25,
                            decoration: status != null
                                ? BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                        image: AssetImage(
                                          statusIcon,
                                        ),
                                        fit: BoxFit.contain
                                        // fit: BoxFit.contain
                                        ),
                                  )
                                : null,
                            // decoration: BoxDecoration(
                            //   //shape: BoxShape.circle,
                            //   border: Border.all(
                            //     width: 4,
                            //     color: Theme.of(context).scaffoldBackgroundColor,
                            //   ),
                            // ),
                            // child: Icon(
                            //   Icons.circle,
                            //   size: 30,
                            //   color: Colors.green,
                            // ),
                            //
                          )),
                    ]),
                  ),
                ),
              ),
              SizedBox(
                height: 7.0,
              ),
              Padding(
                padding: EdgeInsets.only(left: 5.0),
                child: Container(
                  child: Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.person, color: Colors.grey),
                      Padding(
                        padding: EdgeInsets.only(left: 5.0),
                        child: Text(name,
                            style:
                                TextStyle(color: Colors.black, fontSize: 14.0)),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 5.0),
                child: Container(
                  child: Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.timer, color: Colors.grey),
                      Padding(
                        padding: EdgeInsets.only(left: 5.0),
                        child: Text(time,
                            style:
                                TextStyle(color: Colors.black, fontSize: 14.0)),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  selectStimulus(context) {}
}

//รายชื่อผู้ป่วยทั้งหมด
class PatientAll extends StatefulWidget {
  @override
  _PatientAllState createState() => _PatientAllState();
}

class _PatientAllState extends State<PatientAll> {
  CalendarController _calendar;
  List<dynamic> _idPatients = [];
  List<Patient> _patientsAll = [];
  final currentPatient = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _calendar = CalendarController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _calendar.dispose();
    super.dispose();
  }

  Future<void> getPatientAll() async {
    try {
      await FirebaseFirestore.instance
          .collection('doctors')
          .doc(currentPatient.uid)
          .get()
          .then((doc) {
        _idPatients = doc.data()['patients'];
      });

      // _idPatients.forEach((element) {
      //   print(element);
      // });

      for (var i = 0; i < _idPatients.length; i++) {
        await FirebaseFirestore.instance
            .collection('patients')
            .doc(_idPatients.elementAt(i))
            .get()
            .then((doc) {
          _patientsAll.add(new Patient(
            doc.id,
            doc.data()['username'],
            doc.data()['weight'],
            doc.data()['height'],
            doc.data()['phone_number'],
            doc.data()['gender'],
            doc.data()['birth_day'],
            doc.data()['status'],
            doc.data()['image'],
            doc.data()['research'],
            doc.data()['skintest'],
            doc.data()['appointment'],
          ));
        });
      }

      print('idPatients: $_idPatients');
      // print('pateints: ${_patientsAll.first.username}');
    } catch (e) {
      print('getPatiError');
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getPatientAll(),
        builder: (context, snapshot) {
          return Scaffold(
            body: ListView(
              children: <Widget>[
                //ปฏิทิน
                TableCalendar(
                  calendarController: _calendar,
                  initialCalendarFormat: CalendarFormat.week,
                  startingDayOfWeek: StartingDayOfWeek.sunday,
                  formatAnimation: FormatAnimation.slide,
                  headerStyle: HeaderStyle(
                    centerHeaderTitle: true,
                    formatButtonVisible: false,
                    titleTextStyle:
                        TextStyle(color: Style().darkColor, fontSize: 16),
                    leftChevronIcon: Icon(
                      Icons.arrow_back_ios,
                      color: Style().darkColor,
                      size: 15,
                    ),
                    rightChevronIcon: Icon(
                      Icons.arrow_forward_ios,
                      color: Style().darkColor,
                      size: 15,
                    ),
                    leftChevronMargin: EdgeInsets.only(left: 70),
                    rightChevronMargin: EdgeInsets.only(right: 70),
                  ),
                  calendarStyle: CalendarStyle(
                      weekendStyle: TextStyle(color: Colors.black),
                      weekdayStyle: TextStyle(color: Colors.black)),
                  daysOfWeekStyle: DaysOfWeekStyle(
                      weekendStyle: TextStyle(color: Style().darkColor),
                      weekdayStyle: TextStyle(color: Style().darkColor)),
                ),
                //ผู้ป่วย
                Container(
                  padding: EdgeInsets.only(right: 15.0),
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height - 100,
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 400,
                      childAspectRatio: 1,
                      crossAxisSpacing: 5,
                      mainAxisSpacing: 5,
                    ),
                    itemBuilder: (ctx, index) {
                      print("build all");
                      try {
                        return _buildCardAll(
                          _patientsAll.elementAt(index).id,
                          _patientsAll.elementAt(index).username,
                          _patientsAll.elementAt(index).gender,
                          _patientsAll.elementAt(index).status,
                          _patientsAll.elementAt(index).image,
                        );
                      } catch (e) {
                        print('build Patient All');
                        print(e);
                      }
                    },
                    itemCount: _patientsAll.length,
                  ),
                ),
              ],
            ),
          );
        });
  }

  void selectPatient(BuildContext context, String id) {
    Navigator.of(context)
        .pushNamed(PatientProfileScreen.routeName, arguments: id);
  }

  Widget _buildCardAll(String id, String name, String gender, String status, String img) {
    var statusIcon;
    if (status == 'T0') {
      statusIcon = 'assets/images/status_green.png';
    } else if (status == 'T1') {
      statusIcon = 'assets/images/status_yellow.png';
    } else if (status == 'T2') {
      statusIcon = 'assets/images/status_orange.png';
    } else {
      statusIcon = 'assets/images/status_red.png';
    }
    return Padding(
      padding: EdgeInsets.only(top: 5.0, bottom: 5.0, left: 15.0, right: 5.0),
      child: InkWell(
        onTap: () => selectPatient(context, id),
        child: Container(
          // constraints: BoxConstraints(minHeight: 800),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.0),
              boxShadow: [
                BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 3.0,
                    blurRadius: 5.0)
              ],
              color: Colors.white),
          child: Column(
            children: [
              Center(
                child: Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: Hero(
                    tag: img != null
                        ? img
                        : gender == 'ชาย'
                            ? 'assets/images/male.png'
                            : 'assets/images/female.png',
                    child: Stack(children: [
                      Container(
                        height: 75,
                        width: 75,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(60)),
                          image: DecorationImage(
                            image: img != null
                                ? AssetImage(img)
                                : gender == 'ชาย'
                                    ? AssetImage('assets/images/male.png')
                                    : AssetImage('assets/images/female.png'),
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            height: 25,
                            width: 25,
                            decoration: status != null
                                ? BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                        image: AssetImage(
                                          statusIcon,
                                        ),
                                        fit: BoxFit.contain
                                        // fit: BoxFit.contain
                                        ),
                                  )
                                : null,
                            // decoration: BoxDecoration(
                            //   //shape: BoxShape.circle,
                            //   border: Border.all(
                            //     width: 4,
                            //     color: Theme.of(context).scaffoldBackgroundColor,
                            //   ),
                            // ),
                            // child: Icon(
                            //   Icons.circle,
                            //   size: 30,
                            //   color: Colors.green,
                            // ),
                            //
                          )),
                    ]),
                  ),
                ),
              ),
              SizedBox(
                height: 7.0,
              ),
              Padding(
                padding: EdgeInsets.only(left: 5.0),
                child: Container(
                  child: Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.person, color: Colors.grey),
                      Padding(
                        padding: EdgeInsets.only(left: 5.0),
                        child: Text(name,
                            style:
                                TextStyle(color: Colors.black, fontSize: 14.0)),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 5.0),
                child: Container(
                  child: Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Icon(Icons.timer, color: Colors.grey),
                      // Padding(
                      //   padding: EdgeInsets.only(left: 5.0),
                      //   child: Text(time,
                      //       style:
                      //           TextStyle(color: Colors.black, fontSize: 14.0)),
                      // ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
