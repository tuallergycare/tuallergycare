import 'package:flutter/material.dart';
import 'package:tuallergycare/screens/assess_screen.dart';
import 'package:tuallergycare/screens/auth_screen.dart';
import 'package:tuallergycare/screens/information_screen/medicine/medicine_screen.dart';
import 'package:tuallergycare/screens/information_screen/stimulus/stimulus_screen.dart';
import 'package:tuallergycare/screens/register_screen.dart';
import 'package:tuallergycare/screens/tabs_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

void main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
  } catch (err) {
    print(err);
  }
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
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (ctx, userSnapshot) {
          try {
            if (userSnapshot.hasData) {
              return TabsScreen();
            }
            return AuthScreen();
          } catch (err, stacktrace) {
            print(stacktrace);
            return Container(
              child: Text('err'),
            );
          }
        },
      ),
      routes: {
        // '/': (ctx) => AuthScreen(),
        // '/': (ctx) => AssessScreen(),
        // AuthScreen.routeName: (ctx) => AuthScreen(),
        // TabsScreen.routeName: (ctx) => TabsScreen(),
        RegisterScreen.routeName: (ctx) => RegisterScreen(),
        MedicineScreen.routeName: (ctx) => MedicineScreen(),
        StimulusScreen.routeName: (ctx) => StimulusScreen(),
        AssessScreen.routeName: (ctx) => AssessScreen(),
      },
    );
  }
}
