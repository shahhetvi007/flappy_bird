import 'package:flutter/material.dart';
import 'package:spell_itt_demo/alert.dart';
import 'package:spell_itt_demo/game_data.dart';
import 'package:spell_itt_demo/score.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Spell it'),
      //   centerTitle: true,
      // ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.center,
                child: CircleAvatar(
                  backgroundImage: AssetImage('assets/logo.png'),
                  radius: 100,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: _goToGame,
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                child: Text('Start Game'),
              ),
            )
          ],
        ),
      ),
    );
  }

  dynamic _goToGame() async {
    GameData instance = GameData();
    await instance.getQuestions();

    if (instance.questions[0] == -1) {
      if (!mounted) return;
      Alert().showAlert(
          context, 'Error!', "Please ensure you have an internet connection.");
      return;
    } else if (instance.questions[0] == -2) {
      if (!mounted) return;
      Alert().showAlert(
          context, 'Error!', "Something went wrong. Please try again later.`");
      return;
    }
    Score gameScore = Score();

    List<dynamic> gameScoreList = await gameScore.getScore();

    if (!mounted) return;
    Navigator.pushNamed(context, '/game', arguments: {
      'questions': instance.questions,
      'gameScoreList': gameScoreList,
      'gameScore': gameScore
    });
  }
}
