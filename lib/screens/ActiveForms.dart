import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:questionnaire_flutter/models/form.dart';
import 'package:questionnaire_flutter/providers/formProvider.dart';
import 'package:questionnaire_flutter/models/profile.dart';
import 'package:questionnaire_flutter/widgets/drawer.dart';
import 'package:questionnaire_flutter/widgets/form_item.dart';


class ActiveFormsSceen extends StatefulWidget {
  static final routeName = "/active";
  @override
  _ActiveFormsSceenState createState() => _ActiveFormsSceenState();
}

class _ActiveFormsSceenState extends State<ActiveFormsSceen> {
  @override
  Widget build(BuildContext context) {
    final form = Provider.of<FormProvider>(context, listen: false);
    return FutureBuilder(
        future: form
            .fetchAndSetActiveForms(),
        builder: (_, snapshot) => RefreshIndicator(
              onRefresh: form
                  .fetchAndSetActiveForms,
              child: snapshot.connectionState == ConnectionState.waiting
                  ? Scaffold(
                      body: Center(child: CircularProgressIndicator()),
                    )
                  : ActiveForms(),
            ));
  }
}

// TODO add delete dismissable is ready in profile named removeParticipate(form id)

class ActiveForms extends StatefulWidget {
  @override
  _ActiveFormsState createState() => _ActiveFormsState();
}

class _ActiveFormsState extends State<ActiveForms> {
  List<myForm> ic;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final profile = Provider.of<Profile>(context, listen: false);
    return Scaffold(
      // drawer: MainDrawer(),
        appBar: AppBar(
          elevation: 5,
          title: Text("Active Forms"),
          centerTitle: true,
        ),
        body: Container(
          margin: EdgeInsets.all(5.0),
          child: ListView.builder(
            itemBuilder: (context, index) {
              return Dismissible(
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
                direction: DismissDirection.startToEnd,
                child: FormItem(form: activeFormsList[index],),
                onDismissed: (dir) async {
                  await profile.removeParticipate(activeFormsList[index].id);
              },
              );
            },
            itemCount: activeFormsList.length,
          ),
        )
    );}}