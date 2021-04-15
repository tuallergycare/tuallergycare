// import 'package:expandable/expandable.dart';
// import 'package:flutter/material.dart';
// import 'package:tuallergycare/widgets/assess_warning.dart';

// class NasalScore extends StatefulWidget {
//   @override
//   _NasalScoreState createState() => _NasalScoreState();
// }

// class _NasalScoreState extends State<NasalScore> {
//   List<bool> _congestionNasalLevel = [
//     false,
//     false,
//     false,
//     false,
//   ];

//   List<bool> _itchyNasalLevel = [
//     false,
//     false,
//     false,
//     false,
//   ];

//   List<bool> _runnyNasalLevel = [
//     false,
//     false,
//     false,
//     false,
//   ];

//   List<bool> _sneezingNasalLevel = [
//     false,
//     false,
//     false,
//     false,
//   ];

//   var _nasal = new Nasal();

//   bool _isNasalFinished = false;

//   bool _isNasalExpanded = false;

//   @override
//   Widget build(BuildContext context) {
//     return ExpandableNotifier(
//       controller: ExpandableController(initialExpanded: _isNasalExpanded),
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
//                     'อาการทางจมูก Total Nasal symptom score(TNSS)',
//                     style: TextStyle(
//                         fontSize: 25,
//                         fontWeight: FontWeight.bold,
//                         color: _isNasalFinished
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
//                         'คัดจมูก',
//                         _congestionNasalLevel,
//                       ),
//                       SizedBox(
//                         height: 10,
//                       ),
//                       buildToggleButton(
//                         'คันจมูก',
//                         _itchyNasalLevel,
//                       ),
//                       SizedBox(
//                         height: 10,
//                       ),
//                       buildToggleButton(
//                         'จาม',
//                         _sneezingNasalLevel,
//                       ),
//                       SizedBox(
//                         height: 10,
//                       ),
//                       buildToggleButton(
//                         'น้ำมูกไหล',
//                         _runnyNasalLevel,
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
//     List listValue,
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
//                     _nasal.setOcular(title, index);
//                   } else {
//                     listValue[buttonIndex] = false;
//                   }
//                 }

//                 if (_nasal.isFinished()) {
//                   _isNasalFinished = true;
//                   _isNasalExpanded = false;
//                 } else {
//                   _isNasalExpanded = true;
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

//   Nasal get getNasalLevel{
//     return _nasal;
//   }
// }

// class Nasal {
//   int congrestion;
//   int itchy;
//   int sneezing;
//   int runny;

//   void setOcular(String title, int value) {
//     if (title == 'คัดจมูก') {
//       congrestion = value;
//     } 
//     else if (title == 'คันจมูก') {
//       itchy = value;

//     }
//     else if (title == 'จาม') {
//       sneezing = value;
//     } 
//     else {
//       runny = value;
//     }
//   }

//   bool isFinished() {
//     if (itchy == null || sneezing == null || runny == null || congrestion == null) {
//       return false;
//     } else {
//       return true;
//     }
//   }
// }
