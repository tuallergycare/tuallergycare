import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_wrapper.dart';
import 'package:responsive_framework/utils/scroll_behavior.dart';
import 'package:tuallergycare/screens/assess_screen.dart';
import 'package:tuallergycare/screens/auth_screen.dart';
import 'package:tuallergycare/screens/doctor/d_adddrug_screen.dart';
import 'package:tuallergycare/screens/doctor/d_appointment.dart';
import 'package:tuallergycare/screens/doctor/d_diagnose.dart';
import 'package:tuallergycare/screens/doctor/d_drugoral.dart';
import 'package:tuallergycare/screens/doctor/d_drugspay.dart';
import 'package:tuallergycare/screens/doctor/d_editprofilescreen.dart';
import 'package:tuallergycare/screens/doctor/d_form_screen.dart';
import 'package:tuallergycare/screens/doctor/d_home_screen.dart';
import 'package:tuallergycare/screens/doctor/d_patientprofile_screen.dart';
import 'package:tuallergycare/screens/doctor/d_profile_screen.dart';
import 'package:tuallergycare/screens/doctor/d_qrcode.dart';
import 'package:tuallergycare/screens/doctor/d_skintest.dart';
import 'package:tuallergycare/screens/doctor/d_tabs_screen.dart';
import 'package:tuallergycare/screens/edit_profile_screen.dart';
import 'package:tuallergycare/screens/first_assess_screen.dart';
import 'package:tuallergycare/screens/graph_screen.dart';
import 'package:tuallergycare/screens/information_screen/medicine/medicine_info_screen.dart';
import 'package:tuallergycare/screens/information_screen/stimulus/stimulus_screen.dart';
import 'package:tuallergycare/screens/medicine_screen.dart';
import 'package:tuallergycare/screens/proflie_screen.dart';
import 'package:tuallergycare/screens/register_screen.dart';
import 'package:tuallergycare/screens/select_user_screen.dart';
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

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var currentPatient = FirebaseAuth.instance.currentUser;

  var isFirstLogin;
  var checkIdPatient;
  var checkIdDoctor;

  void initState() {
    super.initState();
  }

  Future<void> checkFirstLogin(User currentUser) async {
    print('inCheck');
    await FirebaseFirestore.instance
        .collection('patients')
        .doc(currentUser.uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      print(documentSnapshot.id);
      checkIdPatient = documentSnapshot.exists;
      print('inPa: $checkIdPatient');
    });

    // await FirebaseFirestore.instance
    //     .collection('patients')
    //     .get().then((QuerySnapshot querySnapshot) {
    //       querySnapshot.docs.forEach((doc) {
    //         doc
    //        });
    //     });

    await FirebaseFirestore.instance
        .collection('doctors')
        .doc(currentUser.uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      print(documentSnapshot.id);
      checkIdDoctor = documentSnapshot.exists;
      print('inDoc $checkIdDoctor');
    });
    //     .then((QuerySnapshot querySnapshot) {
    //   querySnapshot.docs.forEach((doc) {
    //     doc.
    //   });
    // });
    if (checkIdPatient == true && checkIdDoctor != true) {
      await FirebaseFirestore.instance
          .collection('patients')
          .doc(currentUser.uid)
          .get()
          .then((DocumentSnapshot documentSnapshot) {
        if (documentSnapshot['isFirstLogin'] == true) {
          print('waitTrue');
          isFirstLogin = true;
          print('setTrue');
        } else {
          isFirstLogin = false;
          print('setFalse');
        }
      });
    }
  }

  void checkLogin() async {
    await FirebaseAuth.instance.currentUser.reload();
    print(currentPatient);
  }

  // Future<Widget> decidePage() async{
  //   await checkFirstLogin();
  //   print('2FirstLog: $isFirstLogin');
  //   if(isFirstLogin == true){
  //     return FirstAssessScreen();
  //   }else{
  //     return TabsScreen();
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: (context, widget) => ResponsiveWrapper.builder(
        BouncingScrollWrapper.builder(context, widget),
          maxWidth: 1200,
          minWidth: 450,
          defaultScale: true,
          breakpoints: [
            ResponsiveBreakpoint.autoScale(600),
            // ResponsiveBreakpoint.resize(450, name: MOBILE),
            // ResponsiveBreakpoint.autoScale(800, name: TABLET),
            // ResponsiveBreakpoint.autoScale(1000, name: TABLET),
            // ResponsiveBreakpoint.resize(1200, name: DESKTOP),
            // ResponsiveBreakpoint.autoScale(2460, name: "4K"),
          ]
      ),
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.green,
        primaryColor: Color.fromRGBO(59, 155, 149, 1),
        accentColor: Colors.white,
      ),
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (ctx, userSnapshot) {
          // print('userIn: ${userSnapshot.hasData}');
          // if (userSnapshot.connectionState == ConnectionState.waiting) {
          //   return Center(
          //     child: CircularProgressIndicator(),
          //   );
          // }
          try {
            if (userSnapshot.hasData) {
              currentPatient = FirebaseAuth.instance.currentUser;
              print('Shapshot: ${userSnapshot.connectionState}');
              print('CurrentUser: ${currentPatient.metadata}');
              // checkLogin();
              // checkFirstLogin(currentPatient);

              // print('1isFirestlog: $isFirstLogin');
              // if (isFirstLogin == true) {
              //   return FirstAssessScreen();
              // }
              // return TabsScreen();

              // if (currentPatient != null) {
              //   checkFirstLogin();
              //   print('1isFirestlog: $isFirstLogin');
              //   if (isFirstLogin == true) {
              //     return FirstAssessScreen();
              //   }
              //   return TabsScreen();
              // }
              return FutureBuilder(
                  future: checkFirstLogin(currentPatient),
                  builder: (context, futureSnapshot) {
                    print(futureSnapshot.connectionState);
                    print('checkIdPaIn: $checkIdPatient');
                    print('checkIdDocIn: $checkIdDoctor');
                    if (futureSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return Scaffold(
                        body: Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }
                    if (checkIdPatient) {
                      if (isFirstLogin == true) {
                        // print('isfffffffffff: $isFirstLogin');
                        isFirstLogin = false;
                        return FirstAssessScreen();
                      }
                      // print('isfffffffffff: $isFirstLogin');
                      return TabsScreen();
                    } else if (checkIdDoctor) {
                      return TabsDoctorScreen();
                    }
                  });
              // checkFirstLogin().then((value) {
              //   print('isFirestlog: $isFirstLogin');
              //   if (isFirstLogin == true) {
              //     print('innnnnnnnnnnnnn');
              //     return FirstAssessScreen();
              //   }else{
              //     print('gggggggggggg');
              // return TabsScreen();
              //   }
              // });
              // checkFirstLogin();
              // print('1isFirestlog: $isFirstLogin');
              // if (isFirstLogin == true) {
              //   return FirstAssessScreen();
              // }
              // return TabsScreen();
            }
            print('comebackToLog');
            return AuthScreen();
          } catch (err, stacktrace) {
            print('error');
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
        MedicineScreen.routeName: (ctx) => MedicineScreen(),
        AuthScreen.routeName: (ctx) => AuthScreen(),
        TabsScreen.routeName: (ctx) => TabsScreen(),
        FirstAssessScreen.routeName: (ctx) => FirstAssessScreen(),
        RegisterScreen.routeName: (ctx) => RegisterScreen(),
        MedicineInfoScreen.routeName: (ctx) => MedicineInfoScreen(),
        StimulusScreen.routeName: (ctx) => StimulusScreen(),
        AssessScreen.routeName: (ctx) => AssessScreen(),
        ProfileScreen.routeName: (ctx) => ProfileScreen(),
        EditProfileScreen.routeName: (ctx) => EditProfileScreen(),
        SelectUserScreen.routeName: (ctx) => SelectUserScreen(),
        DoctorFormScreen.routeName: (ctx) => DoctorFormScreen(),
        TabsDoctorScreen.routeName: (ctx) => TabsDoctorScreen(),
        DoctorHomeScreen.routeName: (ctx) => DoctorHomeScreen(),
        DoctorProfileScreen.routeName: (ctx) => DoctorProfileScreen(),
        DoctorEditProfileScreen.routeName: (ctx) => DoctorEditProfileScreen(),
        PatientProfileScreen.routeName: (ctx) => PatientProfileScreen(),
        AddDrugScreen.routeName: (ctx) => AddDrugScreen(),
        AddSkinTestScreen.routeName: (ctx) => AddSkinTestScreen(),
        DrugOral.routeName: (ctx) => DrugOral(),
        DrugSpay.routeName: (ctx) => DrugSpay(),
        Diagnose.routeName: (ctx) => Diagnose(),
        Appointment.routeName: (ctx) => Appointment(),
        GraphScreen.routeName: (ctx) => GraphScreen(),
        Scanner.routeName: (ctx) => Scanner(),
      },
    );
  }
}
