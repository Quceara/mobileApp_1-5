
import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}
class MyHomePage extends StatelessWidget {
  TextEditingController textField = TextEditingController();
  TextEditingController textField2 = TextEditingController();
  TextEditingController textField3 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white10,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('calculate'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              textAlign: TextAlign.right,
              enabled: false,
              controller: textField2,
              style: TextStyle(color: Colors.white70,
                fontSize: 30,
              ),
            ),
            TextField(
              textAlign: TextAlign.right,
              enabled: false,
              controller: textField,
              style: TextStyle(color: Colors.white70,
                fontSize: 35,
              ),
            ),
            Columnbut(),
            TextField(
              textAlign: TextAlign.right,
              enabled: false,
              controller: textField3,
              style: TextStyle(color: Colors.white70,
                fontSize: 30,
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget Columnbut(){
    return Column(
      children: [
        Rows(['%','CE','C','<X']),
        Rows(['1/x','x^2','sqrt','/']),
        Rows(['7','8','9','*']),
        Rows(['4','5','6','-',]),
        Rows(['1','2','3','+']),
        Rows(['+/-','0','.','='])
      ],
    );
  }
  Widget Rows(List<String> name) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children:
      name.map((buttonName) => calcbuttor(buttonName)).toList(),
    );
  }
  Widget calcbuttor(String btntxt){
    return ElevatedButton(onPressed: (){
      calculate(btntxt);
    },
      child: Text(btntxt,
        style: TextStyle(
          color: Colors.white70,
        ),
      ),
      style: ElevatedButton.styleFrom(primary: Colors.white10),
    );
  }
  void calculate(String btntxt){
    if(int.tryParse(btntxt) != null){
      if(double.tryParse(textField2.text) == null && textField2.text.isNotEmpty && textField2.text.substring(textField2.text.length-1)=='=')
      {
        textField2.text = '';
        textField.text = '';
      }
      if (textField2.text.isNotEmpty && textField2.text.substring(0, textField2.text.length-1) == textField.text)
      {
        textField.text = '';
      }
      else if(textField.text.isNotEmpty && double.tryParse(textField.text) == null){textField.text='';}
      else if(textField.text.length > 1 && textField.text[0]=='0'&&textField.text[1]=='.'||textField.text.length > 2 && textField.text[0]=='-'&&textField.text[1]=='0'&&textField.text[2]=='.') {}
      else if(textField.text.isNotEmpty&&(textField.text[0] == '0'||textField.text.length > 1&&textField.text[0]=='-'&&textField.text[1]=='0')) {
        if(textField.text[0]=='0') {
          textField.text = '';
        }
        else{textField.text = '-';}

      }
      textField.text += btntxt;
    }
    else if(btntxt == '<X' && textField.text.isNotEmpty){
      if(double.tryParse(textField2.text) == null &&textField2.text.isNotEmpty && textField2.text.substring(textField2.text.length-1)=='=') {
        textField2.text = '';textField.text = '';}
      else if(double.tryParse(textField.text) != null){ textField.text = textField.text.substring(0, textField.text.length-1);}
      else if(double.tryParse(textField.text) == null) {textField.text = '';}

    }
    else if(btntxt == '.' && double.tryParse(textField.text) != null){
      textField.text += btntxt;
      counter('.');
    }
    else if(btntxt == '+/-' && double.tryParse(textField.text) != null) {
      if(textField.text[0] !='-') {
        textField.text = '-'+textField.text;
      }
      else {
        textField.text = textField.text.substring(1);
      }
    }
    else if(btntxt == '%' && double.tryParse(textField.text) != null) {
      textField.text = (double.parse(textField.text)/100).toString();
    }
    else if(btntxt == 'sqrt' && double.tryParse(textField.text) != null) {
      if (double.parse(textField.text) >= 0 && double.parse(textField.text) != -0.0) {
        textField2.text = 'sqrt'+'('+ textField.text +')';
        textField.text = sqrt(double.parse(textField.text)).toString();

      }
      else {
        textField.text = 'НЕВЕРНЫЙ ВВОД';
      }
    }
    else if(btntxt == '1/x' && double.tryParse(textField.text) != null) {
      if (double.parse(textField.text) != 0 && double.parse(textField.text) != -0.0) {
        textField2.text = '1/'+ textField.text;
        textField.text = (1/double.parse(textField.text)).toString();

      }
      else {
        textField.text = 'НЕВЕРНЫЙ ВВОД';
      }
    }
    else if(btntxt == 'x^2' && double.tryParse(textField.text) != null) {
      if (double.parse(textField.text) != 0 && double.parse(textField.text) != -0.0) {
        textField2.text = '('+textField.text+')' + '^2';
        textField.text = (double.parse(textField.text)*double.parse(textField.text)).toString();

      }
      else {
        textField.text = 'НЕВЕРНЫЙ ВВОД';
      }
    }
    else if(btntxt == 'CE') {
      textField.text = '';
    }
    else if(btntxt == 'C') {
      textField.text = '';
      textField2.text = '';
    }
    else if(btntxt == '/' && double.tryParse(textField.text) != null) {
      textField2.text = textField.text + '/';
      textField.text = textField2.text.substring(0, textField2.text.length-1);
    }
    else if(btntxt == '*' && double.tryParse(textField.text) != null) {
      textField2.text = textField.text + '*';
      textField.text = textField2.text.substring(0, textField2.text.length-1);
    }
    else if(btntxt == '-' && double.tryParse(textField.text) != null) {
      textField2.text = textField.text + '-';
      textField.text = textField2.text.substring(0, textField2.text.length-1);
    }
    else if(btntxt == '+' && double.tryParse(textField.text) != null) {
      textField2.text = textField.text + '+';
      textField.text = textField2.text.substring(0, textField2.text.length-1);
    }

    else if(btntxt == '=' && textField2.text.isNotEmpty)
    {
      if(textField.text == ''){}
      else if(textField2.text.substring(textField2.text.length-1) == '/')
      {
        textField3.text = textField2.text + textField.text + '=';
        textField.text = (double.parse(textField2.text.substring(0, textField2.text.length-1))/double.parse(textField.text)).toString();
        textField2.text = textField3.text;
        textField3.text = '';
      }
      else if(textField2.text.substring(textField2.text.length-1) == '*')
      {
        textField3.text = textField2.text + textField.text + '=';
        textField.text = (double.parse(textField2.text.substring(0, textField2.text.length-1))*double.parse(textField.text)).toString();
        textField2.text = textField3.text;
        textField3.text = '';
      }
      else if(textField2.text.substring(textField2.text.length-1) == '-')
      {
        textField3.text = textField2.text + textField.text + '=';
        textField.text = (double.parse(textField2.text.substring(0, textField2.text.length-1))-double.parse(textField.text)).toString();
        textField2.text = textField3.text;
        textField3.text = '';
      }
      else if(textField2.text.substring(textField2.text.length-1) == '+')
      {
        textField3.text = textField2.text + textField.text + '=';
        textField.text = (double.parse(textField2.text.substring(0, textField2.text.length-1))+double.parse(textField.text)).toString();
        textField2.text = textField3.text;
        textField3.text = '';
      }
    }
  }
  void counter(String sim) {
    int Count= 0;
    for (int i = 0; i < textField.text.length; i++) {
      if (textField.text[i] == sim){
        Count++;
        if (Count > 1)
        {
          if(sim == '.')
          {
            textField.text = textField.text.substring(0, textField.text.length-1);
          }
        }
      }
    }
  }
}