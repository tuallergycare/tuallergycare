import 'package:flutter/material.dart';

class MedicineInfoScreen extends StatelessWidget {
  static const routeName = '/medicine-info';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tu Allergy Care'),
      ),
      body: Container(
        child: Column(
          children: [
            Container(
              child: Column(
                children: [
                  Card(
                    elevation: 6,
                    child: Container(
                      height: 300,
                      width: double.infinity,
                      padding: EdgeInsets.fromLTRB(30, 20, 0, 0),
                      child: Column(
                        children: [
                          Text(
                            'Avamys®',
                            style: TextStyle(
                              fontSize: 35,
                              fontWeight: FontWeight.bold,
                              // color: Theme.of(context).primaryColor),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                            height: 150,
                            padding: EdgeInsets.all(15),
                            child: Image.asset('assets/images/Avamys.png',
                                fit: BoxFit.cover),
                          ),
                          Text("สำหรับรักษาอาการผิดปรกติทางจมูกน้ำมูกไหล คัดจมูก คันจมูก และจามจากโรคเยื่อบุจมูกอักเสบ จากภูมิแพ้ชนิดเป็นตลอดทั้งปีperenial allergic rhinitis: พ่นวันละ วิธีใช้ 1 ครั้ง หรือ วันละ 2 ครั้ง เช้า-เย็น"),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
