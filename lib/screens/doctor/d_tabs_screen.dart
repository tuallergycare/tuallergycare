import 'package:flutter/material.dart';
import 'package:tuallergycare/screens/doctor/d_home_screen.dart';
import 'package:tuallergycare/screens/doctor/d_profile_screen.dart';
import 'package:tuallergycare/utility/style.dart';

class TabsDoctorScreen extends StatefulWidget {
  static const routeName = '/tabsdoctor';
  @override
  _TabsDoctorScreenState createState() => _TabsDoctorScreenState();
}

class _TabsDoctorScreenState extends State<TabsDoctorScreen> {
  List<Map<String, Object>> _pagesdoctor = [
    {'pagedoctor': DoctorHomeScreen(), 'title': 'home'},
    {'pagedoctor': DoctorProfileScreen(), 'title': 'profile'},
    
  ];

  int _selectedPageIndex = 0;

  void _selectPaged(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   toolbarHeight:10,
      //   // title: Text('Tu Allergy Care'),
      // ),
      body: _pagesdoctor[_selectedPageIndex]['pagedoctor'],
      backgroundColor: Colors.grey[300],
      bottomNavigationBar: BottomNavigationBar(
        onTap: _selectPaged,
        
        backgroundColor: Style().prinaryColor,
        unselectedItemColor: Colors.black,
        selectedItemColor: Theme.of(context).accentColor,
        showUnselectedLabels: true,
        currentIndex: _selectedPageIndex,
        // type: BottomNavigationBarType.shifting,
        items: [
          BottomNavigationBarItem(
            backgroundColor: Theme.of(context).primaryColor,
            icon: Icon(Icons.home),
            label: 'หน้าหลัก',
          ),
          BottomNavigationBarItem(
            backgroundColor: Theme.of(context).primaryColor,
            icon: Icon(Icons.account_circle),
            label: 'โปรไฟล์',
          ),
        ],
      ),
    );
  }
}