import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math';
import 'dart:core';

void main() => runApp(Magic8BallApp());

class Magic8BallApp extends StatelessWidget
{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Ask Me Anything'),
          backgroundColor: Colors.blue[700],
        ),
        body: Magic8Ball(),
        backgroundColor: Colors.blue,
      )
    );
  }
}

class Magic8Ball extends StatefulWidget {
  @override
  State<Magic8Ball> createState() => _Magic8BallState();
}

class _Magic8BallState extends State<Magic8Ball> {
  Random r;
  int answerStatus;
  int selectedHintQuote = 0;
  bool answered = false;
  final int numOfStatus = 5;

  TextEditingController textEditingController;

  List<String> hintQuotes = <String>[
    'Watch Netflix?',
    'Play a game?',
    'Study flutter?',
    'Just go to work?',
  ];

  @override
  void initState() {
    super.initState();
    textEditingController = TextEditingController();
    r = Random(DateTime.now().millisecondsSinceEpoch);

    rollStatus();
    rollHint();
  }

  void rollStatus()
  {
    answerStatus = r.nextInt(numOfStatus) + 1;
  }

  void rollHint()
  {
    selectedHintQuote = r.nextInt(hintQuotes.length);
  }

  void answer()
  {
    rollStatus();
    rollHint();
    answered = true;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(15),
              child: TextFormField(
                controller: textEditingController,
                decoration: InputDecoration(
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  labelText: 'What do you want to ask?',
                  hintText: 'ex) ${hintQuotes[selectedHintQuote]}',
                  hintStyle: TextStyle(
                    color: Colors.white54,
                  ),
                ),
                onEditingComplete: () {
                  if (!answered) {
                    setState(() => answer());
                  }
                  //https://stackoverflow.com/questions/44991968/how-can-i-dismiss-the-on-screen-keyboard/56946311#56946311
                  SystemChannels.textInput.invokeMethod('TextInput.hide');
                },
                onTap: () {
                  if (answered) {
                    answered = false;
                    textEditingController.clear();
                  }
                },
              ),
            ),
            FlatButton(
              onPressed: () {
                setState(() => answer());
              },
              child: Image.asset('images/ball$answerStatus.png'),
            ),
          ],
        ),
      ),
    );
  }
}