import 'package:flutter/material.dart';
import 'package:tuallergycare/screens/assess_screen.dart';
import 'package:tuallergycare/screens/auth_screen.dart';
import 'package:tuallergycare/screens/information_screen/medicine/medicine_screen.dart';
import 'package:tuallergycare/screens/information_screen/stimulus/stimulus_screen.dart';
import 'package:tuallergycare/screens/register_screen.dart';
import 'package:tuallergycare/screens/tabs_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.green,
        primaryColor: Color.fromRGBO(59, 155, 149, 1),
        accentColor: Colors.white,
      ),
      routes: {
        // '/': (ctx) => AuthScreen(),
        '/': (ctx) => AssessScreen(),
        TabsScreen.routeName: (ctx) => TabsScreen(),
        RegisterScreen.routeName: (ctx) => RegisterScreen(),
        MedicineScreen.routeName: (ctx) => MedicineScreen(),
        StimulusScreen.routeName: (ctx) => StimulusScreen(),
        // AssessScreen.routeName: (ctx) => AssessScreen(),
      },
    );
  }
}

// class MyHomePage extends StatefulWidget {
//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   final DateTime today = DateTime.now();
//   String day;
//   String month;
//   String year;

//   @override
//   Widget build(BuildContext context) {
//     switch (today.weekday) {
//       case 1:
//         day = 'วันจันทร์';
//         break;
//       case 2:
//         day = 'วันอังคาร';
//         break;
//       case 3:
//         day = 'วันพุธ';
//         break;
//       case 4:
//         day = 'วันพฤหัสบดี';
//         break;
//       case 5:
//         day = 'วันศุกร์';
//         break;
//       case 6:
//         day = 'วันเสาร์';
//         break;
//       case 7:
//         day = 'วันอาทิตย์';
//         break;
//       default:
//     }

//     switch (today.month) {
//       case 1:
//         month = 'มกราคม';
//         break;
//       case 2:
//         month = 'กุมภาพันธ์';
//         break;
//       case 3:
//         month = 'มีนาคม';
//         break;
//       case 4:
//         month = 'เมษายน';
//         break;
//       case 5:
//         month = 'พฤษภาคม';
//         break;
//       case 6:
//         month = 'มิถุนายน';
//         break;
//       case 7:
//         month = 'กรกฎาคม';
//         break;
//       case 8:
//         month = 'สิงหาคม';
//         break;
//       case 9:
//         month = 'กันยายน';
//         break;
//       case 10:
//         month = 'ตุลาคม';
//         break;
//       case 11:
//         month = 'พฤศจิกายน';
//         break;
//       case 12:
//         month = 'ธันวาคม';
//         break;
//       default:
//     }

//     year = (today.year + 543).toString();

//     return MaterialApp(
//       // body: Column(
//       //   // mainAxisAlignment: MainAxisAlignment.center,
//       //   children: <Widget>[
//       //     Container(
//       //       alignment: Alignment.topLeft,
//       //       margin: EdgeInsets.fromLTRB(20, 10, 0, 0),
//       //       child: Text(
//       //         'วัน${day}ที่ ${today.day} ${month} ${year}',
//       //         style: TextStyle(
//       //           fontSize: 16,
//       //           fontWeight: FontWeight.bold,
//       //         ),
//       //       ),
//       //     )
//       //   ],
//       // ),
//       // routes: {
//       //   '/': (ctx) => TabsScreen(),
//       // },
//       // This trailing comma makes auto-formatting nicer for build methods.
//     );
//   }
// }
