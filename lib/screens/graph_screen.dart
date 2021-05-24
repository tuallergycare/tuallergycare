import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import 'doctor/d_patientprofile_screen.dart';

class GraphScreen extends StatefulWidget {
  static const routeName = '/graph-screen';
  @override
  _GraphScreenState createState() => _GraphScreenState();
}

class _GraphScreenState extends State<GraphScreen> {
  final currentPatient = FirebaseAuth.instance.currentUser;
  DateTime today = DateTime.now();
  List<MedicineNote> _medicineNotes = [];
  List<RecordMedicine> _recordMedicines = [];

  List<AssessmentNote> _assessmentNotes = [];

  CalendarController _calendarController;

  Future<void> loadHistoryMidecineAndAssessment() async {
    try {
      await FirebaseFirestore.instance
          .collection('patients')
          .doc(currentPatient.uid)
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
                  element.data()['time_to_take'], []),
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
            .doc(currentPatient.uid)
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
          .doc(currentPatient.uid)
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
    return Scaffold(
      appBar: AppBar(
        title: Text('กราฟผู้ป่วย'),
      ),
      body: FutureBuilder<Object>(
        future: loadHistoryMidecineAndAssessment(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
          return Container(
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

                          _medicineNotes.elementAt(i).record.forEach((element) {
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

                          _medicineNotes.elementAt(i).record.forEach((element) {
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

                        if (results.every((element) => element == 'complete')) {
                          isComplete = true;
                        }

                        if (isComplete != true) {
                          if (results.contains('complete') ||
                              results.contains('incomplete')) {
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

                      var vas = 0;

                      var isZero = false;
                      var isLessThenFive = false;
                      var isMoreThanFive = false;

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

                      print('vas: ${vas}');

                      if (vas == 0) {
                        isZero = true;
                      }
                      if (vas < 5 && vas != 0) {
                        isLessThenFive = true;
                      }
                      if (vas >= 5) {
                        isMoreThanFive = true;
                      }

                      return SingleChildScrollView(
                        child: Container(
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
                                            color: isMoreThanFive
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
                            )),
                      );
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
          );
        }),
    );
  }
}
