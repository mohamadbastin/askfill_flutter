import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:questionnaire_flutter/models/form.dart';
import 'package:questionnaire_flutter/providers/formProvider.dart';
import 'package:questionnaire_flutter/models/profile.dart';
import 'package:questionnaire_flutter/widgets/drawer.dart';
import 'package:questionnaire_flutter/widgets/myform_item.dart';

import '../widgets/errorDialog.dart';



class ChooseFormsSceen extends StatefulWidget {
  static final routeName = "/chooseform";
  @override
  _ChooseFormsSceenState createState() => _ChooseFormsSceenState();
}

class _ChooseFormsSceenState extends State<ChooseFormsSceen> {
  @override
  Widget build(BuildContext context) {
    final form = Provider.of<FormProvider>(context, listen: false);
    return FutureBuilder(
        future: form
            .fetchAndSetmymyForms(),
        builder: (_, snapshot) => RefreshIndicator(
              onRefresh: form
                  .fetchAndSetmymyForms,
              child: snapshot.connectionState == ConnectionState.waiting
                  ? Scaffold(
                      body: Center(child: CircularProgressIndicator()),
                    )
                  : snapshot.hasError? ErrorDialog(message: servermsg, ctx: context)
                  :MyForms(),
            ));
  }
}

// TODO add delete dismissable is ready in profile named removeParticipate(form id)

class MyForms extends StatefulWidget {
  @override
  _MyFormsState createState() => _MyFormsState();
}

class _MyFormsState extends State<MyForms> {
  List<myForm> ic;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // drawer: MainDrawer(),
        appBar: AppBar(
          elevation: 5,
          title: Text("Choose Form..."),
          centerTitle: true,
        ),
        body: Container(
          margin: EdgeInsets.all(5.0),
          child: ListView.builder(
            itemBuilder: (context, index) {
              return ChooseFormItem(form: mymyFormsList[index],);
            },
            itemCount: mymyFormsList.length,
          ),
        )
    );}}