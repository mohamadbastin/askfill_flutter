import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:questionnaire_flutter/models/form.dart';
import 'package:questionnaire_flutter/models/profile.dart';
import 'package:questionnaire_flutter/main.dart';
import 'package:questionnaire_flutter/widgets/errorDialog.dart';


String servermsg = "خطا در برقراری ارتباط با سرور!";
List<myForm> myFormsList = [];
List<myForm> activeFormsList = [];
List<myForm> mymyFormsList = [];
List<Map<String, dynamic>> formQuestions = [];
List<Map<String, dynamic>> byquesquery = [];

class FormProvider with ChangeNotifier {
  List<myForm> _myForms = [];
  List<Map<String, dynamic>> _formQuestions = [];

  List<myForm> get myForms {
    List<myForm> myForms = [];
    for (var form in _myForms) {
      myForms.add(form);
    }
    return myForms;
  }

  List<Map<String, dynamic>> get singleFormQuestions {
    List<Map<String, dynamic>> questions = [];
    for (var question in _formQuestions) {
      questions.add(question);
    }
    return questions;
  }

  Future<void> fetchAndSetmyForms() async {
    print(authtoken);
    // String token = await Provider.of<Profile>(context, listen: false).token;
    // print ("asfg");
    var response = await http.get(host + "/form/list/", headers: {
      "Accept": "application/json",
      'Content-Type': 'application/json',
      "Authorization": "Token " + authtoken.toString(),
    });

    // print(response.body);

    var extractedData = List<Map<String, dynamic>>.from(
        jsonDecode(utf8.decode(response.bodyBytes)));

    // print(extractedData);

    final List<myForm> extractedList = [];
    // print(extractedData.length);
    // print(2);

    extractedData.forEach((form) {
      var i = form['author'];
      Profile tmp_profile = new Profile(
          id: i['id'],
          name: i['name'],
          phone: i['phone'],
          email: i['email'],
          picture: i['picture']);

      // print(3);

      List<int> times = [];
      // print(form['time']);
      for (int j = 0; j < form['time'].length; j++) {
        // print();
        times.add(int.parse(form['time'][j]['hour']));
      }
      // print(4);
      print(form['name']);
      // print(times.length);

      extractedList.add(myForm(
          id: form['id'],
          name: form['name'],
          author: tmp_profile,
          description: form['description'],
          is_active: form['is_active'],
          is_private: form['is_private'],
          is_repeated: form['is_repeated'],
          created: form['created'],
          estimated_time: form['estimated_time'],
          duration: form['duration_days'],
          times: times));
      // print(MediaQuery.of(context));
    });
    _myForms = extractedList;
    myFormsList = extractedList;
    // print(_myForms);
    // print(_myForms.length);
    notifyListeners();
  }

  Future<void> fetchFormQuestions(int formId) async {
    print("formId" + formId.toString());
    final response = await http.get(host + "/form/questions/$formId", headers: {
      "Accept": "application/json",
      'Content-Type': 'application/json',
      "Authorization": "Token " + authtoken.toString(),
    });
    print(response.body);
    final extractedData = List<Map<String, dynamic>>.from(
        jsonDecode(utf8.decode(response.bodyBytes)));
    _formQuestions = extractedData;
    formQuestions = extractedData;
    notifyListeners();
    print(extractedData);
    print("sdfbjsb;snd;bns");
    print(formQuestions);
  }

  myForm findById(int id) {
    return _myForms.firstWhere((form) {
      return form.id == id;
    });
  }

  Future<void> fetchAndSetActiveForms() async {
    // String token = await Provider.of<Profile>(context, listen: false).token;
    // print ("asfg");
    // String formid = fid.toString();
    var response = await http.get(host + "/answered-form/", headers: {
      "Accept": "application/json",
      'Content-Type': 'application/json',
      "Authorization": "Token " + authtoken.toString(),
    });

    print(response.body);

    var extractedData = List<Map<String, dynamic>>.from(
        jsonDecode(utf8.decode(response.bodyBytes)));

    // print(extractedData);

    final List<myForm> extractedList = [];
    // print(extractedData.length);
    // print(2);

    extractedData.forEach((form) {
      var i = form['author'];
      Profile tmp_profile = new Profile(
          id: i['id'],
          name: i['name'],
          phone: i['phone'],
          email: i['email'],
          picture: i['picture']);

      // print(3);

      List<int> times = [];
      // print(form['time']);
      for (int j = 0; j < form['time'].length; j++) {
        // print();
        times.add(int.parse(form['time'][j]['hour']));
      }
      // print(4);
      print(form['name']);
      // print(times.length);

      extractedList.add(myForm(
          id: form['id'],
          name: form['name'],
          author: tmp_profile,
          description: form['description'],
          is_active: form['is_active'],
          is_private: form['is_private'],
          is_repeated: form['is_repeated'],
          created: form['created'],
          estimated_time: form['estimated_time'],
          duration: form['duration_days'],
          times: times));
      // print(MediaQuery.of(context));
    });
    // _myForms = extractedList;
    activeFormsList = extractedList;
    // print(_myForms);
    // print(_myForms.length);
    notifyListeners();
  }

  Future<void> fetchAndSetmymyForms() async {
    // String token = await Provider.of<Profile>(context, listen: false).token;
    // print ("asfg");
    // String formid = fid.toString();
    var response = await http.get(host + "/user/created-forms/", headers: {
      "Accept": "application/json",
      'Content-Type': 'application/json',
      "Authorization": "Token " + authtoken.toString(),
    });

    // print(response.body);

    var extractedData = List<Map<String, dynamic>>.from(
        jsonDecode(utf8.decode(response.bodyBytes)));

    // print(extractedData);

    final List<myForm> extractedList = [];
    // print(extractedData.length);
    // print(2);

    extractedData.forEach((form) {
      var i = form['author'];
      Profile tmp_profile = new Profile(
          id: i['id'],
          name: i['name'],
          phone: i['phone'],
          email: i['email'],
          picture: i['picture']);

      // print(3);

      List<int> times = [];
      // print(form['time']);
      for (int j = 0; j < form['time'].length; j++) {
        // print();
        times.add(int.parse(form['time'][j]['hour']));
      }
      // print(4);
      // print(form['name']);
      // print(times.length);

      extractedList.add(myForm(
          id: form['id'],
          name: form['name'],
          author: tmp_profile,
          description: form['description'],
          is_active: form['is_active'],
          is_private: form['is_private'],
          is_repeated: form['is_repeated'],
          created: form['created'],
          estimated_time: form['estimated_time'],
          duration: form['duration_days'],
          times: times));
      // print(MediaQuery.of(context));
    });
    // _myForms = extractedList;
    mymyFormsList = extractedList;
    // print(_myForms);
    // print(_myForms.length);
    notifyListeners();
  }

  Future<void> createForm(Map<String, dynamic> formInfo,
      List<Map<String, dynamic>> questions) async {
    List<Map<String, dynamic>> _singleFormQuestions = [];
    questions.forEach((question) {
      if (question["type"].toLowerCase() == "text") {
        _singleFormQuestions.add({
          "type": question["type"].toLowerCase(),
          "text": question["text"],
          "number": questions.indexOf(question) + 1,
          "description": ""
        });
      } else if (question["type"].toLowerCase() == "range") {
        _singleFormQuestions.add({
          "type": question["type"].toLowerCase(),
          "text": question["text"],
          "number": questions.indexOf(question) + 1,
          "description": "",
          "start_text": question["start_text"],
          "end_text": question["end_text"],
        });
      } else {
        // choice type
        List<Map<String, dynamic>> _questionChoices = [];
        question["choices"].forEach((choice) {
          _questionChoices.add({"text": choice["controller"].text});
        });
        _singleFormQuestions.add({
          "type": question["type"].toLowerCase(),
          "text": question["text"],
          "number": questions.indexOf(question) + 1,
          "description": "",
          "choice_type": question["choice_type"],
          "choices": _questionChoices
        });
      }
    });

    if (formInfo["times"].isNotEmpty) {
      formInfo["is_repeated"] = true;
    }

    print(formInfo);

    print(_singleFormQuestions);

    var response = await http
        .post(host + "/form/create/", body: json.encode(formInfo), headers: {
      "Accept": "application/json",
      'Content-Type': 'application/json',
      "Authorization": "Token " + authtoken.toString(),
    });

    print("here");
    print(response.body);
//
//    if (res1.statusCode == 201){
//      print("form created");
//      var id = json.decode(res1.body)["form_id"].toString();

// # [
//     #     {
//     #         "type": "text"/"choice"/"range"
//     #         "text"
//     #         "number"
//     #         "description"
//     #
//     #         //"text"
//     #
//     #         //"range"
//     #         start
//     #         start text
//     #         end
//     #         end text
//     #
//     #         //choice
//     #         choice_type MA SA
//     #         choices:[
//     #              {
//     #                  text
//     #              }
//     #         ]
//     #     }
//     # ]
    var id = json.decode(response.body)["form_id"];

    var formQuestionResponse = await http.post(
        host + "/form/question/create/$id",
        body: json.encode(_singleFormQuestions),
        headers: {
          "Accept": "application/json",
          'Content-Type': 'application/json',
          "Authorization": "Token " + authtoken.toString(),
        });

    print(formQuestionResponse.body);
  }

  Future<void> submitFormAnswers(
      List<Map<String, dynamic>> userAnswers, int formId) async {
    print("formId" + formId.toString());

    List<Map<String, dynamic>> formAnswers = [];

    userAnswers.forEach((userAnswer) {
      if (userAnswer["type"] == "text") {
        formAnswers.add({
          "question": userAnswer["question"],
          "text": userAnswer["answer"].text
        });
      } else if (userAnswer["type"] == "choice") {
        var choices = userAnswer["answer"];
        var selectedChoices = [];
        choices.forEach((choice) {
          if (choice["value"]) {
            selectedChoices.add({"id": choice["id"]});
          }
        });
        formAnswers.add(
            {"question": userAnswer["question"], "choices": selectedChoices});
      } else {
        formAnswers.add({
          "question": userAnswer["question"],
          "number": userAnswer["answer"]
        });
      }
    });

    print(formAnswers);

    final response = await http.post(host + "/form/answer/$formId",
        body: json.encode(formAnswers),
        headers: {
          "Accept": "application/json",
          'Content-Type': 'application/json',
          "Authorization": "Token " + authtoken.toString(),
        });

    print(response.body);
  }

  Future<void> fetchQuestionQuery(int qid, int ppid, String date) async {
    // print("formId" + formId.toString());
    if (date==DateTime.now().toString().substring(0,10)){
      date = "all";
    }
    // print(date==DateTime.now().toString().substring(0,10));
    final response = await http.post(
        host + "/form/participant/answered-form/$qid/$ppid",
        body: json.encode({
          // 'ppid': ppid.toString(),
          "date": date.toString()
        }),
        headers: {
          "Accept": "application/json",
          'Content-Type': 'application/json',
          "Authorization": "Token " + authtoken.toString(),
        }
    );
    print(response.body);
    final extractedData = List<Map<String, dynamic>>.from(
        jsonDecode(utf8.decode(response.bodyBytes)));
    // _formQuestions = extractedData;
    byquesquery = extractedData;
    notifyListeners();
    // print(extractedData);
    print("sdfbjsb;snd;bns");
    print(byquesquery);
  }


  Future<void> fetchFormQuery(int qid, String date) async {
    // print("formId" + formId.toString());
    if (date==DateTime.now().toString().substring(0,10)){
      date = "all";
    }
    final response = await http.post(
        host + "/form/answered-forms/$qid",
        body: json.encode({
          // 'ppid': ppid.toString(),
          "date": date.toString()
        }),
        headers: {
          "Accept": "application/json",
          'Content-Type': 'application/json',
          "Authorization": "Token " + authtoken.toString(),
        }
    );
    print(response.body);
    final extractedData = List<Map<String, dynamic>>.from(
        jsonDecode(utf8.decode(response.bodyBytes)));
    // _formQuestions = extractedData;
    byquesquery = extractedData;
    notifyListeners();
    // print(extractedData);
    print("anbaskjbgksbglasfg");
    print(byquesquery);
  }


  Future<void> fetchFormParts(int formId) async {
    print("formId" + formId.toString());
    final response = await http.get(
        host + "/form/participants/$formId",
        headers: {
          "Accept": "application/json",
          'Content-Type': 'application/json',
          "Authorization": "Token " + authtoken.toString(),
        }
    );
    print(response.body);
    final extractedData = List<Map<String, dynamic>>.from(
        jsonDecode(utf8.decode(response.bodyBytes)));
    _formQuestions = extractedData;
    formQuestions = extractedData;
    notifyListeners();
    print(extractedData);
    print("sdfbjsb;snd;bns");
    print(formQuestions);
  }

  Future<bool> removeMyForm(int formId) async {
    final response = await http.get("$host/form/delete/$formId",
        headers: {
          "Accept": "application/json",
          'Content-Type': 'application/json',
          "Authorization": "Token " + authtoken.toString(),
        });
    print("removing participating");
    if (json.decode(response.body)["msg"] == "ok") {return true;} else {return false;}
  }
}
