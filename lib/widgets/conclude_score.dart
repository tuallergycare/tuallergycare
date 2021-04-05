import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:tuallergycare/widgets/assess_warning.dart';

class ConcludeScore extends StatefulWidget {
  @override
  _ConcludeScoreState createState() => _ConcludeScoreState();
}

class _ConcludeScoreState extends State<ConcludeScore> {
  double _currentSliderValue = 0;
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
                    'โดยรวมแล้วอาการภูมิแพ้จมูกอักเสบวันนี้ รบกวนชีวิตประจำวันของท่านมากน้อยเพียงใด',
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
                      Slider(
                        activeColor: Theme.of(context).primaryColor,
                        value: _currentSliderValue,
                        min: 0,
                        max: 10,
                        divisions: 10,
                        label: _currentSliderValue.round().toString(),
                        onChanged: (double value) {
                          setState(() {
                            _currentSliderValue = value;
                          });
                        },
                      )
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
}
