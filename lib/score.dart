import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class Score {
  Future<List<dynamic>> getScore() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? scoresString = prefs.getString("scores");
    scoresString ??= "[]";
    return json.decode(scoresString);
  }

  Future<void> addScore(String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<dynamic> scoreList = await getScore();
    if (!scoreList.contains(value)) {
      scoreList.add(value);
    }
    String updatedScore = json.encode(scoreList);
    prefs.setString("scores", updatedScore);
  }
}
