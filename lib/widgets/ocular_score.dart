import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:tuallergycare/widgets/assess_warning.dart';

class OcularScore extends StatefulWidget {
  @override
  _OcularScoreState createState() => _OcularScoreState();
}

class _OcularScoreState extends State<OcularScore> {
  List<bool> _itchyLevel = [
    false,
    false,
    false,
    false,
  ];

  List<bool> _redLevel = [
    false,
    false,
    false,
    false,
  ];

  List<bool> _tearingLevel = [
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
                    'อาการทางตา Tatal Ocular symptom score(TOSS)',
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
                      buildToggleButton('ระคายเคืองตา', _itchyLevel),
                      SizedBox(
                        height: 10,
                      ),
                      buildToggleButton('ตาแดง', _redLevel),
                      SizedBox(
                        height: 10,
                      ),
                      buildToggleButton('น้ำตาไหล', _tearingLevel),
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
