import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:url_launcher/url_launcher.dart';

class Scanner extends StatefulWidget {
  static const routeName = '/qrcodescreen';
  @override
  _ScannerState createState() => _ScannerState();
}

class _ScannerState extends State<Scanner> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController controller;
  final currentDoctor = FirebaseAuth.instance.currentUser;

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Scanner"),
      ),
      body: Stack(
        children: [
          Column(
            children: <Widget>[
              Expanded(
                flex: 5,
                child: Stack(
                  children: [
                    QRView(
                      key: qrKey,
                      onQRViewCreated: _onQRViewCreated,
                    ),
                    Center(
                      child: Container(
                        width: 300,
                        height: 300,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.red,
                            width: 4,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Center(
                  child: Text('สแกนคิวอาร์โค้ดเพื่อเพิ่มผู้ป่วย'),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    var checkId = false;
    var checkDuplicateId = false;
    List patients = [];
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) async {
      controller.pauseCamera();

      // if (await canLaunch(scanData.code)) {
      //   await launch(scanData.code);
      //   controller.resumeCamera();
      //   print(scanData.code);
      // } else {
      await FirebaseFirestore.instance
          .collection('patients')
          .get()
          .then((value) {
        value.docs.forEach((element) {
          if (scanData.code == element.id) {
            checkId = true;
          }
        });
      });

      if (checkId) {
        await FirebaseFirestore.instance
            .collection('doctors')
            .doc(currentDoctor.uid)
            .get()
            .then((doc) {
          patients = doc.data()['patients'];
          if (patients.contains(scanData.code)) {
            checkDuplicateId = true;
            print('Duplicate');
          } else {
            checkDuplicateId = false;
            patients.add(scanData.code);
          }
        });

        if (!checkDuplicateId) {
          await FirebaseFirestore.instance
              .collection('doctors')
              .doc(currentDoctor.uid)
              .update({'patients': patients});
          showDialog(
            context: context,
            builder: (BuildContext context) {
              print('เพิ่มผู้ป่วย');
              return AlertDialog(
                title: Text('เพิ่มผู้ป่วยเรียบร้อย'),
                actions: <Widget>[
                  TextButton(
                    child: Text('Ok'),
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                      print(scanData.code);
                    },
                  ),
                ],
              );
            },
          );
        }
        print(checkDuplicateId);

        if (checkDuplicateId) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              print('มีผู้ป่วยอยู่แล้ว');
              return AlertDialog(
                title: Text('มีผู้ป่วยอยู่แล้ว'),
                actions: <Widget>[
                  TextButton(
                    child: Text('Ok'),
                    onPressed: () {
                      Navigator.of(context).pop();
                      print(scanData.code);
                      patients.clear();
                    },
                  ),
                ],
              );
            },
          ).then((value) => controller.resumeCamera());
        }

        //already checked
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('ไม่พบผู้ป่วย'),
              actions: <Widget>[
                TextButton(
                  child: Text('Ok'),
                  onPressed: () {
                    Navigator.of(context).pop();
                    print(scanData.code);
                  },
                ),
              ],
            );
          },
        ).then((value) => controller.resumeCamera());
      }
      // }
    });
  }
}
