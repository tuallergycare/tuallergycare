import 'package:flutter/material.dart';
import 'package:tuallergycare/utility/style.dart';

class AddSkinTestScreen extends StatefulWidget {
  static const routeName = '/addskintestscreen';
  AddSkinTestScreen({Key key}) : super(key: key);

  @override
  _AddSkinTestScreenState createState() => _AddSkinTestScreenState();
}

class _AddSkinTestScreenState extends State<AddSkinTestScreen> {
  List<String> selectedSkintestList = [];
  List<String> skintestList = [
    "Acaia",
    "American cockroaches",
    "Bermuda grass",
    "Blomia tropicalis",
    "Cat",
    "Df",
    "Dog",
    "Dp",
    "German cockroaches",
    "Ragweed",
    "Timothy grass",
  ];

  _showSkintestDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Skin Test"),
            content: MultiSelectChip(
              skintestList,
              onSelectionChanged: (selectedList) {
                setState(() {
                  selectedSkintestList = selectedList;
                });
              },
            ),
            // actions: <Widget>[
              
            //   TextButton(
            //     child: Text(
            //       "บันทึก",
            //       style: TextStyle(
            //         color: Style().prinaryColor,
            //       ),
            //     ),
            //     onPressed: () {
            //       selectedSkintestList.forEach((element) { print(element);});
            //     },
            //   )
            // ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('skintest'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(selectedSkintestList.join("\n")),
            RaisedButton(
              child: Text("แก้ไข"),
              onPressed: () => _showSkintestDialog(),
            ),
          ],
        ),
      ),
    );
  }
}

class MultiSelectChip extends StatefulWidget {
  final List<String> skintestList;
  final Function(List<String>) onSelectionChanged;

  MultiSelectChip(this.skintestList, {this.onSelectionChanged});

  @override
  _MultiSelectChipState createState() => _MultiSelectChipState();
}

class _MultiSelectChipState extends State<MultiSelectChip> {
  List<String> selectedChoices = [];
  _buildSkintextSelectList() {
    List<Widget> choices = [];
    widget.skintestList.forEach((item) {
      choices.add(Container(
        padding: const EdgeInsets.all(2.0),
        child: ChoiceChip(
          label: Text(item),
          labelStyle: TextStyle(color: Colors.black, fontSize: 16.0),
          selected: selectedChoices.contains(item),
          onSelected: (selected) {
            setState(() {
              selectedChoices.contains(item)
                  ? selectedChoices.remove(item)
                  : selectedChoices.add(item);
              widget.onSelectionChanged(selectedChoices);
            });
          },
          selectedColor: Style().prinaryColor,
        ),
      ));
    });
    return choices;
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: _buildSkintextSelectList(),
    );
  }
}
