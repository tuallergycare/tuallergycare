import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tuallergycare/utility/style.dart';

class Diagnose extends StatefulWidget {
  static const routeName = '/diagnose';
  @override
  _DiagnoseState createState() => _DiagnoseState();
}

class _DiagnoseState extends State<Diagnose> {
  // String _selectedstatusPatient;
  String diagnose;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  List<Map> statusPatient = [
    {
      "id": '1',
      "image": "assets/images/status_green.png",
      "name": "น้อย",
      "status": "T0",
    },
    {
      "id": '2',
      "image": "assets/images/status_yellow.png",
      "name": "ปานกลาง",
      "status": "T1",
    },
    {
      "id": '3',
      "image": "assets/images/status_orange.png",
      "name": "ค่อนข้างรุนแรง",
      "status": "T2",
    },
    {
      "id": '4',
      "image": "assets/images/status_red.png",
      "name": "รุนแรงที่สุด",
      "status": "T3",
    }
  ];
  @override
  Widget build(BuildContext context) {
    var patientId = ModalRoute.of(context).settings.arguments as String;
    return Scaffold(
      appBar: AppBar(
        title: const Text('ผลวินิจฉัย'),
      ),
      body: 
      Container(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: 10),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'ผลวินิจฉัย',
                    style: TextStyle(fontSize: 18, color: Style().prinaryColor),
                  ),
                ),
                Form(
                  key: _formKey,
                  child: Container(
                    margin: EdgeInsets.only(top: 10),
                    child: TextFormField(
                      onSaved: (String value) {
                        diagnose = value;
                      },
                      decoration: InputDecoration(
                        labelStyle: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                        ),
                        border: OutlineInputBorder(),
                      ),
                      obscureText: false,
                      maxLines: 2,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RaisedButton(
                    child: Text(
                      'บันทึก',
                      style: TextStyle(color: Colors.white),
                    ),
                    color: Style().prinaryColor,
                    onPressed: () async {
                      _formKey.currentState.save();

                      if (diagnose == null || diagnose == '') {
                        diagnose =
                            '-';
                      }

                      print(diagnose);

                      await FirebaseFirestore.instance
                          .collection('patients')
                          .doc(patientId)
                          .update({
                        'research': diagnose
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
