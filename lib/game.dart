import 'package:flutter/material.dart';
import 'package:spell_itt_demo/game_page.dart';
import 'package:spell_itt_demo/score.dart';

class Game extends StatefulWidget {
  const Game({Key? key}) : super(key: key);

  @override
  State<Game> createState() => _GameState();
}

class _GameState extends State<Game> {
  dynamic data;
  List<dynamic> questions = [];
  List<dynamic> gameScoreList = [];
  Score gameScore = Score();

  void getGameScore() async {
    gameScoreList = await gameScore.getScore();
  }

  @override
  Widget build(BuildContext context) {
    data = ModalRoute.of(context)?.settings.arguments;
    questions = data['questions'];
    gameScoreList = data['gameScoreList'];
    gameScore = data['gameScore'];
    getGameScore();
    return Scaffold(
      body: PageView.builder(
          itemCount: questions.length,
          onPageChanged: (index) {
            setState(() {});
          },
          itemBuilder: (ctx, index) {
            return GamePage(
                question: questions[index],
                gameScoreList: gameScoreList,
                gameScore: gameScore);
          }),
    );
  }
}
