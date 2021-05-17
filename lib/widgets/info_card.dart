import 'package:flutter/material.dart';

class InfoCard extends StatelessWidget {
  // the values we need
  final String text1;
  final String text2;
  //final IconData icon;
  Function onPressed;

  InfoCard(
      {@required this.text1, @required this.text2, @required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Card(
        color: Colors.white,
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
        child: ListTile(
          leading: Text(
            // icon,
            // color: Colors.teal,
            text1,
            style: TextStyle(
              color: Colors.teal,
              fontSize: 20,
            ),
          ),
          title: Text(
            text2,
            style: TextStyle(
              color: Colors.teal,
              fontSize: 20,
            ),
          ),
        ),
      ),
    );
  }
}
