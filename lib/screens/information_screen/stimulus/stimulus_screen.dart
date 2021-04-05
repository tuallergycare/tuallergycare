import 'package:flutter/material.dart';

class StimulusScreen extends StatelessWidget {
  static const routeName = '/stimulus-info';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tu Allergy Care'),
      ),
      body: Container(
        child: Text('Stinulus'),
      ),
    );
  }
}
