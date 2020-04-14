import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:questionnaire_flutter/models/form.dart';
import 'package:questionnaire_flutter/providers/formProvider.dart';
import 'package:questionnaire_flutter/models/profile.dart';
import 'package:questionnaire_flutter/widgets/drawer.dart';
import 'package:questionnaire_flutter/widgets/myform_item.dart';

import '../widgets/errorDialog.dart';



class MyFormsSceen extends StatefulWidget {
  static final routeName = "/myform";
  @override
  _MyFormsSceenState createState() => _MyFormsSceenState();
}

class _MyFormsSceenState extends State<MyFormsSceen> {
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

  Future<bool> _showConfirmationDialog(BuildContext context, String action) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Are you sure you wish to $action this item?"),
          actions: <Widget>[
            FlatButton(
              child: const Text('Delete', style: TextStyle(color: Colors.white70)),
              color: Colors.red,
              onPressed: () {
                Navigator.pop(context, true); // showDialog() returns true
              },
            ),
            FlatButton(
              child: const Text('Cancel', style: TextStyle(color: Colors.white70),),
              color: Colors.grey,
              onPressed: () {
                Navigator.pop(context, false); // showDialog() returns false
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final formProvider = Provider.of<FormProvider>(context, listen: false);
    return Scaffold(
      // drawer: MainDrawer(),
        appBar: AppBar(
          elevation: 5,
          title: Text("My Forms"),
          centerTitle: true,
        ),
        body: Container(
          margin: EdgeInsets.all(5.0),
          child: ListView.builder(
            itemBuilder: (context, index) {
              return Dismissible(
                direction: DismissDirection.startToEnd,
                  key: Key('$index'),
                  background: Container(
                    margin: EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        gradient: LinearGradient(
                            colors: [
                              Colors.red,
                              Colors.redAccent
                            ]
                        )
                    ),
                    child: Container(
                      margin: EdgeInsets.only(left: 20.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Icon(
                          Icons.delete,
                          color: Colors.white,
                          size: 50.0,
                        ),
                      ),
                    ),
                  ),
                  confirmDismiss: (DismissDirection direction) async {
                    return _showConfirmationDialog(context, "delete");
                  },
                  onDismissed: (dir) async {
                    await formProvider.removeMyForm(mymyFormsList[index].id);
                  },
                child: MyFormItem(form: mymyFormsList[index],)
              );
            },
            itemCount: mymyFormsList.length,
          ),
        )
    );}}