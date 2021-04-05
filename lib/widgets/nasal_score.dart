import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:tuallergycare/widgets/assess_warning.dart';

class NasalScore extends StatefulWidget {
  @override
  _NasalScoreState createState() => _NasalScoreState();
}

class _NasalScoreState extends State<NasalScore> {
    List<bool> _congestionLevel = [
    false,
    false,
    false,
    false,
  ];

  List<bool> _itchLevel = [
    false,
    false,
    false,
    false,
  ];

  List<bool> _runnyLevel = [
    false,
    false,
    false,
    false,
  ];

  List<bool> _sneezingLevel = [
    false,
    false,
    false,
    false,
  ];

  @override
  Widget build(BuildContext context) {
    return ExpandableNotifier(
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Container(
          child: Card(
            child: ScrollOnExpand(
              scrollOnExpand: true,
              scrollOnCollapse: true,
              child: ExpandablePanel(
                header: Padding(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    'อาการทางจมูก Total Nasal symptom score(TNSS)',
                    style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor),
                  ),
                ),
                collapsed: Container(),
                expanded: Container(
                  child: Column(
                    children: [
                      AssessWarning(),
                      SizedBox(
                        height: 20,
                      ),
                      buildToggleButton('คัดจมูก', _congestionLevel),
                      SizedBox(
                        height: 10,
                      ),
                      buildToggleButton('คันจมูก', _itchLevel),
                      SizedBox(
                        height: 10,
                      ),
                      buildToggleButton('จาม', _sneezingLevel),
                      SizedBox(
                        height: 10,
                      ),
                      buildToggleButton('น้ำมูกไหล', _runnyLevel),
                    ],
                  ),
                ),
                builder: (_, collapsed, expanded) {
                  return Padding(
                    padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
                    child: Expandable(
                      collapsed: collapsed,
                      expanded: expanded,
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildToggleButton(String title, List listValue) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            child: Text(
              title,
              style: TextStyle(fontSize: 27),
            ),
          ),
          Container(
            child: ToggleButtons(
              textStyle: TextStyle(
                fontSize: 30,
              ),
              fillColor: Theme.of(context).primaryColor,
              selectedColor: Colors.white,
              children: [
                Text(
                  '0',
                ),
                Text(
                  '1',
                ),
                Text(
                  '2',
                ),
                Text(
                  '3',
                ),
              ],
              onPressed: (int index) {
                setState(() {
                  for (int buttonIndex = 0;
                      buttonIndex < listValue.length;
                      buttonIndex++) {
                    if (buttonIndex == index) {
                      listValue[buttonIndex] = true;
                    } else {
                      listValue[buttonIndex] = false;
                    }
                  }
                });
              },
              isSelected: listValue,
            ),
          ),
        ],
      ),
    );
  }
}