
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tuallergycare/widgets/button_widget.dart';

class DatePickerWidget extends StatefulWidget {
  @override
  _DatePickerWidgetState createState() => _DatePickerWidgetState();
}

class _DatePickerWidgetState extends State<DatePickerWidget> {
  DateTime date;

  String getText() {
    if (date == null) {
      return 'กรุณาเลือกวันเกิด';
    } else {
      return DateFormat('MM/dd/yyyy').format(date);
      // return '${date.month}/${date.day}/${date.year}';
    }
  }

  @override
  Widget build(BuildContext context) => ButtonHeaderWidget(
        title: 'วันเกิด',
        text: getText(),
        onClicked: () => pickDate(context),
      );

  Future pickDate(BuildContext context) async {
    final initialDate = DateTime.now();
    final newDate = await showDatePicker(
      context: context,
      initialDate: date ?? initialDate,
      firstDate: DateTime(DateTime.now().year -100),
      lastDate: DateTime(DateTime.now().year +100),
    );

    if (newDate == null) return;

    setState(() => date = newDate);
  }
}