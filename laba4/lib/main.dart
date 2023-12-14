import 'package:flutter/material.dart';

class CustomPage extends StatefulWidget {
  @override
  CustomPageState createState() => CustomPageState();
}

class CustomPageState extends State<CustomPage> {
  late TextEditingController controller2;
  late TextEditingController controller4;

  @override
  void initState() {
    super.initState();
    DateTime now = DateTime.now();
    controller2 = TextEditingController(text: now.year.toString());
    controller4 = TextEditingController(text: now.month.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Custom Page'),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buildRow('year', controller2, '1'),
              buildRow('month', controller4, '2'),
              buildMonthInfo(),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildRow(String text, TextEditingController controller, String numrow) {
    return Container(
      alignment: Alignment.topCenter,
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          buildButton('<<', numrow),
          SizedBox(width: 8.0),
          Container(

            width: 100.0,
            child: TextField(
              enabled: false,
              textAlign: TextAlign.center,
              controller: controller,
              style: TextStyle(fontSize: 16.0),
              readOnly: true,
            ),
          ),
          SizedBox(width: 8.0),
          buildButton('>>', numrow),
        ],
      ),
    );
  }

  Widget buildButton(String buttonText, String numrow) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          if (numrow == '1') {
            if (buttonText == '>>') {
              controller2.text = (int.parse(controller2.text) + 1).toString();
            } else {
              if (int.parse(controller2.text) <= 200) {
              } else {
                controller2.text =
                    (int.parse(controller2.text) - 1).toString();
              }
            }
          } else {
            if (buttonText == '>>') {
              if (int.parse(controller4.text) >= 12) {
                controller2.text = (int.parse(controller2.text) + 1).toString();
                controller4.text = '1';
              } else {
                controller4.text =
                    (int.parse(controller4.text) + 1).toString();
              }
            } else {
              if (int.parse(controller4.text) <= 1) {
                controller2.text = (int.parse(controller2.text) - 1).toString();
                controller4.text = '12';
              } else {
                controller4.text = (int.parse(controller4.text) - 1).toString();
              }
            }
          }
        });
      },
      child: Text(buttonText),
    );
  }

  Widget buildMonthInfo() {
    DateTime now = DateTime(
      int.parse(controller2.text),
      int.parse(controller4.text),
      1,
    );

    int currentDay = 0;
    int currentWeekday = now.weekday;

    int daysInMonth = DateTime(now.year, now.month + 1, 0).day;
    int daysInPrevMonth = DateTime(now.year, now.month, 0).day;

    List<Widget> weeks = [];

    while (currentDay <= daysInMonth) {
      List<Widget> buttonsInRow = [];
      bool isCurrentMonth = false;

      for (int i = 1; i < 8; i++) {
        int dayOfMonth = currentDay + i - currentWeekday + 1;

        if (dayOfMonth <= daysInMonth && dayOfMonth > 0) {
          isCurrentMonth = true;
          buttonsInRow.add(
            Expanded(
              child: FractionallySizedBox(
                widthFactor: 1,
                child: ElevatedButton(
                  onPressed: () {
                    print('Button pressed for day $dayOfMonth');
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                      dayOfMonth == DateTime.now().day && controller4.text == DateTime.now().month.toString() && controller2.text == DateTime.now().year.toString()
                          ? Colors.green
                          : Colors.grey,
                    ),
                  ),
                  child: Text(
                    dayOfMonth.toString(),
                    style: TextStyle(fontSize: 12.0),
                  ),
                ),
              ),
            ),
          );
        } else if (dayOfMonth <= 0) {
          buttonsInRow.insert(0,
            Expanded(
              child: FractionallySizedBox(
                widthFactor: 1,
                child: ElevatedButton(
                  onPressed: () {
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                      Colors.transparent,
                    ),
                  ),
                  child: Text(
                    daysInPrevMonth.toString(),
                    style: TextStyle(fontSize: 12.0),
                  ),
                ),
              ),
            ),
          );
          daysInPrevMonth--;
        } else {
          buttonsInRow.add(
            Expanded(
              child: FractionallySizedBox(
                widthFactor: 1,
                child: ElevatedButton(
                  onPressed: () {
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                      Colors.transparent,
                    ),
                  ),
                  child: Text(
                    (dayOfMonth - daysInMonth).toString(),
                    style: TextStyle(fontSize: 12.0),
                  ),
                ),
              ),
            ),
          );
        }
      }

      if (isCurrentMonth) {
        weeks.add(
          Row(
            children: buttonsInRow,
          ),
        );
      }

      currentDay = currentDay + 7 - currentWeekday + 1;
      currentWeekday = 1;
    }

    return Expanded(
      child: ListView(
        children: weeks,
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: CustomPage(),
  ));
}
