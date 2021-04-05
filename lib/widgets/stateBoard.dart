import 'package:flutter/material.dart';

class StateBoard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 170,
      color: Theme.of(context).primaryColor,
      padding: EdgeInsets.only(top: 50),
      child: Container(
              child: Container(
                child: Row(
                  children: [
                    Container(
                        margin: EdgeInsets.fromLTRB(25, 0, 0, 10),
                        height: 100,
                        // padding: EdgeInsets.all(15),
                        child: Image.asset('assets/images/sad.png',
                            fit: BoxFit.cover)),
                    Container(
                      margin: EdgeInsets.fromLTRB(30, 0, 0, 0),
                      child: Column(
                        children: [
                          SizedBox(height: 10,),
                          Container(
                            child: Text(
                              'สถานะของผู้ป่วย T1',
                              style: TextStyle(
                                // fontWeight: FontWeight.bold,
                                fontSize: 28,
                                color: Theme.of(context).accentColor,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          Container(
                            child: Text(
                              'ผู้ป่วยควรใช้ยาอย่างต่อเนื่อง',
                              style: TextStyle(
                                // fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Theme.of(context).accentColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}