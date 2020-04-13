import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:questionnaire_flutter/models/form.dart';
import 'package:questionnaire_flutter/providers/formProvider.dart';
import 'package:questionnaire_flutter/widgets/question_item.dart';

class ChooseQuesScreen extends StatelessWidget {
  static final String routeName = '/byques';
  @override
  Widget build(BuildContext context) {
    final myForm form = ModalRoute.of(context).settings.arguments;
    return Scaffold(
        appBar: AppBar(
          title: Text("Choose Question"),
        ),
        body: FutureBuilder(
            future: Provider.of<FormProvider>(context, listen: false)
                .fetchFormParts(form.id),
            builder: (_, snapshot) =>
                snapshot.connectionState == ConnectionState.waiting
                    ? Scaffold(
                        body: Center(child: CircularProgressIndicator()),
                      )
                    :
                    // Container()
                    FormQuestionss(form:form)));
  }
}

class FormQuestionss extends StatefulWidget {
  final form;
  FormQuestionss({this.form});
  @override
  _FormQuestionssState createState() => _FormQuestionssState();
}

class _FormQuestionssState extends State<FormQuestionss> {
  @override
  Widget build(BuildContext context) {
    // print()
    return ListView.builder(
        itemCount: formQuestions.length,
        itemBuilder: (context, index) {
          // return Container(child: Text(formQuestions[index]['question']['text'].toString()));

          // return QuestionsItem(index: index,question: formQuestions[index]['question']);
          return Column(
            children: <Widget>[
              InkWell(
                onTap: (){
                  var b = {"form" : widget.form, "qid": formQuestions[index]['id']};
              Navigator.pushNamed(context, '/repbyq', arguments: [formQuestions[index]['id'], widget.form]);
                },
                                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 60,
                  child: Center(
                                  child: Column(
                      children: <Widget>[
                        SizedBox(height: 20,),
                        Align(
                          alignment: Alignment.center,
                          child: Center(
                                                  child: Row(children: [
                              Flexible(
                                  flex: 1,
                                  child: Icon(
                                    Icons.account_box,
                                    color: Colors.white,
                                  )),
                              SizedBox(
                                width: 5,
                              ),
                              Flexible(
                                flex: 5,
                                child: Text(formQuestions[index]["name"]),
                              )
                            ]),
                          ),
                        ),
                        // Divider()
                      ],
                    ),
                  ),
                ),
              ),
              Divider()
            ],
          );
        });
  }
}

class QuestionsItem extends StatefulWidget {
  final question;
  final int index;

  QuestionsItem({this.question, this.index});

  @override
  _QuestionsItemState createState() => _QuestionsItemState();
}

class _QuestionsItemState extends State<QuestionsItem> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: null,
      child: Container(
          // height: 100,
          margin: EdgeInsets.only(bottom: 10.0),
          padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 5.0),
          decoration: BoxDecoration(
              color: Colors.white30, borderRadius: BorderRadius.circular(10.0)),
          // width: 200,
          child: Row(
            children: <Widget>[
              Flexible(
                fit: FlexFit.tight,
                flex: 5,
                child: Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                        '${widget.index + 1}. ${widget.question["text"]}')),
              ),
              Flexible(
                flex: 1,
                fit: FlexFit.tight,
                child: Container(
                    alignment: Alignment.bottomRight,
                    child: Text(
                      widget.question["type"],
                      style: TextStyle(fontSize: 15.0, color: Colors.blue),
                    )),
              ),
            ],
          )),
    );
  }
}
