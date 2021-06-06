import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tuallergycare/utility/style.dart';

class StatusScreen extends StatefulWidget {
  static const routeName = '/status';
  @override
  _StatusScreenState createState() => _StatusScreenState();
}

class _StatusScreenState extends State<StatusScreen> {
  String _selectedstatusPatient;
  String diagnose;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  List<Map> statusPatient = [
    {
      "id": '1',
      "image": "assets/images/status_green.png",
      "name": "น้อย (T0)",
      "status": "T0",
    },
    {
      "id": '2',
      "image": "assets/images/status_yellow.png",
      "name": "ปานกลาง (T1)",
      "status": "T1",
    },
    {
      "id": '3',
      "image": "assets/images/status_orange.png",
      "name": "ค่อนข้างรุนแรง (T2)",
      "status": "T2",
    },
    {
      "id": '4',
      "image": "assets/images/status_red.png",
      "name": "รุนแรงที่สุด (T3)",
      "status": "T3",
    }
  ];
  @override
  Widget build(BuildContext context) {
    var patientId = ModalRoute.of(context).settings.arguments as String;
    return Scaffold(
      appBar: AppBar(
        title: const Text('สถานะ'),
      ),
      body: Container(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              children: <Widget>[
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'แก้ไขอาการของผู้ป่วย',
                    style: TextStyle(fontSize: 18, color: Style().prinaryColor),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10),
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                      border: Border.all(width: 1, color: Colors.grey),
                      borderRadius: BorderRadius.circular(15)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                        child: DropdownButtonHideUnderline(
                          child: ButtonTheme(
                            alignedDropdown: true,
                            child: DropdownButton<String>(
                              isDense: true,
                              // hint: new Text(
                              //   "ชื่อยาสำหรับรับประทาน",
                              //   style: TextStyle(fontSize: 18),
                              // ),
                              value: _selectedstatusPatient,
                              onChanged: (String newValue) {
                                setState(() {
                                  _selectedstatusPatient = newValue;
                                });
                                print(_selectedstatusPatient);
                              },
                              items: statusPatient.map((Map map) {
                                return new DropdownMenuItem<String>(
                                  value: map["status"].toString(),
                                  child: Row(
                                    children: <Widget>[
                                      Image.asset(
                                        map["image"],
                                        fit: BoxFit.contain,
                                        width: 30,
                                        height: 30,
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(left: 10),
                                        child: Text(
                                          map["name"],
                                          style: TextStyle(
                                            color: Style().darkColor,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Container(
                //   margin: EdgeInsets.only(top: 10),
                //   alignment: Alignment.centerLeft,
                //   child: Text(
                //     'ผลวินิจฉัย',
                //     style: TextStyle(fontSize: 18, color: Style().prinaryColor),
                //   ),
                // ),
                // Form(
                //   key: _formKey,
                //   child: Container(
                //     margin: EdgeInsets.only(top: 10),
                //     child: TextFormField(
                //       onSaved: (String value) {
                //         diagnose = value;
                //       },
                //       decoration: InputDecoration(
                //         labelStyle: TextStyle(
                //           fontSize: 18,
                //           color: Colors.black,
                //         ),
                //         border: OutlineInputBorder(),
                //       ),
                //       obscureText: false,
                //       maxLines: 2,
                //     ),
                //   ),
                // ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RaisedButton(
                    child: Text(
                      'บันทึก',
                      style: TextStyle(color: Colors.white),
                    ),
                    color: Style().prinaryColor,
                    onPressed: () async {
                      // _formKey.currentState.save();

                      if (_selectedstatusPatient == null) {
                        await showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text('กรุณากำหนดสถานะ'),
                            // content: Text('Something went wrong.'),
                            actions: <Widget>[
                              TextButton(
                                child: Text(
                                  'ตกลง',
                                  style: TextStyle(
                                    color: Theme.of(context).primaryColor,
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

                      // if (diagnose == null || diagnose == '') {
                      //   diagnose =
                      //       'อาการ${statusPatient.firstWhere((element) => element['status'] == _selectedstatusPatient)['name']}';
                      // }

                      // print(diagnose);

                      await FirebaseFirestore.instance
                          .collection('patients')
                          .doc(patientId)
                          .update({
                        'status': _selectedstatusPatient,
                        // 'research': diagnose
                      });
                      setState(() {});
                      Navigator.pop(context);
                      
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
