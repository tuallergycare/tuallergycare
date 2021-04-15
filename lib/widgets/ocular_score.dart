// import 'package:expandable/expandable.dart';
// import 'package:flutter/material.dart';
// import 'package:tuallergycare/widgets/assess_warning.dart';

// class OcularScore extends StatefulWidget {
//   @override
//   _OcularScoreState createState() => _OcularScoreState();
// }

// class _OcularScoreState extends State<OcularScore> {
//   List<bool> _itchyOcularLevel = [
//     false,
//     false,
//     false,
//     false,
//   ];

//   List<bool> _redOcularLevel = [
//     false,
//     false,
//     false,
//     false,
//   ];

//   List<bool> _tearingOcularLevel = [
//     false,
//     false,
//     false,
//     false,
//   ];

//   var _ocular = new Ocular();

//   bool _isOcularFinished = false;

//   bool _isOcularExpanded = false;


//   @override
//   Widget build(BuildContext context) {
//     return ExpandableNotifier(
//       controller: ExpandableController(initialExpanded: _isOcularExpanded),
//       child: Padding(
//         padding: EdgeInsets.all(10),
//         child: Container(
//           child: Card(
//             child: ScrollOnExpand(
//               scrollOnExpand: true,
//               scrollOnCollapse: true,
//               child: ExpandablePanel(
//                 header: Padding(
//                   padding: EdgeInsets.all(10),
//                   child: Text(
//                     'อาการทางตา Tatal Ocular symptom score(TOSS)',
//                     style: TextStyle(
//                         fontSize: 25,
//                         fontWeight: FontWeight.bold,
//                         color: _isOcularFinished
//                             ? Theme.of(context).primaryColor
//                             : Colors.black),
//                   ),
//                 ),
//                 collapsed: Container(),
//                 expanded: Container(
//                   child: Column(
//                     children: [
//                       AssessWarning(),
//                       SizedBox(
//                         height: 20,
//                       ),
//                       buildToggleButton(
//                         'ระคายเคืองตา',
//                         _itchyOcularLevel,
//                       ),
//                       SizedBox(
//                         height: 10,
//                       ),
//                       buildToggleButton(
//                         'ตาแดง',
//                         _redOcularLevel,
//                       ),
//                       SizedBox(
//                         height: 10,
//                       ),
//                       buildToggleButton(
//                         'น้ำตาไหล',
//                         _tearingOcularLevel,
//                       ),
//                     ],
//                   ),
//                 ),
//                 builder: (_, collapsed, expanded) {
//                   return Padding(
//                     padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
//                     child: Expandable(
//                       collapsed: collapsed,
//                       expanded: expanded,
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget buildToggleButton(
//     String title,
//     List<bool> listValue,
//   ) {
//     return Container(
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Container(
//             child: Text(
//               title,
//               style: TextStyle(fontSize: 27),
//             ),
//           ),
//           Container(
//             child: ToggleButtons(
//               textStyle: TextStyle(
//                 fontSize: 30,
//               ),
//               fillColor: Theme.of(context).primaryColor,
//               selectedColor: Colors.white,
//               children: [
//                 Text(
//                   '0',
//                 ),
//                 Text(
//                   '1',
//                 ),
//                 Text(
//                   '2',
//                 ),
//                 Text(
//                   '3',
//                 ),
//               ],
//               onPressed: (int index) {
//                 for (int buttonIndex = 0;
//                     buttonIndex < listValue.length;
//                     buttonIndex++) {
//                   if (buttonIndex == index) {
//                     listValue[buttonIndex] = true;
//                     _ocular.setOcular(title, index);
//                   } else {
//                     listValue[buttonIndex] = false;
//                   }
//                 }

//                 if (_ocular.isFinished()) {
//                   _isOcularFinished = true;
//                   _isOcularExpanded = false;
//                 }else{
//                   _isOcularExpanded = true;
//                 }

//                 setState(() {});
//               },
//               isSelected: listValue,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class Ocular {
//   int itchy;
//   int red;
//   int tearing;

//   Map<String, int> _ocular;


//   void setOcular(String title, int value) {
//     if (title == 'ระคายเคืองตา') {
//       itchy = value;
//       // _ocular.addAll({'ระคายเคืองตา': value});
//     }
//     else if (title == 'ตาแดง') {
//       red = value;
//       // _ocular.addAll({'ตาแดง': value});
//     }else {
//       tearing = value;
//       // _ocular.addAll({'ระคายเคือง': value});
//     }
//   }

//   bool isFinished() {
//     if (itchy == null || red == null || tearing == null) {
//       return false;
//     } else {
//       return true;
//     }
//   }

//   Map<String, int> get getOcularLevel {
//     return {..._ocular};
//   }
// }
