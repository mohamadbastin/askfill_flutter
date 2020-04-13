import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:questionnaire_flutter/models/form.dart';
import 'package:questionnaire_flutter/providers/formProvider.dart';


class ReportByQuesScreen extends StatefulWidget {
  @override
  _ReportByQuesScreenState createState() => _ReportByQuesScreenState();
}

class _ReportByQuesScreenState extends State<ReportByQuesScreen> {
  int ppid = 0;

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
    final int qid = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(title: Text('Answers'),),
      body: FutureBuilder(
        future: Provider.of<FormProvider>(context, listen: false).fetchQuestionQuery(qid, ppid, selectedDate),
        builder: (_, snapshot) => snapshot.connectionState == ConnectionState.waiting
            ? Scaffold(
                body: Center(child: CircularProgressIndicator()),
              )
            : QuesRes()
        
      ),
      
    );
  }
}



class QuesRes extends StatefulWidget {
  @override
  _QuesResState createState() => _QuesResState();
}

class _QuesResState extends State<QuesRes> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
        itemCount: byquesquery.length,
        itemBuilder: (context, index) { 

          return QuestionResItem(index: index,answer: byquesquery[index]);
        }),
      
    );
  }
}


class QuestionResItem extends StatefulWidget {
  final answer;
  final int index;

  QuestionResItem({this.answer, this.index});


  @override
  _QuestionResItemState createState() => _QuestionResItemState();
}

class _QuestionResItemState extends State<QuestionResItem> {
  @override
  Widget build(BuildContext context) {
    return Container(

      child: Column(children: <Widget>[
        Row(children: [
          
        ])
      ],)
      
    );
  }
}