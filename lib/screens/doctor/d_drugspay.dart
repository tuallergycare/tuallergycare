import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tuallergycare/screens/doctor/d_adddrug_screen.dart';
import 'package:tuallergycare/utility/style.dart';

class DrugSpay extends StatefulWidget {
  static const routeName = '/drugspray';
  DrugSpay({Key key}) : super(key: key);

  @override
  _DrugSpayState createState() => _DrugSpayState();
}

class _DrugSpayState extends State<DrugSpay> {
  var patientId;
  String _quantityspray;
  String _selectedspray;
  String _image;
  List<Map> spraydrug = [
    {"id": '1', "image": "assets/images/avamys.png", "name": "Avamys®"},
    {"id": '2', "image": "assets/images/dymista.jpeg", "name": "Dymista®"},
    {"id": '3', "image": "assets/images/nasonex.jpeg", "name": "Nasonex®"},
  ];
  String timeusespray;

  Map time = {
    'morning_dose': false,
    'evening_dose': false,
  };

  Map check = {
    'check_take_morning': false,
    'check_take_evening': false,
    'check_take_before_bed': false,
  };

  @override
  Widget build(BuildContext context) {
    patientId = ModalRoute.of(context).settings.arguments as String;
    return Scaffold(
      appBar: AppBar(
        title: const Text('เพิ่มการใช้ยา'),
      ),
      body: SingleChildScrollView(
        child: Container(
          //child: Center(
          child: Column(
            //mainAxisAlignment: MainAxisAlignment.center,
            //crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              SizedBox(
                height: 10,
              ),
              Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  'ข้อมูลยา',
                  style: TextStyle(fontSize: 20, color: Style().prinaryColor),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 20),
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                    border: Border.all(width: 1, color: Colors.grey),
                    borderRadius: BorderRadius.circular(15)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      child: DropdownButtonHideUnderline(
                        child: ButtonTheme(
                          alignedDropdown: true,
                          child: DropdownButton<String>(
                            isDense: true,
                            hint: new Text(
                              "ชื่อยาสำหรับพ่น",
                              style: TextStyle(fontSize: 18),
                            ),
                            value: _selectedspray,
                            onChanged: (String newValue) {
                              setState(() {
                                _selectedspray = newValue;
                                var drug = spraydrug.firstWhere((element) =>
                                    element['name'] == _selectedspray);
                                _image = drug['image'];
                              });
                              print(_selectedspray);
                            },
                            items: spraydrug.map((Map map) {
                              return new DropdownMenuItem<String>(
                                value: map["name"].toString(),
                                child: Row(
                                  children: <Widget>[
                                    Image.asset(
                                      map["image"],
                                      fit: BoxFit.cover,
                                      width: 30,
                                      height: 30,
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(left: 10),
                                      child: Text(
                                        map["name"],
                                        style: TextStyle(
                                          color: Style().darkColor,
                                          fontSize: 18,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // SizedBox(
              //   height: 10,
              // ),
              Container(
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.only(top: 16),
                child: Column(
                  children: <Widget>[
                    Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'จำนวนกด',
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ),
                    ListTile(
                      title: const Text('1'),
                      leading: Radio(
                        activeColor: Theme.of(context).primaryColor,
                        value: '1',
                        groupValue: _quantityspray,
                        onChanged: (value) {
                          setState(() {
                            _quantityspray = value;
                          });
                          print(_quantityspray);
                        },
                      ),
                    ),
                    ListTile(
                      title: const Text('2'),
                      leading: Radio(
                        activeColor: Theme.of(context).primaryColor,
                        value: '2',
                        groupValue: _quantityspray,
                        onChanged: (value) {
                          setState(() {
                            _quantityspray = value;
                          });
                          print(_quantityspray);
                        },
                      ),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 15,
                ),
                child: Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "ช่วงเวลา",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              CheckboxListTile(
                title: Text("เช้า"),
                value: time['morning_dose'],
                onChanged: (newValue) {
                  setState(() {
                    time['morning_dose'] = newValue;
                  });
                },
                controlAffinity: ListTileControlAffinity.leading,
                activeColor: Theme.of(context).primaryColor,
              ),
              CheckboxListTile(
                title: Text("เย็น"),
                value: time['evening_dose'],
                onChanged: (newValue) {
                  setState(() {
                    time['evening_dose'] = newValue;
                  });
                },
                controlAffinity: ListTileControlAffinity.leading,
                activeColor: Theme.of(context).primaryColor,
              ),
              SizedBox(
                height: 10,
              ),
              RaisedButton(
                child: Text(
                  'ยืนยัน',
                  style: TextStyle(color: Colors.white),
                ),
                color: Style().prinaryColor,
                onPressed: () async {
                  var hasCheck = time.containsValue(true);
                  if (_selectedspray == null ||
                      _quantityspray == null ||
                      _image == null ||
                      hasCheck == false) {
                    await showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('กรุณากรอกข้อมูลให้ครบ'),
                        // content: Text('Something went wrong.'),
                        actions: <Widget>[
                          TextButton(
                            child: Text(
                              'ตกลง',
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                              return;
                            },
                          )
                        ],
                      ),
                    );
                  }

                  await FirebaseFirestore.instance
                      .collection('patients')
                      .doc(patientId)
                      .collection('medicines')
                      .add({
                    'name_medicine': _selectedspray,
                    'type_medicine': 'inhalers',
                    'image': _image,
                    'time_to_take': time,
                    'num_of_press': _quantityspray,
                    'check_current_take': check,
                  });

                  Navigator.pop(context);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
      //  ),
    );
  }
}
