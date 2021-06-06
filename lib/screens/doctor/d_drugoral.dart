import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tuallergycare/screens/doctor/d_adddrug_screen.dart';
import 'package:tuallergycare/utility/style.dart';

class DrugOral extends StatefulWidget {
  static const routeName = '/drugoral';
  @override
  _DrugOralState createState() => _DrugOralState();
}

class _DrugOralState extends State<DrugOral> {
  String patientId;
  String _quantity;
  String _dose;
  String _selectedoraldrug;
  String _image;
  var hasCheck = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Map time = {
    'morning_dose': false,
    'evening_dose': false,
    'before_bed_dose': false,
  };

  Map check = {
    'check_take_morning': false,
    'check_take_evening': false,
    'check_take_before_bed': false,
  };

  List<Map> oraldrug = [
    {"id": '1', "image": "assets/images/zyrtec.png", "name": "Zyrtec®"},
    {"id": '2', "image": "assets/images/allernix.png", "name": "Allernix®"},
    {"id": '3', "image": "assets/images/telfast.png", "name": "Telfast®"},
    {
      "id": '4',
      "image": "assets/images/xyzal.png",
      "name": "Levocetirizine Xyzal®"
    },
    {
      "id": '5',
      "image": "assets/images/aerius.png",
      "name": "Desloratadine Aerius®"
    },
    {
      "id": '6',
      "image": "assets/images/bilaxten.jpeg",
      "name": "Bilastine Bilaxten®"
    },
  ];

  @override
  Widget build(BuildContext context) {
    patientId = ModalRoute.of(context).settings.arguments as String;
    print('checkMorning ${time['morning_dose']}');
    print('checkEvening ${time['evening_dose']}');
    print('checkBeforeBed ${time['before_bed_dose']}');
    return Scaffold(
      appBar: AppBar(
        title: const Text('เพิ่มการใช้ยา'),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Center(
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
                                "ชื่อยาสำหรับรับประทาน",
                                style: TextStyle(fontSize: 18),
                              ),
                              value: _selectedoraldrug,
                              onChanged: (String newValue) {
                                setState(() {
                                  _selectedoraldrug = newValue;
                                  var drug = oraldrug.firstWhere((element) =>
                                      element['name'] == _selectedoraldrug);
                                  _image = drug['image'];
                                });
                                print(_selectedoraldrug);
                              },
                              items: oraldrug.map((Map map) {
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
                Container(
                  margin: EdgeInsets.only(top: 10),
                  padding: EdgeInsets.all(15),
                  child: Form(
                    key: _formKey,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "ปริมาณ",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                        Row(
                          children: [
                            SizedBox(
                              //height: 20,
                              width: 65,
                              child: TextFormField(
                                keyboardType: TextInputType.phone,
                                validator: (String value) {
                                  if (value.isEmpty) {
                                    return 'กรุณาใส่ปริมาณ';
                                  }
                                  return null;
                                },
                                onSaved: (String value) {
                                  _dose = value;
                                },
                              ),
                            ),
                            Text(
                              "mg",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10),
                  padding: EdgeInsets.all(15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        "รับประทานครั้งละ",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        child: DropdownButton<String>(
                          value: _quantity,
                          elevation: 3,
                          style: TextStyle(color: Style().darkColor),
                          items: <String>[
                            '-',
                            '1',
                            '2',
                            '3',
                          ].map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          hint: Text(
                            "---",
                            style:
                                TextStyle(color: Colors.black54, fontSize: 16),
                          ),
                          onChanged: (String value) {
                            setState(() {
                              _quantity = value;
                            });
                          },
                        ),
                      ),
                      Text(
                        "เม็ด",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 15,
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
                CheckboxListTile(
                  title: Text("ก่อนนอน"),
                  value: time['before_bed_dose'],
                  onChanged: (newValue) {
                    setState(() {
                      time['before_bed_dose'] = newValue;
                    });
                  },
                  controlAffinity: ListTileControlAffinity.leading,
                  activeColor: Theme.of(context).primaryColor,
                ),
                ElevatedButton(
                  child: Text(
                    'ยืนยัน',
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          Theme.of(context).primaryColor)),
                  onPressed: () async {
                    if (!_formKey.currentState.validate()) {
                      return;
                    }
                    _formKey.currentState.save();
                    hasCheck = time.containsValue(true);
                    print('hasCheck:c $hasCheck');
                    print(_selectedoraldrug);
                    print(_dose);
                    print(_image);
                    print(_quantity);

                    if (_selectedoraldrug == null ||
                        _dose == null ||
                        _image == null ||
                        _quantity == null ||
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

                    int numTime = 0;
                    time.forEach((key, value) {
                      if (value == true) {
                        numTime++;
                      }
                    });

                    print('num time: $numTime');

                    await FirebaseFirestore.instance
                        .collection('patients')
                        .doc(patientId)
                        .collection('medicines')
                        .add({
                      'name_medicine': _selectedoraldrug,
                      'type_medicine': 'tablet',
                      'dose': _dose,
                      'image': _image,
                      'time_to_take': time,
                      'take_per_time': _quantity,
                      'take_per_day:': numTime.toString(),
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
      ),
    );
  }
}
