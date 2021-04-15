library material_buttonx;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// A Calculator.
// class Calculator {
//   /// Returns [value] plus 1.
//   int addOne(int value) => value + 1;
// }

class ButtonHome extends StatelessWidget {
  final String message;
  final double height;
  final double width;
  final Color color;
  final double iconSize;
  final IconData icon;
  final Function onClick;
  final double radius;

  const ButtonHome(
      {Key key,
      this.message,
      this.height,
      this.width,
      this.color,
      this.iconSize,
      this.icon,
      this.onClick,
      this.radius})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onHover: (value) => null,
      hoverColor: Colors.black26,
      onTap: onClick,
      child: Container(
        
        child: Stack(
          children: [
            Container(
              //alignment: Alignment.center,
              width: width * 0.95,
              height: height,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(height),
                  topLeft: Radius.circular(height),
                  topRight: Radius.circular(height),
                  bottomRight: Radius.circular(height),
                ),
              ),

              padding: const EdgeInsets.fromLTRB(120, 32, 0, 0),
              child: Text(
                "${message}",
                style: 
                TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).accentColor),
                // Theme.of(context)
                //     .textTheme
                //     .headline6
                //     .copyWith(color: Colors.white),
              ),
            ),

            Positioned(
              top: 8.0,
              bottom: 8.0,
              left: 40.0,
              child: Icon(
                icon,
                size: iconSize,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
