import 'package:flutter/material.dart';

class RadioButtonGroupWidget extends StatefulWidget {
  @override
  _RadioButtonGroupWidgetState createState() => _RadioButtonGroupWidgetState();
}

class _RadioButtonGroupWidgetState extends State<RadioButtonGroupWidget> {
  static const values = <String>['ชาย', 'หญิง'];
  
  String selectedValue = values.first;
  
  final selectedColor = Color(0xff006f69);
  final unselectedColor = Colors.black;

  @override
  Widget build(BuildContext context) => Container(
        // color: Colors.black,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
             buildRadios(),
            ],
          ),
        ),
      );

  Widget buildRadios() => Theme(
        data: Theme.of(context).copyWith(
          unselectedWidgetColor: unselectedColor,
        ),
        child:Column(
          children: values.map(
            (value) {
              final selected = this.selectedValue == value;
              final color = selected ? selectedColor : unselectedColor;

              return RadioListTile<String>(
                value: value,
                groupValue: selectedValue,
                title: Text(
                  value,
                  style: TextStyle(color: color),
                ),
                activeColor: selectedColor,
                onChanged: (value) =>
                    setState(() => this.selectedValue = value),
              );
            },
          ).toList(),
        ),
      );
}
