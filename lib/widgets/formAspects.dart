import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:questionnaire_flutter/providers/formProvider.dart';

class FormAspects extends StatefulWidget {
  final List<Map<String, dynamic>> questions;
  final GlobalKey<ScaffoldState> scaffoldKey;
  FormAspects({this.questions, this.scaffoldKey});

  @override
  _FormAspectsState createState() => _FormAspectsState();
}

class _FormAspectsState extends State<FormAspects> {
  bool isPrivate = false;
  final Map<String, dynamic> _formInfo = {
    "name": "",
    "description": "",
    "estimated_time": "",
    "is_active": true,
    "is_private": false,
    "is_repeated": false,
    "password" : "",
    "times": []
  };

  List<bool> _selected = List.generate(24, (index) {
    return false;
  });

  List<String> _times = [
    '0',
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    '10',
    '11',
    '12',
    '13',
    '14',
    '15',
    '16',
    '17',
    '18',
    '19',
    '20',
    '21',
    '22',
    '23'
  ];

  List<String> _selectedTimes = [];

  final FocusNode nameFocusNode = new FocusNode();

  final FocusNode descriptionFocusNode = new FocusNode();

  final FocusNode estimatedTimeFocusNode = new FocusNode();

  final FocusNode isActiveFocusNode = new FocusNode();

  final FocusNode isPrivateFocusNode = new FocusNode();

  final FocusNode isRepeatedFocusNode = new FocusNode();

  final FocusNode passwordFocusNode = new FocusNode();

  final _formKey = GlobalKey<FormState>();

  bool _loading = false;

  Future<void> _createForm(FormProvider formProvider, BuildContext context) async {
    if (!_formKey.currentState.validate()) {
      setState(() {
        _loading = false;
      });
      return;
    } else {
      _formKey.currentState.save();
      await formProvider.createForm(_formInfo, widget.questions);
      setState(() {
        _loading = false;
      });
      Navigator.of(context).pop();
      widget.scaffoldKey.currentState.showSnackBar(
          SnackBar(
            content: Text(
              "Form Created Successfuly!",
              textAlign: TextAlign.center,
            ),
            elevation: 5,
            duration: Duration(seconds: 2),
            backgroundColor: Colors.green,
            action: SnackBarAction(
              label: "Dismiss",
              textColor: Colors.red,
              onPressed: () {
                widget.scaffoldKey.currentState.removeCurrentSnackBar();
              },
            ),

            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topRight: Radius.elliptical(100, 20),
                    topLeft: Radius.elliptical(100, 20)
                )
            ),
          )
      );
    }
  }


  Widget _formField(String title, Function validator, String value,
      TextInputType textInputType, Function onSaved, FocusNode currFocusNode,
      FocusNode nextFocusNode) {
    return Container(
      margin: EdgeInsets.only(bottom: 5.0),
      child: TextFormField(
        focusNode: currFocusNode,
        textInputAction: currFocusNode == isRepeatedFocusNode ? TextInputAction
            .done : TextInputAction.next,
        decoration: InputDecoration(
          hintText: title,
        ),
        keyboardType: textInputType,
        onSaved: onSaved,
        validator: validator,
        initialValue: value,
        onFieldSubmitted: (String value) {
          FocusScope.of(context).requestFocus(nextFocusNode);
        },
      ),
    );
  }

  _displayDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            // title: Text(
            //   "Choose Notification Times",
            //   textAlign: TextAlign.center,
            //   style: TextStyle(fontSize: 18.0),
            // ),
            // actions: <Widget>[
            //   RaisedButton(
            //     child: Text("Done"),
            //     onPressed: () {
            //       Navigator.of(context).pop();
            //     },
            //   ),
            // ],
            child: StatefulBuilder(
             builder: (BuildContext context, StateSetter setState) {
             return Container(
              width: double.infinity,
              margin: EdgeInsets.symmetric(horizontal: 5.0),
              child: ListView(
                  shrinkWrap: true,
                  children: _times.map((String time) {
                    return CheckboxListTile(
                      title: Text('${time}'),
                      value: _formInfo["times"].indexOf(time) != -1,
                      onChanged: (bool value) {
                        setState(() {
                          if (_formInfo["times"].indexOf(time) == -1) {
                            _formInfo["times"].add(time);
                          } else {
                            _formInfo["times"].remove(time);
                          }
                          print(_formInfo["times"]);
                        });
                      },
                      secondary: const Icon(Icons.hourglass_empty),
                    );
                  }).toList()
              ),
            );},
          ));
        }
    );
  }

  @override
  void initState() {
    print(widget.questions);
    super.initState();
    // TODO: implement initState

  }

  @override
  Widget build(BuildContext context) {
    final formProvider = Provider.of<FormProvider>(context, listen: false);
    final mediaSize = MediaQuery
        .of(context)
        .size;
    return Container(
      height: mediaSize.height * 0.6,
      width: double.infinity,
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: ListView(
        shrinkWrap: true,
        children: <Widget>[
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 5.0),
            margin: EdgeInsets.only(bottom: 10.0),
            decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.only(
                    bottomRight: Radius.elliptical(70, 30),
                    bottomLeft: Radius.elliptical(70, 30)
                )
            ),
            child: Text(
              "Form Aspects",
              textAlign: TextAlign.center,
            ),
          ),
          Container(
            margin: EdgeInsets.all(10.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  _formField(
                    "Form Title",
                        (String value) {
                      if (value.isEmpty) {
                        return "Requried";
                      }
                      return null;
                    },
                    _formInfo["name"],
                    TextInputType.text,
                        (value) {
                      _formInfo["name"] = value;
                    },
                    nameFocusNode,
                    descriptionFocusNode,
                  ),
                  _formField(
                      "Form Description",
                          (String value) {
                        if (value.isEmpty) {
                          return "Requried";
                        }
                        return null;
                      },
                      _formInfo["description"],
                      TextInputType.text,
                          (value) {
                        _formInfo["description"] = value;
                      },
                      descriptionFocusNode,
                      estimatedTimeFocusNode
                  ),
                  _formField(
                      "Estimated Time(In Minutes)",
                          (String value) {
                        if (value.isEmpty) {
                          return "Requried";
                        } else if (int.tryParse(value) == null ||
                            int.parse(value) <= 0) {
                          return "Invalid Input";
                        }
                        return null;
                      },
                      _formInfo["estimated_time"],
                      TextInputType.number,
                          (value) {
                        _formInfo["estimated_time"] = value;
                      },
                      estimatedTimeFocusNode,
                      passwordFocusNode,
                  ),
                  CheckboxListTile(
                    activeColor: Colors.blueGrey,
                    title: Text('Private'),
                    value: _formInfo["is_private"],
                    onChanged: (bool value) {
                      setState(() {
                        _formInfo["is_private"] = value;
                        isPrivate = value;
                      });
                    },
                  ),
                  isPrivate ? _formField(
                      "Password",
                          (String value) {
                        if (value.isEmpty) {
                          return "Requried";
                        }
                        return null;
                      },
                      _formInfo["password"],
                      TextInputType.text,
                          (value) {
                        _formInfo["password"] = value;
                      },
                      passwordFocusNode,
                      estimatedTimeFocusNode

                  ) : Container(),
                  Container(
                    margin: EdgeInsets.only(bottom: 10.0),
                    child: RaisedButton.icon(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0)
                      ),
                      elevation: 5,
                      label: Text(
                          "Select Notification Times",
                        textAlign: TextAlign.center,
                      ),
                      icon: Icon(Icons.access_time, color: Colors.grey,),
                      onPressed: () {
                        _displayDialog(context);
                      },
                    ),
                  ),
          ]),
            )
          ),
          Container(
            width: double.infinity,
            child: !_loading ? RaisedButton(
              elevation: 10.0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.elliptical(100, 20),
                      topRight: Radius.elliptical(100, 20))),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              onPressed: () async {
                setState(() {
                  _loading = true;
                });
                await _createForm(formProvider, context);

              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: Text(
                  "Create Form",
                  style: TextStyle(fontSize: 18.0),
                ),
              ),
            ) : Align(
              alignment: Alignment.center,
              child: CircularProgressIndicator(
                backgroundColor: Colors.white70,
              ),
            ),
          ),
        ]
      ),
    );
  }
}
