import 'package:flutter/material.dart';

class AssessWarning extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text("หมายเหตุ\n0:ไม่มีอาการเลย\n1:มีอาการเล็กน้อยไม่ก่อปัญหา\n2:มีอาการปานกลาง สร้างความรำคาญแต่ไม่กระทบชีวิตประจำวัน\n3:มีอาการมาก กระทบชีวิตประจำวัน",softWrap: true,),
    );
  }
}