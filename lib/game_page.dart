import 'package:flutter/material.dart';
import 'package:spell_itt_demo/alert.dart';
import 'package:spell_itt_demo/score.dart';

class GamePage extends StatefulWidget {
  final String question;
  final List<dynamic> gameScoreList;
  final Score gameScore;

  GamePage(
      {required this.question,
      required this.gameScoreList,
      required this.gameScore});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  String question = '';
  bool isSolved = false;

  @override
  void initState() {
    super.initState();
    initGame();
  }

  @override
  Widget build(BuildContext context) {
    String imageUrl = isSolved ? 'correct.gif' : 'warning.png';

    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      CircleAvatar(
        backgroundImage: AssetImage('assets/$imageUrl'),
        radius: 50,
      ),
      SizedBox(height: 10),
      Text(
        question,
        style: TextStyle(fontSize: 40, color: Colors.black),
      ),
      SizedBox(height: 10),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 50),
        child: TextField(
          maxLength: widget.question.length,
          onSubmitted: (value) async {
            if (value.toLowerCase() == widget.question.toLowerCase()) {
              await widget.gameScore.addScore(value);
              setState(() {
                isSolved = true;
              });
              if (!mounted) return;
              return Alert().showAlert(context, 'Correct!',
                  'You got it right! \n Swipe right for next question');
            } else {
              if (!mounted) return;
              return Alert().showAlert(context, 'Wrong!',
                  'Try Again! \n Swipe right for next question');
            }
          },
          style: TextStyle(fontSize: 30),
        ),
      )
    ]);
  }

  getGameScoreList() {
    if (widget.gameScoreList.contains(widget.question)) {
      isSolved = true;
    }
  }

  void initGame() {
    getGameScoreList();
    question = widget.question;
    int times = (question.length ~/ 2) - 1;
    question = question.replaceRange(1, (question.length ~/ 2), "_" * times);
    question = question.replaceRange(
        (question.length ~/ 2) + 1,
        question.length % 2 == 0 ? question.length : question.length - 1,
        "_" * times);
  }
}
