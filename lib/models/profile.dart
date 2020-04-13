import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:questionnaire_flutter/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

Profile myProfilee = Profile(name: "boz");
String authtoken;
class Profile with ChangeNotifier {
  int id;
  String name;
  String email;
  String picture;
  String phone;
  String token;
  bool notifications = false;

  Profile({this.id, this.name, this.email, this.phone, this.picture});

  bool get isAuth {
    return token != null;
  }

  Future<bool> autologin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey("askfilltoken")) {
      return false;
    }
    // add other information
    token = prefs.getString("askfilltoken");
    authtoken = token;
    await getProfile();
    notifyListeners();
    return true;
  }

  Future<void> sendCode(String phone, String name) async {
    await http.post("$host/register/",
        body: json.encode({
          'phone': phone,
          'name': name
        }),
        headers: {
          'Content-Type': 'application/json',
        }).then((value) => print(value.body));
    print("sending code");
  }

  Future<void> login(String pin, String phone) async {
    final res = await http.post("$host/login/",
        body: json.encode({'username': phone, 'password': pin}),
        headers: {
          'Content-Type': 'application/json',
        });
    print("got in");

    print(res);
    print(res.body);
    token = json.decode(res.body)['token'];
    print(authtoken);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('askfilltoken', token);
    authtoken = token;

    await getProfile();
    notifyListeners();
  }

  Future<void> logout() async {
    name = null;
    phone = null;
    authtoken = null;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
    notifyListeners();
  }

  void changeNotificationStatus(bool value) {
    notifications = value;
    notifyListeners();
  }

  Future<String> participate(String password, int fid) async {
    String formid = fid.toString();
    var res = await http.post("$host/participate/$formid",
        body: json.encode({
          'password':password,
        }),
        headers: {
          'Content-Type': 'application/json',
          "Authorization": "Token " + authtoken.toString(),
        });
    print("participating");
    if (json.decode(res.body)["msg"] == "ok") {return "yes";} else {return "no";}


  }


  Future<String> removeParticipate(int fid) async {
    String formid = fid.toString();
    var res = await http.post("$host/removeparticipate/$formid",
        body: json.encode({
        }),
        headers: {
          'Content-Type': 'application/json',
          "Authorization": "Token " + authtoken.toString(),
        });
    print("removing participating");
    if (json.decode(res.body)["msg"] == "ok") {return "yes";} else {return "no";}


  }

  Future<void> getProfile() async {
    var res = await http.get("$host/profile/",

        headers: {
          'Content-Type': 'application/json',
          "Authorization": "Token " + authtoken.toString(),
        });
    print("profiling");
    var b =json.decode(res.body);
    myProfilee.name = b["name"];

  }
}