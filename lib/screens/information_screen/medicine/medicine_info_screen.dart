import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';

class MedicineInfoScreen extends StatelessWidget {
  static const routeName = '/medicine-info';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ข้อมูลยา'),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              Container(
                child: Column(
                  children: [
                    ExpandableNotifier(
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
                                  child: Text('Avamys®',
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
                                        'ชื่อตัวยาสามัญ: Fluticasone furoate nasal inhalation\nชื่อการค้า : AVAMYS ®\nรูปแบบ : ยาน้ำแขวนตะกอน สำหรับพ่นจมูก\nข้อบ่งใช้ :สำหรับรักษาอาการผิดปรกติทางจมูก (น้ำมูกไหล คัดจมูก คันจมูก และจาม) จากโรคเยื่อบุจมูกอักเสบ จากภูมิแพ้ชนิดเป็นตลอดทั้งปี (perenial allergic rhinitis)\nวิธีใช้ : พ่นวันละ 1 ครั้ง หรือ วันละ 2 ครั้ง เช้า-เย็น\n',
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
                    ),
                    ExpandableNotifier(
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
                                  child: Text('Nasonex®',
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
                                        'ชื่อตัวยาสามัญ: Mometasone Furoate Monohydrate\nชื่อการค้า : Nasonex ®\nข้อบ่งใช้ :ในผู้ใหญ่, วัยรุ่นและเด็กอายุระหว่าง 2 ถึง 11 ปีเพื่อรักษาอาการ โพรงจมูกอักเสบจากภูมิแพ้ที่เกิดตลอดปี ในผู้ปวยที่มีประวัติของอาการโพรงจมูกอักเสบจากภูมิแพที่เกิดตามฤดูกาลแบบปานกลางถึงขั้นรุนแรง\nวิธีใช้ : หลังจากทดลองพ่นยา NASONEX™ Aqueous Nasal Pump (10 ครั้ง จนได้ละอองสเปรย์ที่สม่ำเสมอ) การปั๊มยาแต่ละครั้งให้ยาน้ําแขวนตะกอนโมเมทาโซน ฟูโรเอท ประมาณ 100 มิลลิกรัม ที่มีmometasone furoate monohydrate เทียบเท่ากับโมเมทาโซน ฟูโรเอท 50 ไมโครกรัม หากไม่ไ้ด้ใช้ยานี้เกิน 14 วัน ควรลองพ่นยาใหม่ 2 ครั้ง จนได้ละออง สเปรย์ที่สม่ำเสมอก่อนเริ่มใช้ครั้งต่อไป เขย่าขวดทุกครั้งก่อนใช้ยา\n',
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
                    ),
                    ExpandableNotifier(
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
                                  child: Text('Dymista®',
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
                                        'ชื่อตัวยาสามัญ: Azelastine hydrochloride and fluticasone propionate\nชื่อการค้า : Dymista®\nรูปแบบ : ยาน้ำแขวนตะกอน สำหรับพ่นจมูก\nข้อบ่งใช้ : ในผู้ใหญ่, วัยรุ่นและเด็กอายุระหว่าง 2 ถึง 11 ปีเพื่อรักษาอาการ โพรงจมูกอักเสบจากภูมิแพ้ที่เกิดตลอดปี ในผู้ปวยที่มีประวัติของอาการโพรงจมูกอักเสบจากภูมิแพที่เกิดตามฤดูกาลแบบปานกลางถึงขั้นรุนแรง\nวิธีใช้ : ครั้งแรกที่ใช้จะต้องปั๊มฉีดพ่นโดยกด 6 ครั้งจนกว่าจะเห็นสเปรย์ที่ดี อาจจะต้องทำซ้ำขั้นตอนนี้หากไม่ได้ใช้ Dymista spray พ่นจมูกเป็นเวลา 2 สัปดาห์\n',
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
                    ),
                    ExpandableNotifier(
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
                                  child: Text('Zyrtec®',
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
                                        'ชื่อตัวยาสามัญ: Cetirizine\nชื่อการค้า : Zyrtec®\nรูปแบบ : ยาเม็ด \nคำเตือนการใช้ยา: ยา Zyrtec® สามารถส่งผลข้างเคียงต่อกระบวนการคิดและการตอบสนอง ดังนั้นควรหลีกเลี่ยงการขับรถ การทำงานกับเครื่องจักร หรือกิจกรรมที่ต้องการการตื่นตัวอยู่ตลอดเวลา\nวิธีใช้ : การใช้ยา Zyrtec® สามารถรับประทานได้ทั้งก่อนและหลังอาหาร หากรับประทานยาดังกล่าวเป็นชนิดน้ำ ควรใช้ช้อนสำหรับตวงยาโดยเฉพาะ ไม่ควรใช้ช้อนธรรมดาในการตวงเพราะอาจจะทำให้รับประทานยาเกินขนาด หรือน้อยกว่าปริมาณที่ควรจะเป็น \n',
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
                    ),
                    ExpandableNotifier(
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
                                  child: Text('Allernix®',
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
                                        'ชื่อตัวยาสามัญ: Loratadine\nชื่อการค้า : Allernix®\nรูปแบบ : ยาเม็ด\nข้อบ่งใช้ : บรรเทาอาการแพ้ของระบบทางเดินหายใจ เช่น จาม น้ำมูกไหล คันจมูก คันตา แสบตา เนื่องจากโรคภูมิแพ้ บรรเทาอาการของ ลมพิษเรื้อรัง และอาการแพ้ทางผิวหนังอื่นๆ\nวิธีใช้ : ผู้ใหญ่ และ เด็กอายุ 12 ปีขึ้นไป รับประทานครั้งละ 1 เม็ด วันละ 1 ครั้ง\n',
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
                    ),
                    ExpandableNotifier(
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
                                  child: Text('Telfast®',
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
                                        'ชื่อตัวยาสามัญ: Fexofenadine\nชื่อการค้า : Telfast®\nรูปแบบ : ยาเม็ด\nข้อบ่งใช้ : บรรเทาอาการของโรคภูมิแพ้ Seasonal allergic rhinitis เช่นคัดจมูก จาม น้ำมูกไหล คันจมูก คันตา\nวิธีใช้ : ใช้สำหรับรับประทาน โดยทั่วไปรับประทานยาวันละ 1-2 ครั้ง หรือให้ใช้ยานี้ตามวิธีใช้ที่ระบุบนฉลากยาอย่างเคร่งครัด โดยห้ามใช้ยาในขนาดที่มากหรือน้อยกว่าที่ระบุ และหากมีข้อสงสัยให้สอบถามแพทย์หรือเภสัชกร\n',
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
                    ),
                    ExpandableNotifier(
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
                                  child: Text('Xyzal®',
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
                                        'ชื่อตัวยาสามัญ: Levocetirizine\nชื่อการค้า : Xyzal ®\nรูปแบบ : ยาเม็ด\nข้อบ่งใช้ : ใช้สำหรับโรคจมูกอักเสบจากภูมิแพ้\nวิธีใช้ : \n- ผู้ใหญ่และเด็กโตอายุ 10-19 ปี ขนาดการใช้ยาคือ ขนาด 5 มิลลิกรัม (1 เม็ด) ต่อวัน วันละครั้ง\n- เด็กอายุ 6-12 ปี ขนาดการใช้ยาคือ ขนาด 5 มิลลิกรัม (1 เม็ด) ต่อวัน วันละครั้ง\n- ผู้สูงอายุที่มีการทำงานของไตปกติ หรือไตบกพร่องเล็กน้อย ขนาดการใช้ยาคือ 5 มิลลิกรัม (1 เม็ด) ต่อวัน วันละครั้ง ผู้สูงอายุที่มีการทำงานของไตบกพร่องระดับปานกลางขึ้นไป ให้ปรับลดขนาดยาตามค่าการทำงานของไต เนื่องจากยาจะถูกขับออกทางไต จึงอาจเกิดผลกระทบได้\n',
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
                    ),
                    ExpandableNotifier(
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
                                  child: Text('Aerius®',
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
                                        'ชื่อตัวยาสามัญ: Desloratadine\nชื่อการค้า : Aerius ®\nรูปแบบ : ยาเม็ด\nข้อบ่งใช้ : ใช้สำหรับโรคจมูกอักเสบจากภูมิแพ้\nวิธีใช้ : \n-ผู้ใหญ่ รับประทานยาปริมาณ 5 มิลลิกรัม วันละ 1 ครั้ง\n-เด็ก อายุ 6-11 เดือน รับประทานยาปริมาณ 1 มิลลิกรัม วันละ 1 ครั้ง\nอายุ 1-5 ปี รับประทานยาปริมาณ 1.25 มิลลิกรัม วันละ 1 ครั้ง\nอายุ 6-11 ปี รับประทานยาปริมาณ 2.5 มิลลิกรัม วันละ 1 ครั้ง\n',
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
                    ),
                    ExpandableNotifier(
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
                                  child: Text('Bilaxten®',
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
                                        'ชื่อตัวยาสามัญ:\n ชื่อการค้า : Bilaxten  ®\nรูปแบบ : ยาเม็ด\nข้อบ่งใช้ : บรรเทาอาการโรคภูมิแพ้ที่เกิดขึ้นตามฤดูกาล เช่น อาการแพ้ของเยื่อจมูก\nวิธีใช้ :\n - ผู้ใหญ่และเด็กที่มีอายุตั้งแต่ 12 ปีขึ้นไป: รับประทานยา 20 มิลลิกรัม วันละ 1ครั้ง ในช่วงท้องว่าง คือ ก่อนอาหารประมาณ 1 ชั่วโมง หรือ หลังอาหารประมาณ 2 ชั่วโมง\n- เด็กอายุต่ำกว่า 12 ปีลงมา: ห้ามใช้ยานี้กับเด็กที่อายุต่ำกว่า 12 ปีลงมา',
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
