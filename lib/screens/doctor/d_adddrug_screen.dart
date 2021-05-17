import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tuallergycare/screens/doctor/d_drugspay.dart';
import 'package:tuallergycare/screens/medicine_screen.dart';
import 'package:tuallergycare/utility/style.dart';
import 'package:tuallergycare/screens/doctor/d_bottomsheet_adddrug.dart';
import 'package:grouped_list/grouped_list.dart';

List _dataDrug = [
  {
    "albumId": 1,
    "id": 1,
    "type": "ยาพ่น",
    "nameDrug": "Aerius",
    "imagesDrug": "assets/images/aerius.png",
    "detailDrug": "ใช้สำหรับพ่นจมูก2ข้าง",
    "detailUse": "จำนวน 2 กดต่อข้างตอนเช้า"
  },
  {
    "albumId": 1,
    "id": 2,
    "type": "ยาพ่น",
    "nameDrug": "Avamys",
    "imagesDrug": "assets/images/avamys.png",
    "detailDrug": "ใช้สำหรับพ่นจมูก2ข้าง",
    "detailUse": "จำนวน 1 กดต่อข้างเย็น"
  },
  {
    "albumId": 1,
    "id": 2,
    "type": "ยากิน",
    "nameDrug": "Avamys",
    "imagesDrug": "assets/images/avamys.png",
    "detailDrug": "ใช้สำหรับพ่นจมูก2ข้าง",
    "detailUse": "จำนวน 1 กดต่อข้างเย็น"
  },
];

class AddDrugScreen extends StatefulWidget {
  static const routeName = '/doctoradddrugscreen';

  @override
  _AddDrugScreenState createState() => _AddDrugScreenState();
}

class _AddDrugScreenState extends State<AddDrugScreen> {
  List _medicine = [];
  String patientId;

  Future<void> loadMidecinePatient() async {
    if (_medicine.length != 0) {
      _medicine.clear();
    }

    try {
      await FirebaseFirestore.instance
          .collection('patients')
          .doc(patientId)
          .collection('medicines')
          .get()
          .then((QuerySnapshot querySnapshot) {
        querySnapshot.docs.forEach((DocumentSnapshot doc) {
          if (doc.data()['type_medicine'] == 'inhalers') {
            _medicine.add(new InhalersMedicine(
              doc.data()['name_medicine'],
              doc.data()['type_medicine'],
              doc.data()['image'],
              doc.data()['num_of_press'],
              doc.data()['time_to_take'],
              doc.data()['check_current_take']['check_take_morning'],
              doc.data()['check_current_take']['check_take_evening'],
            ));
          } else {
            _medicine.add(
              new TabletMedicine(
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
              ),
            );
          }
        });
      });
    } catch (e) {
      print('Error load Med');
      print(e);
    }
  }

  String textTimeMedicine(dynamic element) {
    if (element.typeOfMedicine == 'inhalers') {
      var textTimeInhalers = 'พ่น: ';
      if (element.timeToTake['morning_dose'] == true) {
        textTimeInhalers = textTimeInhalers + 'เช้า';
      }
      if (element.timeToTake['evening_dose'] == true) {
        textTimeInhalers = textTimeInhalers + '/เย็น';
      }
      return textTimeInhalers;
    } else {
      var textTimeTablets = 'รับประทาน: ';
      if (element.timeToTake['morning_dose'] == true) {
        textTimeTablets = textTimeTablets + 'เช้า';
      }
      if (element.timeToTake['evening_dose'] == true) {
        textTimeTablets = textTimeTablets + '/เย็น';
      }
      if (element.timeToTake['evening_dose'] == true) {
        textTimeTablets = textTimeTablets + '/ก่อนนอน';
      }
      return textTimeTablets;
    }
  }

  String testDosageMedicine(dynamic element) {
    if (element.typeOfMedicine == 'inhalers') {
      print(element.runtimeType);
      print(element.typeOfMedicine);
      if (element.numOfPress == '1') {
        return 'จำนวน 1 กดต่อข้าง';
      } else {
        return 'จำนวน 2 กดต่อข้าง';
      }
    } else {
      return 'ครั้งละ ${element.takePerTime} เม็ด';
    }
  }

  @override
  Widget build(BuildContext context) {
    //final selectedspray = ModalRoute.of(context).settings.arguments;
    // final selectedquantityspray =ModalRoute.of(context).settings.arguments as String;
    patientId = ModalRoute.of(context).settings.arguments as String;
    return StreamBuilder<Object>(
        stream: FirebaseFirestore.instance
            .collection('patients')
            .doc(patientId)
            .collection('medicines')
            .snapshots(),
        builder: (context, snapshot) {
          return FutureBuilder(
              future: loadMidecinePatient(),
              builder: (context, snapshot) {
                return Scaffold(
                  appBar: AppBar(
                    title: const Text('เพิ่มการใช้ยา'),
                  ),
                  floatingActionButton: FloatingActionButton(
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        builder: (context) => SingleChildScrollView(
                          child: Container(
                            padding: EdgeInsets.only(
                                bottom:
                                    MediaQuery.of(context).viewInsets.bottom),
                            child: BottomSheetTypeDrug(patientId),
                          ),
                        ),
                      );
                      // Navigator.of(context).pushNamed(DrugSpay.routeName);
                    },
                    child: Icon(
                      Icons.add,
                      size: 40,
                      color: Colors.white,
                    ),
                    backgroundColor: Style().prinaryColor,
                  ),
                  body: GroupedListView<dynamic, dynamic>(
                    elements: _medicine,
                    groupBy: (element) => element.typeOfMedicine,
                    groupSeparatorBuilder: (dynamic groupByValue) => Padding(
                      padding: EdgeInsets.all(10),
                      child: Row(
                        children: [
                          Flexible(
                              child: Row(
                            children: [
                              Container(
                                margin: EdgeInsets.only(left: 10, right: 10),
                                child: groupByValue == 'inhalers'
                                    ? Text(
                                        'ยาพ่น',
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      )
                                    : Text(
                                        'ยารับประทาน',
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                              )
                            ],
                          ))
                        ],
                      ),
                    ),
                    itemBuilder: (context, dynamic element) {
                      return Card(
                        elevation: 10,
                        margin:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        child: Container(
                          padding: EdgeInsets.all(10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                  child: ClipRRect(
                                child: Image(
                                  image: AssetImage(element.image),
                                  fit: BoxFit.cover,
                                  height: 100,
                                  width: 100,
                                ),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5)),
                              )),
                              Expanded(
                                flex: 2,
                                child: Container(
                                  padding: EdgeInsets.only(bottom: 10),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left: 10, right: 10),
                                        child: Text(
                                          element.nameMedicine,
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left: 10, right: 10),
                                        child: Text(
                                          // element['detailDrug'],
                                          textTimeMedicine(element),
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left: 10, right: 10),
                                        child: Text(
                                          testDosageMedicine(element),
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left: 10, right: 10, top: 5),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            RaisedButton(
                                              child: Text(
                                                'ยกเลิก',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                              color: Colors.grey,
                                              onPressed: () {},
                                            ),
                                            SizedBox(
                                              width: 20,
                                            ),
                                            RaisedButton(
                                              child: Text(
                                                'แก้ไข',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                              color: Colors.grey,
                                              onPressed: () {},
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                    itemComparator: (item1, item2) => item1.nameMedicine
                        .compareTo(item2.nameMedicine), // optional
                    useStickyGroupSeparators: true, // optional
                    floatingHeader: true, // optional
                    order: GroupedListOrder.ASC, // optional
                  ),
                );
              });
        });
  }
}
