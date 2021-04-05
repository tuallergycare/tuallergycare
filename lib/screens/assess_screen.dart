import 'package:flutter/material.dart';
import 'package:tuallergycare/widgets/conclude_score.dart';
import 'package:tuallergycare/widgets/nasal_score.dart';
import 'package:tuallergycare/widgets/ocular_score.dart';

class AssessScreen extends StatefulWidget {
  static const routeName = '/assessment';

  @override
  _AssessScreenState createState() => _AssessScreenState();
}

class _AssessScreenState extends State<AssessScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('แบบประเมินเมินเมินเมิน'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Container(
        width: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            children: [
              OcularScore(),
              NasalScore(),
              ConcludeScore(),
            ],
          ),
        ),
      ),
    );
  }
}
