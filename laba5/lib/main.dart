import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter API Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  TextEditingController textFieldController = TextEditingController();

  Future<Map<String, dynamic>> fetchData(String text) async {
    final response = await http.get(Uri.parse('https://newsapi.org/v2/everything?q=$text&from=2023-11-12&pageSize=50&sortBy=publishedAt&apiKey=d44af081f94a4b288499164dd0efd0fb'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Ошибка запроса: ${response.statusCode}');
    }
  }

  void onButtonPressed() async {
    String enteredText = textFieldController.text.trim();

    if (enteredText.isNotEmpty) {
      Map<String, dynamic> apiData = await fetchData(enteredText);
      List<dynamic> articles = apiData['articles'];

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ButtonPage(
            articles: articles,
          ),
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Ошибка'),
            content: Text('Введите текст перед переходом на следующую страницу.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Поиск новостей'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: textFieldController,
              decoration: InputDecoration(labelText: 'Текст для поиска'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: onButtonPressed,
              child: Text('Найти'),
            ),
          ],
        ),
      ),
    );
  }
}

class ButtonPage extends StatefulWidget {
  final List<dynamic> articles;

  ButtonPage({required this.articles});

  @override
  ButtonPageState createState() => ButtonPageState();
}

class ButtonPageState extends State<ButtonPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(''),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 20),
            Text(
              'Список новостей',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Expanded(
              child: widget.articles.isEmpty
                  ? Center(
                child: Text('Ничего не найдено'),
              )
                  : ListView.builder(
                itemCount: widget.articles.length,
                itemBuilder: (context, index) {
                  var article = widget.articles[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => InfoPage(
                            imageUrl: article['urlToImage'] ?? '',
                            content: article['content'] ?? 'Упс, здесь нет контента',
                            buttonTitle: article['title'] ?? 'упс а вот и нету ничего',
                          ),
                        ),
                      );
                    },
                    child: Container(
                      color: Colors.transparent,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              article['title'] ?? 'упс не передало',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue),
                            ),
                            SizedBox(height: 10),
                            Text(
                              article['description'] ?? 'Упс а тут и нет ничего',
                              style: TextStyle(fontSize: 16),
                            ),
                            Divider(),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class InfoPage extends StatelessWidget {
  final String imageUrl;
  final String content;
  final String buttonTitle;

  InfoPage({required this.imageUrl, required this.content, required this.buttonTitle});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(''),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        buttonTitle,
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                      imageUrl.isNotEmpty
                          ? Image.network(
                        imageUrl,
                        loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                          if (loadingProgress == null) {
                            return child;
                          } else {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                        },
                        errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                          return Text('Не удалось загрузить изображение');
                        },
                      )
                          : SizedBox.shrink(),
                      SizedBox(height: 10),
                      Text(
                        content,
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

