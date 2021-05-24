import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class InhalersMedicine {
  String nameMedicine;
  String typeOfMedicine;
  String numOfPress;
  String image;
  bool hasMorningDose = false;
  bool hasEveningDose = false;
  Map<String, dynamic> timeToTake;

  InhalersMedicine(
    this.nameMedicine,
    this.typeOfMedicine,
    this.image,
    this.numOfPress,
    this.timeToTake,
    this.hasMorningDose,
    this.hasEveningDose,
  );

  void setHasMorningDose(bool value) {
    hasMorningDose = value;
  }

  void setHasEveningDose(bool value) {
    hasMorningDose = value;
  }

  String nameInMed() {
    return numOfPress;
  }
}

class TabletMedicine {
  String nameMedicine;
  String typeOfMedicine;
  String dose;
  String takePerTime;
  String takePerDay;
  String image;
  bool hasMorningDose = false;
  bool hasEveningDose = false;
  bool hasBeforeBedDose = false;
  Map<String, dynamic> timeToTake;

  TabletMedicine(
    this.nameMedicine,
    this.typeOfMedicine,
    this.image,
    this.dose,
    this.takePerTime,
    this.takePerDay,
    this.timeToTake,
    this.hasMorningDose,
    this.hasEveningDose,
    this.hasBeforeBedDose,
  );

  void setHasMorningDose(bool value) {
    hasMorningDose = value;
  }

  void setHasEveningDose(bool value) {
    hasMorningDose = value;
  }

  void setHasBeforeBedDoes(bool value) {
    hasBeforeBedDose = value;
  }
}

class MedicineScreen extends StatefulWidget {
  static final routeName = '/medicine';
  @override
  _MedicineScreenState createState() => _MedicineScreenState();
}

class _MedicineScreenState extends State<MedicineScreen> {
  final currentPatient = FirebaseAuth.instance.currentUser;
  List<TabletMedicine> tabMed = [];
  List<InhalersMedicine> inMed = [];
  int numOfMedicine = 0;
  List<dynamic> med;
  List morningMed = [];
  List eveningMed = [];
  List beforeBedMed = [];
  Map<String, String> idMedicine = {};
  var now = DateTime.now();
  bool hasLoadData = false;
  bool hasLoadInformation = false;
  var idCheck;

  Future<void> loadDataMedicine() async {
    if (inMed.length > 0 || tabMed.length > 0) {
      inMed.clear();
      tabMed.clear();
      morningMed.clear();
      eveningMed.clear();
      beforeBedMed.clear();
    }
    // if (hasLoadData == false) {
    try {
      final queryMedicine = await FirebaseFirestore.instance
          .collection('patients')
          .doc(currentPatient.uid)
          .collection('medicines')
          .get()
          .then((QuerySnapshot querySnapshot) async {
        numOfMedicine = querySnapshot.size;
        print(querySnapshot.docs.first.data());

        querySnapshot.docs.forEach((doc) async {
          var typeMed = doc.data()['type_medicine'];
          idMedicine.addAll({doc.data()['name_medicine']: doc.id});

          // FirebaseFirestore.instance
          //     .collection('patients')
          //     .doc(currentPatient.uid)
          //     .collection('medicines')
          //     .doc(doc.data()['name_medicine'])
          //     .collection('medicine_time')
          //     .get()
          //     .then((QuerySnapshot querySnapshot) {
          //   idCheck = querySnapshot.docs.first.id;
          // });

          if (typeMed == 'inhalers') {
            inMed.add(new InhalersMedicine(
              doc.data()['name_medicine'],
              doc.data()['type_medicine'],
              doc.data()['image'],
              doc.data()['num_of_press'],
              doc.data()['time_to_take'],
              doc.data()['check_current_take']['check_take_morning'],
              doc.data()['check_current_take']['check_take_evening'],
            ));
          } else {
            tabMed.add(new TabletMedicine(
              doc.data()['name_medicine'],
              doc.data()['type_medicine'],
              doc.data()['image'],
              doc.data()['dose'],
              doc.data()['take_per_time'],
              doc.data()['take_per_day'],
              doc.data()['time_to_take'],
              doc.data()['check_current_take']['check_take_morning'],
              doc.data()['check_current_take']['check_take_evening'],
              doc.data()['check_current_take']['check_take_before_bed'],
            ));
          }
        });
        await checkDateMidicineForm();
      });

      // tabMed.forEach((tabMed) async {
      //   await FirebaseFirestore.instance
      //       .collection('patients')
      //       .doc(currentPatient.uid)
      //       .collection('medicines')
      //       .doc(idMedicine[tabMed.nameMedicine])
      //       .collection('medicine_time')
      //       .get()
      //       .then((QuerySnapshot querySnapshot) {
      //     idCheck = querySnapshot.docs.first.id;
      //   });

      //   await FirebaseFirestore.instance
      //       .collection('patients')
      //       .doc(currentPatient.uid)
      //       .collection('medicines')
      //       .doc(idMedicine[tabMed.nameMedicine])
      //       .collection('medicine_time')
      //       .doc(idCheck)
      //       .get()
      //       .then((DocumentSnapshot documentSnapshot) {
      //     tabMed.setHasMorningDose(documentSnapshot.data()['morning_dose']);
      //     tabMed.setHasEveningDose(documentSnapshot.data()['evening_dose']);
      //     tabMed
      //         .setHasBeforeBedDoes(documentSnapshot.data()['before_bed_dose']);
      //   });
      // });
    } catch (e) {
      print(e.toString());
    }
    // }
  }

  Future<void> checkDateMidicineForm() async {
    var now = DateTime.now();
    DateTime recentDate;
    List<int> difDate = [];

    // final birthday = DateTime(2021, 5, 7);
    // final date2 = DateTime.now();
    // final difference = date2.difference(birthday).inDays;
    // print('diffDay: $difference');
    print('Start Checking');
    try {
      for (var i = 0; i < idMedicine.length; i++) {
        var checkCreatedCheckForm = true;

        await FirebaseFirestore.instance
            .collection('patients')
            .doc(currentPatient.uid)
            .collection('medicines')
            .doc(idMedicine.values.elementAt(i))
            .collection('medicine_time')
            .get()
            .then((QuerySnapshot querySnapshot) {
          if (querySnapshot.size == 0) {
            checkCreatedCheckForm = false;
          }
        });

        if (checkCreatedCheckForm == false) {
          await FirebaseFirestore.instance
              .collection('patients')
              .doc(currentPatient.uid)
              .collection('medicines')
              .doc(idMedicine.values.elementAt(i))
              .collection('medicine_time')
              .add({
            'morning_dose': false,
            'evening_dose': false,
            'before_bed_dose': false,
            'create_at': Timestamp.now(),
          });
          checkCreatedCheckForm = true;
        }
      }

      for (var i = 0; i < idMedicine.length; i++) {
        await FirebaseFirestore.instance
            .collection('patients')
            .doc(currentPatient.uid)
            .collection('medicines')
            .doc(idMedicine.values.elementAt(i))
            .collection('medicine_time')
            .orderBy('create_at', descending: true)
            .limit(1)
            .get()
            .then((QuerySnapshot querySnapshot) {
          recentDate = DateTime.fromMicrosecondsSinceEpoch(querySnapshot
              .docs.first
              .data()['create_at']
              .microsecondsSinceEpoch);
          difDate.add(now.difference(recentDate).inDays);
        });
      }
    } catch (e) {
      print('erroe1');
    }

    print(difDate);

    try {
      for (var i = 0; i < difDate.length; i++) {
        if (difDate.elementAt(i) > 0) {
          await FirebaseFirestore.instance
              .collection('patients')
              .doc(currentPatient.uid)
              .collection('medicines')
              .doc(idMedicine.values.elementAt(i))
              .collection('medicine_time')
              .add({
            'morning_dose': false,
            'evening_dose': false,
            'before_bed_dose': false,
            'create_at': Timestamp.now(),
          });

          await FirebaseFirestore.instance
              .collection('patients')
              .doc(currentPatient.uid)
              .collection('medicines')
              .doc(idMedicine.values.elementAt(i))
              .update({
            'check_current_take': {
              'check_take_morning': false,
              'check_take_evening': false,
              'check_take_before_bed': false,
            }
          });
        }
      }
    } catch (e) {
      print('error2');
      print(e);
    }
  }

  // Future<void> inMedInitChecked() async {
  //   inMed.forEach((med) {
  //     FirebaseFirestore.instance
  //         .collection('patients')
  //         .doc(currentPatient.uid)
  //         .collection('medicines')
  //         .doc(idMedicine[med.nameMedicine])
  //         .collection('medicine_time')
  //         .get()
  //         .then((QuerySnapshot querySnapshot) {
  //       idCheck = querySnapshot.docs.first.id;
  //     });

  //     FirebaseFirestore.instance
  //         .collection('patients')
  //         .doc(currentPatient.uid)
  //         .collection('medicines')
  //         .doc(idMedicine[med.nameMedicine])
  //         .collection('medicine_time')
  //         .doc(idCheck)
  //         .get()
  //         .then((DocumentSnapshot documentSnapshot) {
  //       var hasMorningDose = documentSnapshot.data()['morning_dose'];
  //       var hasEveningDose = documentSnapshot.data()['evening_dose'];
  //       // med.setHasMorningDose(hasMorningDose);
  //       med.setHasEveningDose(hasEveningDose);
  //       med.setHasMorningDose(hasMorningDose);
  //       // print(med.hasMorningDose);
  //       print('inMoreMed::: ${med.hasMorningDose}');
  //       print(med.hasEveningDose);
  //     });
  //   });
  // }

  Widget buildInhalersMedicine(String nameMedicine, String image,
      String numOfPress, String timeToTake, int index, bool hasMed) {
    return Container(
      height: 160,
      child: Card(
        shape: RoundedRectangleBorder(
          // side: BorderSide(color: Colors.black, width: 1),
          borderRadius: BorderRadius.circular(20),
        ),
        elevation: 5,
        child: Column(children: [
          Container(
            decoration: BoxDecoration(
              color: hasMed ? Theme.of(context).primaryColor : Colors.grey[400],
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            // color: Colors.green,
            child: ListTile(
              leading: SizedBox(
                width: 50,
              ),
              title: Text(
                nameMedicine,
                style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w600,
                    color: Colors.black54),
                textAlign: TextAlign.center,
              ),
              trailing: IconButton(
                padding: EdgeInsets.all(0),
                icon: Icon(Icons.more_horiz),
                iconSize: 50,
                onPressed: () =>
                    buildBottomSheet(nameMedicine, timeToTake, index),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListTile(
              leading: Image.asset(image, fit: BoxFit.cover),
              title: Text(nameMedicine),
              subtitle: Text('พ่นจมูกข้างละ $numOfPress กด'),
            ),
          ),
        ]),
      ),
    );
  }

  Widget buildTabletMedicine(
    String nameMedicine,
    String image,
    String takePerTime,
    String timeToTake,
    int index,
    bool hasMed,
  ) {
    return Container(
      height: 170,
      child: Card(
        shape: RoundedRectangleBorder(
          // side: BorderSide(color: Colors.black, width: 1),
          borderRadius: BorderRadius.circular(20),
        ),
        elevation: 5,
        child: Column(children: [
          Container(
            decoration: BoxDecoration(
              color: hasMed ? Theme.of(context).primaryColor : Colors.grey[400],
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            // color: Colors.green,
            child: ListTile(
              leading: SizedBox(
                width: 50,
              ),
              title: Text(
                nameMedicine,
                style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w600,
                    color: Colors.black54),
                textAlign: TextAlign.center,
              ),
              trailing: IconButton(
                padding: EdgeInsets.all(0),
                icon: Icon(Icons.more_horiz),
                iconSize: 50,
                onPressed: () =>
                    buildBottomSheet(nameMedicine, timeToTake, index),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListTile(
              leading: Image.asset(image, fit: BoxFit.cover),
              title: Text(nameMedicine),
              subtitle: Text('รับประทานครั้งละ $takePerTime เม็ด'),
            ),
          ),
        ]),
      ),
    );
  }

  void buildBottomSheet(
    String nameMedicine,
    String timeToTake,
    int index,
  ) {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
          // side: BorderSide(color: Colors.black, width: 1),
          borderRadius: BorderRadius.circular(20),
        ),
        context: context,
        builder: (context) {
          return Container(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'บันทึกการทานยา',
                      style: TextStyle(
                        fontSize: 30,
                        color: Colors.black54,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  child: TextButton(
                    onPressed: () async {
                      print(idMedicine[nameMedicine]);
                      var idCheckMed;

                      await FirebaseFirestore.instance
                          .collection('patients')
                          .doc(currentPatient.uid)
                          .collection('medicines')
                          .doc(idMedicine[nameMedicine])
                          .collection('medicine_time')
                          .orderBy('create_at', descending: true)
                          .limit(1)
                          .get()
                          .then((QuerySnapshot querySnapshot) {
                        idCheckMed = querySnapshot.docs.first.id;
                      });

                      if (timeToTake == 'morning_dose') {
                        await FirebaseFirestore.instance
                            .collection('patients')
                            .doc(currentPatient.uid)
                            .collection('medicines')
                            .doc(idMedicine[nameMedicine])
                            .update({
                          'check_current_take.check_take_morning': true
                        });
                      } else if (timeToTake == 'evening_dose') {
                        await FirebaseFirestore.instance
                            .collection('patients')
                            .doc(currentPatient.uid)
                            .collection('medicines')
                            .doc(idMedicine[nameMedicine])
                            .update({
                          'check_current_take.check_take_evening': true
                        });
                      } else {
                        await FirebaseFirestore.instance
                            .collection('patients')
                            .doc(currentPatient.uid)
                            .collection('medicines')
                            .doc(idMedicine[nameMedicine])
                            .update({
                          'check_current_take.check_take_before_bed': true
                        });
                      }

                      await FirebaseFirestore.instance
                          .collection('patients')
                          .doc(currentPatient.uid)
                          .collection('medicines')
                          .doc(idMedicine[nameMedicine])
                          .collection('medicine_time')
                          .doc(idCheckMed)
                          .update({timeToTake: true}).then((value) {
                        if (timeToTake == 'morning_dose') {
                          morningMed.elementAt(index).setHasMorningDose(true);
                        } else if (timeToTake == 'evening_dose') {
                          eveningMed.elementAt(index).setHasEveningDose(true);
                        } else {
                          beforeBedMed
                              .elementAt(index)
                              .setHasBeforeBedDoes(true);
                        }
                        Navigator.pop(context);
                        setState(() {});
                      });
                    },
                    child: Text(
                      'ทำแล้ว',
                      style: TextStyle(
                        fontSize: 30,
                        color: Theme.of(context).primaryColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  child: TextButton(
                    onPressed: () async {
                      print(idMedicine[nameMedicine]);
                      var idCheckMed;
                      await FirebaseFirestore.instance
                          .collection('patients')
                          .doc(currentPatient.uid)
                          .collection('medicines')
                          .doc(idMedicine[nameMedicine])
                          .collection('medicine_time')
                          .orderBy('create_at', descending: true)
                          .limit(1)
                          .get()
                          .then((QuerySnapshot querySnapshot) {
                        idCheckMed = querySnapshot.docs.first.id;
                      });

                      if (timeToTake == 'morning_dose') {
                        await FirebaseFirestore.instance
                            .collection('patients')
                            .doc(currentPatient.uid)
                            .collection('medicines')
                            .doc(idMedicine[nameMedicine])
                            .update({
                          'check_current_take.check_take_morning': false
                        });
                      } else if (timeToTake == 'evening_dose') {
                        await FirebaseFirestore.instance
                            .collection('patients')
                            .doc(currentPatient.uid)
                            .collection('medicines')
                            .doc(idMedicine[nameMedicine])
                            .update({
                          'check_current_take.check_take_evening': false
                        });
                      } else {
                        await FirebaseFirestore.instance
                            .collection('patients')
                            .doc(currentPatient.uid)
                            .collection('medicines')
                            .doc(idMedicine[nameMedicine])
                            .update({
                          'check_current_take.check_take_before_bed': false
                        });
                      }

                      await FirebaseFirestore.instance
                          .collection('patients')
                          .doc(currentPatient.uid)
                          .collection('medicines')
                          .doc(idMedicine[nameMedicine])
                          .collection('medicine_time')
                          .doc(idCheckMed)
                          .update({timeToTake: false}).then((value) {
                        if (timeToTake == 'morning_dose') {
                          morningMed.elementAt(index).setHasMorningDose(false);
                        } else if (timeToTake == 'evening_dose') {
                          eveningMed.elementAt(index).setHasEveningDose(false);
                        } else {
                          beforeBedMed
                              .elementAt(index)
                              .setHasBeforeBedDoes(false);
                        }
                        Navigator.pop(context);
                        setState(() {});
                      });
                    },
                    child: Text(
                      'ไม่ได้ทำ',
                      style: TextStyle(
                        fontSize: 30,
                        color: Theme.of(context).primaryColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  child: TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      'ยกเลิก',
                      style: TextStyle(
                        fontSize: 30,
                        color: Theme.of(context).primaryColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final DateTime today = DateTime.now();
    String day;
    String month;
    String year;

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

    // print('Timestamp: ${Timestamp.now()}');

    // print('idMed: ${idMedicine.values.elementAt(0)}');

    // final birthday = DateTime(2021, 5, 7);
    // final date2 = DateTime.now();
    // final difference = date2.difference(birthday).inDays;
    // print('diffDay: $difference');
    return Scaffold(
      appBar: AppBar(
        title: Text('ยาสำหรับวันนี้'),
      ),
      body: FutureBuilder(
          future: loadDataMedicine(),
          builder: (context, futureSnapshot) {
            if (futureSnapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            try {
              morningMed.addAll(
                  inMed.where((element) => element.timeToTake['morning_dose']));
              morningMed.addAll(tabMed
                  .where((element) => element.timeToTake['morning_dose']));

              eveningMed.addAll(
                  inMed.where((element) => element.timeToTake['evening_dose']));
              eveningMed.addAll(tabMed
                  .where((element) => element.timeToTake['evening_dose']));

              // beforeBedMed.addAll(inMed
              //     .where((element) => element.timeToTake['before_bed_dose']));
              beforeBedMed.addAll(tabMed
                  .where((element) => element.timeToTake['before_bed_dose']));
              // morningMed.addAll(inMed);
              // morningMed.addAll(tabMed);
              hasLoadData = true;
              inMed.forEach((element) {
                print(
                    'in: ${element.nameMedicine} used: ${element.hasMorningDose}');
              });
              morningMed.forEach((element) {
                print(
                    '${element.nameMedicine} used: ${element.hasMorningDose}');
              });
              print(idMedicine);
              print('Morn: ${morningMed.length}');
              print('Morn: ${morningMed.first.hasMorningDose}');
            } catch (e) {
              print('Morn');
              print(e.toString());
            }
            return SingleChildScrollView(
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.all(15),
                  child: Text(
                    '$dayที่ ${today.day} $month $year',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  child: Text(
                    'ยาเช้า',
                    style: TextStyle(fontSize: 25),
                  ),
                ),
                ListView.builder(
                    primary: false,
                    shrinkWrap: true,
                    itemBuilder: (_, index) {
                      if (morningMed.elementAt(index).typeOfMedicine ==
                          'inhalers') {
                        print(
                            'mornIn: ${morningMed.elementAt(index).hasMorningDose}');
                        return buildInhalersMedicine(
                          morningMed.elementAt(index).nameMedicine,
                          morningMed.elementAt(index).image,
                          morningMed.elementAt(index).numOfPress,
                          'morning_dose',
                          index,
                          morningMed.elementAt(index).hasMorningDose,
                        );
                      } else if (morningMed.elementAt(index).typeOfMedicine ==
                          'tablet') {
                        return buildTabletMedicine(
                          morningMed.elementAt(index).nameMedicine,
                          morningMed.elementAt(index).image,
                          morningMed.elementAt(index).takePerTime,
                          'morning_dose',
                          index,
                          morningMed.elementAt(index).hasMorningDose,
                        );
                      }
                    },
                    itemCount: morningMed.length),
                Container(
                  child: Text(
                    'ยาเย็น',
                    style: TextStyle(fontSize: 25),
                  ),
                ),
                ListView.builder(
                    primary: false,
                    shrinkWrap: true,
                    itemBuilder: (_, index) {
                      if (eveningMed.elementAt(index).typeOfMedicine ==
                          'inhalers') {
                        return buildInhalersMedicine(
                          eveningMed.elementAt(index).nameMedicine,
                          eveningMed.elementAt(index).image,
                          eveningMed.elementAt(index).numOfPress,
                          'evening_dose',
                          index,
                          eveningMed.elementAt(index).hasEveningDose,
                        );
                      } else if (eveningMed.elementAt(index).typeOfMedicine ==
                          'tablet') {
                        return buildTabletMedicine(
                          eveningMed.elementAt(index).nameMedicine,
                          eveningMed.elementAt(index).image,
                          eveningMed.elementAt(index).takePerTime,
                          'evening_dose',
                          index,
                          eveningMed.elementAt(index).hasEveningDose,
                        );
                      }
                    },
                    itemCount: eveningMed.length),
                Container(
                  child: Text(
                    'ยาก่อนนอน',
                    style: TextStyle(fontSize: 25),
                  ),
                ),
                ListView.builder(
                    primary: false,
                    shrinkWrap: true,
                    itemBuilder: (_, index) {
                      return buildTabletMedicine(
                        beforeBedMed.elementAt(index).nameMedicine,
                        beforeBedMed.elementAt(index).image,
                        beforeBedMed.elementAt(index).takePerTime,
                        'before_bed_dose',
                        index,
                        beforeBedMed.elementAt(index).hasBeforeBedDose,
                      );
                    },
                    itemCount: beforeBedMed.length)
              ]),
            );
          }),
    );
  }
}
