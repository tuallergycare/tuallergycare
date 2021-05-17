import 'package:flutter/material.dart';
import 'package:tuallergycare/screens/home_screen.dart';
import 'package:tuallergycare/screens/information_screen/information_screen.dart';
import 'package:tuallergycare/screens/proflie_screen.dart';

class TabsScreen extends StatefulWidget {
  static const routeName = '/tabs';
  @override
  _TabsScreenState createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  List<Map<String, Object>> _pages = [
    {'page': HomeScreen(), 'title': 'home'},
    // {'page': ProfileScreen(), 'title': 'home'},
    {'page': InformationScreen(), 'title': 'information'},
    {'page': HomeScreen(), 'title': 'graph'},
    {'page': ProfileScreen(), 'title': 'profile'},
  ];

  int _selectedPageIndex = 0;

  void _selectPage(int index) {
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
      body: _pages[_selectedPageIndex]['page'],
      backgroundColor: Colors.grey[300],
      bottomNavigationBar: BottomNavigationBar(
        onTap: _selectPage,
        backgroundColor: Theme.of(context).primaryColor,
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
            icon: Icon(Icons.book),
            label: 'ข้อมูล',
          ),
          BottomNavigationBarItem(
            backgroundColor: Theme.of(context).primaryColor,
            icon: Icon(Icons.poll),
            label: 'กราฟ',
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