import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';

class StimulusScreen extends StatefulWidget {
  static const routeName = '/stimulus-info';

  @override
  _StimulusScreenState createState() => _StimulusScreenState();
}

class _StimulusScreenState extends State<StimulusScreen> {
  @override
  Widget buildStimulus(String title, String description) {
    return ExpandableNotifier(
                      controller: ExpandableController(initialExpanded: false),
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Container(
                          child: Card(
                            child: ScrollOnExpand(
                              scrollOnExpand: true,
                              scrollOnCollapse: true,
                              child: ExpandablePanel(
                                header: Padding(
                                  padding: EdgeInsets.all(10),
                                  child: Text(title,
                                      style: TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold,
                                        // color: _isOcularFinished
                                        //     ? Theme.of(context).primaryColor
                                        //     : Colors.black),
                                        color: Theme.of(context).primaryColor,
                                      )),
                                ),
                                collapsed: Container(),
                                expanded: Container(
                                  child: Column(
                                    children: [
                                      Container(
                                          child: Text(
                                        description,
                                        style: TextStyle(
                                          fontSize: 15,
                                        ),
                                      )),
                                    ],
                                  ),
                                ),
                                builder: (_, collapsed, expanded) {
                                  return Padding(
                                    padding: EdgeInsets.only(
                                        left: 10, right: 10, bottom: 10),
                                    child: Expandable(
                                      collapsed: collapsed,
                                      expanded: expanded,
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('วิธีการหลีกเลี่ยงสิ่งกระตุ้น'),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              buildStimulus('การลดปริมาณไรฝุ่น', '• ซักปลอกหมอน ผ้าปูที่นอน ทุก 1-2 สัปดาห์ ด้วยน้ำร้อน 55-60°C เพื่อฆ่าไรฝุ่น และใช้ผ้า คลุมกันไรฝุ่น\n• มีการระบายอากาศที่เพียงพอเพื่อลดความชื้น• ใช้เครื่องดูดฝุ่นที่มีคุณภาพดี ถ้าเป็นไปได้ควรใช้เครื่องที่มี HEPA filter ด้วย\n• ทำความสะอาดบ้านด้วยผ้าชุบน้ำหมาด\n• ไม่ควรปูพรม ไม่ควรใช้เฟอร์นิเจอร์ที่หุ้มด้วยผ้า และผ้าม่านในห้องนอน\n• ไม่ควรเก็บของเล่นในห้องนอน และควรทำความสะอาดด้วยน้ำร้อน 55-60°C หรือแช่แข็ง เพื่อฆ่าไรฝุ่น\n• ไม่นำสัตว์เลี้ยงเข้าในห้องนอน\n• การนำที่นอน หมอน พรม ตากแดดจัด มากกว่า 3 ชั่วโมงขึ้นไปจะช่วยฆ่าตัวไรฝุ่นได้\n• อาจใช้เปลญวนซึ่งซักทำความสะอาดง่าย และตากแดดแห้งง่ายแทนที่นอนในบางที่'),
              buildStimulus('การหลีกเลี่ยงแมลงสาบ', '• ใช้ยากำจัดแมลงสาบ\n• ปิดรูหรือรอยแตกที่พื้นและเพดานทั้งหมด\n• กำจัดไม่ให้มีแหล่งสะสมของเศษอาหาร\n• ควบคุมความชื้น\n• ทำความสะอาดพื้นด้วยน้ำยาทำความสะอาดเพื่อกำจัดสารก่อภูมิแพ้'),
              buildStimulus('การป้องกันการเกิดปฏิกิริยาภูมิแพ้แบบรุนแรง', '• เรียนรู้วิธีการใช้ เตรียมและพกยา epinephrine ไว้ตลอดเวลา\n• สิ่งที่ควรพกติดตัว ได้แก่ เบอร์โทรศัพท์ฉุกเฉิน รายละเอียดของอาหาร หรือยา หรือแมลงที่แพ้ ถ้าไปต่างประเทศควรมีเอกสารที่เป็นภาษาของประเทศนั้นๆด้วย\n• หลีกเลี่ยงแมลงโดยไม่ใช้น้ำหอมหรือใส่เสื้อผ้าสีสด ไม่เก็บผลไม้สด หลีกเลี่ยงเศษขยะหมักหมมซึ่งจะดึงดูดแมลง และปิดหน้าต่างเสมอเมื่อขับรถ\n• หลีกเลี่ยงสารก่อภูมิแพ้ที่อยู่ในอาหารโดยเรียนรู้วิธีการอ่านส่วนผสมในฉลากอาหาร และถ้าทานอาหารนอกบ้านควรตรวจสอบส่วนประกอบของอาหารจากผู้ประกอบอาหารด้วย'),
              buildStimulus('การหลีกเลี่ยงละอองเกสร', '• ปิดหน้าต่างในช่วงที่มีละอองเกสรมากเช่นช่วงเย็น หรือช่วงที่มีละอองหญ้าฟุ้งกระจาย\n• สวมแว่นตาและผ้าปิดปาก\n• ถ้าสามารถทำได้ การใช้เครื่องปรับอากาศหรือการใช้เครื่องกรองละอองเกสรในรถจะช่วยลดการสัมผัสละอองเกสรได้'),
              buildStimulus('การหลีกเลี่ยงสารก่อภูมิแพ้จากสัตว์', '• มีที่อยู่เป็นสัดส่วนให้สัตว์เลี้ยง\n• ไม่นำสัตว์เลี้ยงเข้าในห้องนอน\n• ใช้เครื่องดูดฝุ่นทำความสะอาดบ้าน พรม เป็นประจำ\n• เปลี่ยนเสื้อผ้าทุกครั้งเมื่อสัมผัสสัตว์เลี้ยง เช่น แมว สุนัข'),
              buildStimulus('การหลีกเลี่ยงสารก่อภูมิแพ้จากเชื้อราในบ้าน', '• ถ้าความชื้นมากกว่า 50% ใช้เครื่องกำจัดความชื้น\n• ตรวจเช็คระบบระบายอากาศ หรือเครื่องปรับอากาศให้เหมาะสม\n• ใช้ 5% แอมโมเนีย ในการกำจัดเชื้อรา\n• ไม่ควรใช้พรมหรือวอลเปเปอร์• กำจัดแหล่งน้ำเซาะในบ้าน'),
            ],
          ),
        ),
      ),
    );
  }
}
