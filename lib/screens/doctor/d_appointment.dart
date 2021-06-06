import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tuallergycare/utility/style.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:badges/badges.dart';

class Appointment extends StatefulWidget {
  static const routeName = '/appointment';
  @override
  _AppointmentState createState() => _AppointmentState();
}

class _AppointmentState extends State<Appointment> {
  CalendarController _calendarController;
  String patientId;
  List<String> chipTime = [
    "09.00-10.00น.",
    "10.00-11.00น.",
    "11.00-12.00น.",
    "12.00-13.00น.",
    "13.00-14.00น.",
    "14.00-15.00น.",
    "15.00-16.00น.",
    "16.00-17.00น.",
    "17.00-18.00น.",
    "18.00-19.00น.",
    "19.00-20.00น.",
    "20.00-21.00น.",
  ];

  DateTime selectedDate = DateTime.now();
  String selectedTime;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _calendarController = CalendarController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _calendarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    patientId = ModalRoute.of(context).settings.arguments as String;
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('จองเวลานัดหมาย'),
      // ),
      body: Container(
        child: Column(
          children: <Widget>[
            MyHeader(
              height: 258,
              imageUrl: 'assets/images/head.png',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: 70,
                  ),
                  Text(
                    'นัดหมายช่วงเวลา',
                    style: TextStyle(
                      color: Style().darkColor,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                child: Column(
                  children: <Widget>[
                    Column(
                      children: [
                        TableCalendar(
                          initialSelectedDay: DateTime.now(),
                          calendarController: _calendarController,
                          initialCalendarFormat: CalendarFormat.week,
                          startingDayOfWeek: StartingDayOfWeek.monday,
                          formatAnimation: FormatAnimation.slide,
                          headerStyle: HeaderStyle(
                            centerHeaderTitle: true,
                            formatButtonVisible: false,
                            titleTextStyle:
                                TextStyle(color: Colors.black, fontSize: 16),
                            leftChevronIcon: Icon(
                              Icons.arrow_back_ios,
                              color: Colors.black,
                              size: 15,
                            ),
                            rightChevronIcon: Icon(
                              Icons.arrow_forward_ios,
                              color: Colors.black,
                              size: 15,
                            ),
                            leftChevronMargin: EdgeInsets.only(left: 70),
                            rightChevronMargin: EdgeInsets.only(right: 70),
                          ),
                          calendarStyle: CalendarStyle(
                              weekendStyle: TextStyle(color: Colors.black),
                              weekdayStyle: TextStyle(color: Colors.black)),
                          daysOfWeekStyle: DaysOfWeekStyle(
                              weekendStyle: TextStyle(color: Colors.black),
                              weekdayStyle: TextStyle(color: Colors.black)),
                          onDaySelected:
                              (DateTime selectTime, List t1, List t2) {
                            print(selectTime);
                            print(Timestamp.fromDate(selectTime));
                            selectedDate = selectTime;
                          },
                        ),
                      ],
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'กรุณาเลือกช่วงเวลาที่ว่าง',
                          style: TextStyle(
                            color: Style().darkColor,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      child: Wrap(
                        spacing: 5.0,
                        runSpacing: 5.0,
                        children: <Widget>[
                          ChoiceChip(
                            label: Text("09.00-10.00น."),
                            labelStyle: TextStyle(
                                color: Colors.black,
                                fontSize: 14.0,
                                fontWeight: FontWeight.bold),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            backgroundColor: Color(0xffededed),
                            selectedColor: Style().prinaryColor,
                            selected: selectedTime == "09.00-10.00น.",
                            onSelected: (selected) {
                              setState(() {
                                selectedTime = "09.00-10.00น.";
                                // widget.selectedTime = selectedChoice;
                              });
                            },
                          ),
                          ChoiceChip(
                            label: Text("10.00-11.00น."),
                            labelStyle: TextStyle(
                                color: Colors.black,
                                fontSize: 14.0,
                                fontWeight: FontWeight.bold),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            backgroundColor: Color(0xffededed),
                            selectedColor: Style().prinaryColor,
                            selected: selectedTime == "10.00-11.00น.",
                            onSelected: (selected) {
                              setState(() {
                                selectedTime = "10.00-11.00น.";
                                // widget.selectedTime = selectedChoice;
                              });
                            },
                          ),
                          ChoiceChip(
                            label: Text("11.00-12.00น."),
                            labelStyle: TextStyle(
                                color: Colors.black,
                                fontSize: 14.0,
                                fontWeight: FontWeight.bold),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            backgroundColor: Color(0xffededed),
                            selectedColor: Style().prinaryColor,
                            selected: selectedTime == "11.00-12.00น.",
                            onSelected: (selected) {
                              setState(() {
                                selectedTime = "11.00-12.00น.";
                                // widget.selectedTime = selectedChoice;
                              });
                            },
                          ),
                          ChoiceChip(
                            label: Text("12.00-13.00น."),
                            labelStyle: TextStyle(
                                color: Colors.black,
                                fontSize: 14.0,
                                fontWeight: FontWeight.bold),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            backgroundColor: Color(0xffededed),
                            selectedColor: Style().prinaryColor,
                            selected: selectedTime == "12.00-13.00น.",
                            onSelected: (selected) {
                              setState(() {
                                selectedTime = "12.00-13.00น.";
                                // widget.selectedTime = selectedChoice;
                              });
                            },
                          ),
                          ChoiceChip(
                            label: Text("13.00-14.00น."),
                            labelStyle: TextStyle(
                                color: Colors.black,
                                fontSize: 14.0,
                                fontWeight: FontWeight.bold),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            backgroundColor: Color(0xffededed),
                            selectedColor: Style().prinaryColor,
                            selected: selectedTime == "13.00-14.00น.",
                            onSelected: (selected) {
                              setState(() {
                                selectedTime = "13.00-14.00น.";
                                // widget.selectedTime = selectedChoice;
                              });
                            },
                          ),
                          ChoiceChip(
                            label: Text("14.00-15.00น."),
                            labelStyle: TextStyle(
                                color: Colors.black,
                                fontSize: 14.0,
                                fontWeight: FontWeight.bold),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            backgroundColor: Color(0xffededed),
                            selectedColor: Style().prinaryColor,
                            selected: selectedTime == "14.00-15.00น.",
                            onSelected: (selected) {
                              setState(() {
                                selectedTime = "14.00-15.00น.";
                                // widget.selectedTime = selectedChoice;
                              });
                            },
                          ),
                          ChoiceChip(
                            label: Text("15.00-16.00น."),
                            labelStyle: TextStyle(
                                color: Colors.black,
                                fontSize: 14.0,
                                fontWeight: FontWeight.bold),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            backgroundColor: Color(0xffededed),
                            selectedColor: Style().prinaryColor,
                            selected: selectedTime == "15.00-16.00น.",
                            onSelected: (selected) {
                              setState(() {
                                selectedTime = "15.00-16.00น.";
                                // widget.selectedTime = selectedChoice;
                              });
                            },
                          ),
                          ChoiceChip(
                            label: Text("16.00-17.00น."),
                            labelStyle: TextStyle(
                                color: Colors.black,
                                fontSize: 14.0,
                                fontWeight: FontWeight.bold),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            backgroundColor: Color(0xffededed),
                            selectedColor: Style().prinaryColor,
                            selected: selectedTime == "16.00-17.00น.",
                            onSelected: (selected) {
                              setState(() {
                                selectedTime = "16.00-17.00น.";
                                // widget.selectedTime = selectedChoice;
                              });
                            },
                          ),
                          ChoiceChip(
                            label: Text("17.00-18.00น."),
                            labelStyle: TextStyle(
                                color: Colors.black,
                                fontSize: 14.0,
                                fontWeight: FontWeight.bold),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            backgroundColor: Color(0xffededed),
                            selectedColor: Style().prinaryColor,
                            selected: selectedTime == "17.00-18.00น.",
                            onSelected: (selected) {
                              setState(() {
                                selectedTime = "17.00-18.00น.";
                                // widget.selectedTime = selectedChoice;
                              });
                            },
                          ),
                          ChoiceChip(
                            label: Text("18.00-19.00น."),
                            labelStyle: TextStyle(
                                color: Colors.black,
                                fontSize: 14.0,
                                fontWeight: FontWeight.bold),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            backgroundColor: Color(0xffededed),
                            selectedColor: Style().prinaryColor,
                            selected: selectedTime == "18.00-19.00น.",
                            onSelected: (selected) {
                              setState(() {
                                selectedTime = "18.00-19.00น.";
                                // widget.selectedTime = selectedChoice;
                              });
                            },
                          ),
                          ChoiceChip(
                            label: Text("19.00-20.00น."),
                            labelStyle: TextStyle(
                                color: Colors.black,
                                fontSize: 14.0,
                                fontWeight: FontWeight.bold),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            backgroundColor: Color(0xffededed),
                            selectedColor: Style().prinaryColor,
                            selected: selectedTime == "19.00-20.00น.",
                            onSelected: (selected) {
                              setState(() {
                                selectedTime = "19.00-20.00น.";
                                // widget.selectedTime = selectedChoice;
                              });
                            },
                          ),
                          ChoiceChip(
                            label: Text("20.00-21.00น."),
                            labelStyle: TextStyle(
                                color: Colors.black,
                                fontSize: 14.0,
                                fontWeight: FontWeight.bold),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            backgroundColor: Color(0xffededed),
                            selectedColor: Style().prinaryColor,
                            selected: selectedTime == "20.00-21.00น.",
                            onSelected: (selected) {
                              setState(() {
                                selectedTime = "20.00-21.00น.";
                                // widget.selectedTime = selectedChoice;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          RaisedButton(
                            child: Text(
                              'ยกเลิกการจอง',
                              style: TextStyle(color: Colors.white),
                            ),
                            color: Colors.grey[400],
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          RaisedButton(
                            child: Text(
                              'ยืนยันการจอง',
                              style: TextStyle(color: Colors.white),
                            ),
                            color: Style().prinaryColor,
                            onPressed: () async {
                              if (selectedDate == null ||
                                  selectedTime == null) {
                                await showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: Text('กรุณากรอกข้อมูลให้ครบ'),
                                    // content: Text('Something went wrong.'),
                                    actions: <Widget>[
                                      TextButton(
                                        child: Text(
                                          'ตกลง',
                                          style: TextStyle(
                                            color:
                                                Theme.of(context).primaryColor,
                                          ),
                                        ),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                          return;
                                        },
                                      )
                                    ],
                                  ),
                                );
                              }

                              await FirebaseFirestore.instance
                                  .collection('patients')
                                  .doc(patientId)
                                  .update(
                                {
                                  'appointment': {
                                    'day': selectedDate,
                                    'time': selectedTime
                                  }
                                },
                              );
                              Navigator.pop(context);
                            },
                          
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MyHeader extends StatelessWidget {
  final double height;
  final String imageUrl;
  final Widget child;

  const MyHeader({
    @required this.height,
    @required this.imageUrl,
    @required this.child,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: MyCliper(),
      child: Container(
        alignment: Alignment.topCenter,
        height: height,
        width: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage(imageUrl), fit: BoxFit.fill),
        ),
        child: child,
      ),
    );
  }
}

class MyCliper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height - 50);
    path.quadraticBezierTo(
        size.width / 2, size.height, size.width, size.height - 50);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}

class choiceChipWidget extends StatefulWidget {
  final List<String> reportList;
  // String selectedTime;

  choiceChipWidget(this.reportList);

  @override
  _choiceChipWidgetState createState() => new _choiceChipWidgetState();
}

class _choiceChipWidgetState extends State<choiceChipWidget> {
  String selectedChoice = "";

  _buildChoiceList() {
    List<Widget> choices = [];
    widget.reportList.forEach((item) {
      choices.add(Container(
        padding: const EdgeInsets.all(2.0),
        child: ChoiceChip(
          label: Text(item),
          labelStyle: TextStyle(
              color: Colors.black, fontSize: 14.0, fontWeight: FontWeight.bold),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          backgroundColor: Color(0xffededed),
          selectedColor: Style().prinaryColor,
          selected: selectedChoice == item,
          onSelected: (selected) {
            setState(() {
              selectedChoice = item;

              // widget.selectedTime = selectedChoice;
            });
          },
        ),
      ));
    });
    return choices;
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: _buildChoiceList(),
    );
  }
}
