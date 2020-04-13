import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:questionnaire_flutter/models/profile.dart';
import 'package:questionnaire_flutter/providers/FormQuestionListProvider.dart';
import '../main.dart';

class myForm with ChangeNotifier {
  final int id;
  String name;
  final Profile author;
  String description;
  final bool is_private;
  final String created;
  int estimated_time;
  bool is_repeated;
  int duration;
  bool requested;
  bool is_active;
  List<int> times;
  // FormQuestionListProvider questions;

  myForm(
      {@required this.id,
      @required this.name,
      @required this.author,
      @required this.description,
      @required this.is_private,
      @required this.created,
      @required this.estimated_time,
      @required this.is_repeated,
      this.requested,
      this.duration,
      @required this.is_active,
      this.times});

  String get formName {
    return name;
  }

  Future<bool> isFilled(String token) async {
    var response = await http.get("$host/form/is-filled/$id", headers: {
      "Accept": "application/json",
      'Content-Type': 'application/json',
      "Authorization": "Token " + token.toString(),
    });
    var is_filled = jsonDecode(utf8.decode(response.bodyBytes));
    if (is_filled["is_filled"] == true) {
      var answerres = await http.get("$host/form/my-answer/$id", headers: {
        "Accept": "application/json",
        'Content-Type': 'application/json',
        "Authorization": "Token " + token.toString(),
      });

      // TODO
      return true;
    } else {
      return false;
    }
  }

  Future<void> fetchAndSetQuestions(String token) async {
    var response = await http.get("$host/form/questions/$id", headers: {
      "Accept": "application/json",
      'Content-Type': 'application/json',
      "Authorization": "Token " + token.toString(),
    });

    var questions = List<Map<String, dynamic>>.from(
        jsonDecode(utf8.decode(response.bodyBytes)));

  }


}
