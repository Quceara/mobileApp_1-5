import 'package:flutter/material.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(MaterialApp(
    home: HomePage(),
  ));
}

class HomePage extends StatefulWidget {
  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  List<String> dataList = [];

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/data.txt');
    if (await file.exists()) {
      List<String> lines = await file.readAsLines();
      print(lines);
      setState(() {
        dataList = lines;
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('Главная страница'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              alignment: Alignment.topCenter,
              child: ElevatedButton(
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DataEntryPage(
                        onSave: (date, text) async {
                          await saveDataToFile(date, text);
                          await loadData();
                          setState(() {});
                        },
                      ),
                    ),
                  );
                },
                child: Text('Перейти к вводу данных'),
              ),
            ),
            for (int index = 0; index < dataList.length; index++)
              buildListItem(context, index),
          ],
        ),
      ),
    );
  }

  void toggleButtonColor(int index) async {
    String line = dataList[index];
    String newLine = line.substring(0, line.length - 1) + (line.endsWith('1') ? '0' : '1');
    dataList[index] = newLine;

    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/data.txt');
    await file.writeAsString(dataList.join('\n'));

    setState(() {});
  }

  Color getButtonColor(int index) {
    return dataList[index].endsWith('1') ? Colors.green : Colors.grey;
  }

  Widget buildListItem(BuildContext context, int index) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              toggleButtonColor(index);
            },
            style: ElevatedButton.styleFrom(
              primary: getButtonColor(index),
              shape: CircleBorder(),
              padding: EdgeInsets.all(16),
            ),
            child: Icon(Icons.check, color: Colors.white),
          ),
        ),
        Expanded(
          flex: 3,
          child: Text(dataList[index].substring(0, dataList[index].length - 1)),
        ),
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              deleteData(index);
            },
            child: Text('del'),
          ),
        ),
      ],
    );
  }

  Future<void> saveDataToFile(String date, String text) async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/data.txt');

    await file.writeAsString('\n$date:$text 0', mode: FileMode.append);

    List<String> lines = await file.readAsLines();
    lines.removeWhere((line) => line.isEmpty);
    await file.writeAsString(lines.join('\n'));
  }

  Future<void> deleteData(int index) async {
    if (index < dataList.length) {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/data.txt');
      List<String> lines = await file.readAsLines();
      lines.removeAt(index);
      await file.writeAsString(lines.join('\n'));

    } else {
      print('Index out of bounds');
    }

    loadData();
  }
}

class DataEntryPage extends StatefulWidget {
  final Function(String, String) onSave;

  DataEntryPage({required this.onSave});

  @override
  DataEntryPageState createState() => DataEntryPageState();
}

class DataEntryPageState extends State<DataEntryPage> {
  TextEditingController dateController = TextEditingController();
  TextEditingController textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ввод данных'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: dateController,
              decoration: InputDecoration(labelText: 'Введите дату (гггг.мм.дд)'),
            ),
            SizedBox(height: 16),
            TextField(
              controller: textController,
              decoration: InputDecoration(labelText: 'Введите текст'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (isValidDate(dateController.text)) {
                  widget.onSave(dateController.text, textController.text);
                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Неверный формат даты'),
                    ),
                  );
                }
              },
              child: Text('Сохранить и вернуться'),
            ),
          ],
        ),
      ),
    );
  }

  bool isValidDate(String input) {
    try {
      DateFormat dateFormat = DateFormat('yyyy-MM-dd');
      DateTime parsedDate = dateFormat.parseStrict(input.replaceAll('.', '-'));

      if (parsedDate.month < 1 ||
          parsedDate.month > 12 ||
          parsedDate.day < 1 ||
          parsedDate.day > 31) {
        return false;
      }

      return true;
    } catch (e) {
      return false;
    }
  }
}
