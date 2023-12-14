import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: Text('Converter'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Button(context, 'Деньги', SecondPage('Деньги')),
              Button(context, 'Длинна', SecondPage('Длинна')),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Button(context, 'Вес', SecondPage('Вес')),
              Button(context, 'Объем', SecondPage('Объем')),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Button(context, 'Время', SecondPage('Время')),
            ],
          ),
        ],
      ),
    );
  }

  Widget Button(BuildContext context, String buttonText, Widget page) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(horizontal: 30,vertical: 50)
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => page),
          );
        },
        child: Text(buttonText),
      ),
    );
  }
}

class SecondPage extends StatefulWidget {
  final String buttonText;

  SecondPage(this.buttonText);

  @override
  SecondPageState createState() => SecondPageState();
}

class SecondPageState extends State<SecondPage> {

  TextEditingController inputValueController = TextEditingController();
  TextEditingController outputValueController = TextEditingController();
  String newSelectedCurrency1 = "";
  String newSelectedCurrency2 = "";

  @override
  Widget build(BuildContext context) {

    List<String> dropDownList1 = StringList(widget.buttonText);
    List<String> dropDownList2 = StringList(widget.buttonText);


    return Scaffold(
      appBar: AppBar(
        title: Text('Меню конвертации'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Выбранная опция: ${widget.buttonText}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(
                border: InputBorder.none,
                labelText: Name(widget.buttonText),
                enabled: false,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                DropdownButton<String>(
                  value: newSelectedCurrency1.isEmpty? dropDownList1[0] : newSelectedCurrency1,
                  onChanged: (String? newValue) {
                    setState(() {
                      newSelectedCurrency1 = newValue!;
                    });
                  },
                  items: StringList(widget.buttonText)
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                Text(
                  '-->',
                  style: TextStyle(fontSize: 16),
                ),
                DropdownButton<String>(
                  value: newSelectedCurrency2.isEmpty? dropDownList2[0] : newSelectedCurrency2,
                  onChanged: (String? newValue) {
                    setState(() {
                      newSelectedCurrency2 = newValue!;
                      handleDropdownChange2(newValue , newSelectedCurrency1.isEmpty? dropDownList1[0] : newSelectedCurrency1);
                    });
                  },
                  items: StringList(widget.buttonText)
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ],
            ),
            SizedBox(height: 20),
            TextField(
              controller: outputValueController,
              decoration: InputDecoration(
                border: InputBorder.none,
                labelText: 'Конвертация в: '
                    '${newSelectedCurrency2.isEmpty? dropDownList2[0] : (newSelectedCurrency2)}',
                enabled: false,
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: inputValueController,
              keyboardType: TextInputType.number,
              onEditingComplete: ()
              {
                handleEditingComplete(newSelectedCurrency1.isEmpty? dropDownList1[0] : newSelectedCurrency1,
                    newSelectedCurrency2.isEmpty? dropDownList2[0] : (newSelectedCurrency2));
              },
              decoration: InputDecoration(
                labelText:
                    '${newSelectedCurrency1.isEmpty? dropDownList1[0] : newSelectedCurrency1}',
              ),
            ),
          ],
        ),
      ),
    );
  }
  void handleEditingComplete(String droptext1, String droptext2) {
    if(inputValueController.text.isEmpty){}
    else if(double.tryParse(inputValueController.text) == null){}
    else if(double.parse(inputValueController.text)<=0){}
    else if(droptext1 == droptext2){outputValueController.text = inputValueController.text;}
    else {
      if (widget.buttonText == 'Деньги')
      {
        if (droptext1 == 'Рубль' && droptext2 == 'Доллар')
        {
          outputValueController.text = (double.parse(inputValueController.text) / 91).toString();
        }
        else if (droptext1 == 'Рубль' && droptext2 == 'Евро')
        {
          outputValueController.text = (double.parse(inputValueController.text) / 98).toString();
        }
        else if (droptext1 == 'Доллар' && droptext2 == 'Рубль')
        {
          outputValueController.text = (double.parse(inputValueController.text) * 91).toString();
        }
        else if (droptext1 == 'Доллар' && droptext2 == 'Евро')
        {
          outputValueController.text = (double.parse(inputValueController.text) * 1.08).toString();
        }
        else if (droptext1 == 'Евро' && droptext2 == 'Рубль')
        {
          outputValueController.text = (double.parse(inputValueController.text) * 98).toString();
        }
        else if (droptext1 == 'Евро' && droptext2 == 'Доллар')
        {
          outputValueController.text = (double.parse(inputValueController.text) / 1.08).toString();
        }
      }
      else if (widget.buttonText == 'Вес')
      {
        if (droptext1 == 'грамм' && droptext2 == 'килограмм')
        {
          outputValueController.text = (double.parse(inputValueController.text) / 1000).toString();
        }
        else if (droptext1 == 'грамм' && droptext2 == 'центнер')
        {
          outputValueController.text = (double.parse(inputValueController.text) / 100000).toString();
        }
        else if (droptext1 == 'килограмм' && droptext2 == 'грамм')
        {
          outputValueController.text = (double.parse(inputValueController.text) * 1000).toString();
        }
        else if (droptext1 == 'килограмм' && droptext2 == 'центнер')
        {
          outputValueController.text = (double.parse(inputValueController.text) / 100).toString();
        }
        else if (droptext1 == 'центнер' && droptext2 == 'килограмм')
        {
          outputValueController.text = (double.parse(inputValueController.text) * 100).toString();
        }
        else if (droptext1 == 'центнер' && droptext2 == 'грамм')
        {
          outputValueController.text = (double.parse(inputValueController.text) * 100000).toString();
        }
      }
      else if (widget.buttonText == 'Длинна')
      {
        if (droptext1 == 'Дециметр' && droptext2 == 'Метр')
        {
          outputValueController.text = (double.parse(inputValueController.text) / 10).toString();
        }
        else if (droptext1 == 'Дециметр' && droptext2 == 'Сантиметр')
        {
          outputValueController.text = (double.parse(inputValueController.text) * 10).toString();
        }
        else if (droptext1 == 'Метр' && droptext2 == 'Дециметр')
        {
          outputValueController.text = (double.parse(inputValueController.text) * 10).toString();
        }
        else if (droptext1 == 'Метр' && droptext2 == 'Сантиметр')
        {
          outputValueController.text = (double.parse(inputValueController.text) * 100).toString();
        }
        else if (droptext1 == 'Сантиметр' && droptext2 == 'Дециметр')
        {
          outputValueController.text = (double.parse(inputValueController.text) / 10).toString();
        }
        else if (droptext1 == 'Сантиметр' && droptext2 == 'Метр')
        {
          outputValueController.text = (double.parse(inputValueController.text) / 100).toString();
        }
      }
      else if (widget.buttonText == 'Объем')
      {
        if (droptext1 == 'мм^3' && droptext2 == 'см^3')
        {
          outputValueController.text = (double.parse(inputValueController.text) / 1000).toString();
        }
        else if (droptext1 == 'мм^3' && droptext2 == 'м^3')
        {
          outputValueController.text = (double.parse(inputValueController.text) / 1000000000).toString();
        }
        else if (droptext1 == 'см^3' && droptext2 == 'мм^3')
        {
          outputValueController.text = (double.parse(inputValueController.text) * 1000).toString();
        }
        else if (droptext1 == 'см^3' && droptext2 == 'м^3')
        {
          outputValueController.text = (double.parse(inputValueController.text) / 1000000).toString();
        }
        else if (droptext1 == 'м^3' && droptext2 == 'мм^3')
        {
          outputValueController.text = (double.parse(inputValueController.text) * 1000000000).toString();
        }
        else if (droptext1 == 'м^3' && droptext2 == 'см^3')
        {
          outputValueController.text = (double.parse(inputValueController.text) * 1000000).toString();
        }
      }
      else
      {
        if (droptext1 == 'Секунда' && droptext2 == 'Минута')
        {
          outputValueController.text = (double.parse(inputValueController.text) / 60).toString();
        }
        else if (droptext1 == 'Секунда' && droptext2 == 'Час')
        {
          outputValueController.text = (double.parse(inputValueController.text) / 3600).toString();
        }
        else if (droptext1 == 'Минута' && droptext2 == 'Секунда')
        {
          outputValueController.text = (double.parse(inputValueController.text) * 60).toString();
        }
        else if (droptext1 == 'Минута' && droptext2 == 'Час')
        {
          outputValueController.text = (double.parse(inputValueController.text) / 60).toString();
        }
        else if (droptext1 == 'Час' && droptext2 == 'Секунда')
        {
          outputValueController.text = (double.parse(inputValueController.text) * 3600).toString();
        }
        else if (droptext1 == 'Час' && droptext2 == 'Минута')
        {
          outputValueController.text = (double.parse(inputValueController.text) * 60).toString();
        }
      }
    }
  }
  String Name (String ButtonName) {
    if(ButtonName == 'Объем' || ButtonName == 'Длинна' || ButtonName == 'Вес' || ButtonName == 'Время') {return  'Выберите меру';}
    else {return  'Выберите валюту';}
  }
  List<String> StringList(String btnText)
  {
    if(btnText == 'Деньги') {return ['Рубль','Евро','Доллар'];}
    else if(btnText == 'Длинна') {return ['Сантиметр','Метр','Дециметр'];}
    else if(btnText == 'Объем') {return ['мм^3','см^3','м^3'];}
    else if(btnText == 'Время') {return ['Секунда','Минута','Час'];}
    else {return ['грамм','килограмм','центнер'];}
  }
  void handleDropdownChange2(String newValue2, String oldValue1)
  {
    handleEditingComplete(oldValue1,newValue2);
  }
}
