import 'package:flutter/material.dart';
import 'package:questionnaire_flutter/models/form.dart';

class SingleFormScreen extends StatefulWidget {
  static const routeName = "/singleForm";

  @override
  _SingleFormScreenState createState() => _SingleFormScreenState();
}

class _SingleFormScreenState extends State<SingleFormScreen> {
  @override
  Widget build(BuildContext context) {
    final myForm form = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        elevation: 5,
        title: Text(form.name),
        centerTitle: true,
      ),
    );
  }
}


