import 'package:flutter/material.dart';
import 'package:questionnaire_flutter/models/form.dart';

class ReportByFormScreen extends StatelessWidget {
  static final String routeName = '/reportbyform';
  @override
  Widget build(BuildContext context) {
    final myForm form = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(title: Text("Choose Form Data"),),
      body: Container(child: Text(form.name),),
      
    );
  }
}