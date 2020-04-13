import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:questionnaire_flutter/models/form.dart';
import 'package:questionnaire_flutter/providers/formProvider.dart';



class ReportByFormScreen extends StatefulWidget {
  static final String routeName = '/reportbyform';

  @override
  _ReportByFormScreenState createState() => _ReportByFormScreenState();
}

class _ReportByFormScreenState extends State<ReportByFormScreen> {

  DateTime selectedDate = DateTime.now();

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  @override
  Widget build(BuildContext context) {
    final myForm form = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(title: Text(form.name),),
      body: FutureBuilder(
          future: Provider.of<FormProvider>(context, listen: false)
              .fetchFormQuery(form.id, selectedDate),
          builder: (_, snapshot) =>
              snapshot.connectionState == ConnectionState.waiting
                  ? Scaffold(
                      body: Center(child: CircularProgressIndicator()),
                    )
                  : Container())
      
    );
  }
}