//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Disease extends StatefulWidget {
  static const routeName = '/disease';
  @override
  _DiseaseState createState() => _DiseaseState();
}

class _DiseaseState extends State<Disease> {
  String disease;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var patientId = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: const Text('โรค'),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Center(
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'แก้ไขโรค',
                      style: TextStyle(
                          fontSize: 18, color: Theme.of(context).primaryColor),
                    ),
                  ),
                  Form(
                    key: _formKey,
                    child: Container(
                      margin: EdgeInsets.only(top: 10),
                      child: TextFormField(
                        onSaved: (String value) {
                          disease = value;
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
                  // Container(
                  //   margin: EdgeInsets.only(top: 10),
                  //   child: TextField(

                  //     decoration: InputDecoration(
                  //       labelStyle: TextStyle(
                  //         fontSize: 18,
                  //         color: Colors.black,
                  //       ),
                  //       border: OutlineInputBorder(),
                  //     ),
                  //     obscureText: false,
                  //     maxLines: 2,
                  //   ),
                  // ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: RaisedButton(
                      child: Text(
                        'บันทึก',
                        style: TextStyle(color: Colors.white),
                      ),
                      color: Theme.of(context).primaryColor,
                      onPressed: () async {

                        if (!_formKey.currentState.validate()) {
                          return;
                        }
                        _formKey.currentState.save();
                        
                        await FirebaseFirestore.instance
                            .collection('patients')
                            .doc(patientId)
                            .update({'disease': disease});

                            Navigator.pop(context);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
