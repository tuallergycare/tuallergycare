import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tuallergycare/screens/doctor/d_adddrug_screen.dart';
import 'package:tuallergycare/screens/doctor/d_drugoral.dart';
import 'package:tuallergycare/utility/style.dart';
import 'package:tuallergycare/screens/doctor/d_drugspay.dart';

class BottomSheetTypeDrug extends StatefulWidget {
  static const routeName = '/adddrug_typedrug';
  String patientId;
  BottomSheetTypeDrug(this.patientId);

  @override
  BottomSheetTypeDrugState createState() => BottomSheetTypeDrugState(patientId);
}

class BottomSheetTypeDrugState extends State<BottomSheetTypeDrug> {
  String patientId;
  BottomSheetTypeDrugState(this.patientId);
  String _typedrug;
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xff757575),
      child: Container(
        padding: EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              'เพิ่มยา',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20.0,
                color: Style().darkColor,
              ),
            ),
            Container(
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.only(top: 5),
                child: Column(
                  children: <Widget>[
                    Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'ประเภทของยา',
                        style: TextStyle(
                            fontSize: 16, color: Style().prinaryColor),
                      ),
                    ),
                    RadioListTile(
                      title: const Text('ยารับประทาน'),
                      activeColor: Theme.of(context).primaryColor,
                      value: 'ยารับประทาน',
                      groupValue: _typedrug,
                      onChanged: (value) {
                        setState(() {
                          _typedrug = value;
                        });
                      },
                    ),
                    RadioListTile(
                      title: const Text('ยาพ่น'),
                      activeColor: Theme.of(context).primaryColor,
                      value: 'ยาพ่น',
                      groupValue: _typedrug,
                      onChanged: (value) {
                        setState(() {
                          _typedrug = value;
                        });
                      },
                    ),
                  ],
                )),
            RaisedButton(
              child: Text(
                'Next',
                style: TextStyle(color: Colors.white),
              ),
              color: Style().prinaryColor,
              onPressed: () {
                if (_typedrug == 'ยาพ่น') {
                  Navigator.of(context).pushNamed(DrugSpay.routeName, arguments: patientId);
                } else {
                  Navigator.of(context).pushNamed(DrugOral.routeName, arguments: patientId);
                }
                // showModalBottomSheet(
                //   context: context,
                //   isScrollControlled: true,
                //   builder: (context) => SingleChildScrollView(
                //     child: Container(
                //       padding: EdgeInsets.only(
                //           bottom: MediaQuery.of(context).viewInsets.bottom),
                //      child: DrugSpay()
                //     ),
                //   ),
                // );
              },
            ),
          ],
        ),
      ),
    );
  }
}
