import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:joke_generater/models/joke.dart';

class JokeService {
  static const String _url = 'https://v2.jokeapi.dev/joke/Programming?lang=en';

  static Future<Joke> browse() async {
    http.Response response = await http.get(Uri.parse(_url));

    String content = response.body;
    final jokeMap = jsonDecode(content) as Map<String, dynamic>;
    final joke = Joke.fromJson(jokeMap);

    return joke;
  }
}
