import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GameData {
  List<dynamic> questions = [];

  Future<void> getQuestions() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    String? cachedData = prefs.getString('questions');

    if (cachedData != null) {
      // Check for expiry in cache
      Map cache = json.decode(cachedData);

      var now = DateTime.now();
      var expiry = DateTime.parse(cache['expiry']);
      var difference = now.difference(expiry);

      // Save cache for only 1 day
      if (difference.inDays > 1) {
        // remove this cache
        prefs.remove('questions');
        // make api call for new questions
        await makeAPIRequest();
      } else {
        // serve from cache
        questions = cache['questions'];
      }
    } else {
      // Make API call
      await makeAPIRequest();
    }
  }

  Future<void> makeAPIRequest() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();

      Response response = await get(
          Uri.parse('https://ms.akashrajpurohit.com/api/spell-it/level/easy'));

      Map data = json.decode(response.body);

      questions = data['data'];
      print(questions);

      Map cacheData = {
        'questions': data['data'],
        'expiry': DateTime.now().toString()
      };

      prefs.setString('questions', json.encode(cacheData));
    } on SocketException catch (e) {
      questions = [-1];
    } catch (e) {
      print(e);
      questions = [-2];
    }
  }
}
