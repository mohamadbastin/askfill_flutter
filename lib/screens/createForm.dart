import 'dart:async';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:questionnaire_flutter/widgets/errorDialog.dart';
import 'package:questionnaire_flutter/widgets/formAspects.dart';
import 'package:questionnaire_flutter/widgets/question_item.dart';

class CreateFormScreen extends StatefulWidget {
  static const routeName = '/createForm';

  @override
  _CreateFormScreenState createState() => _CreateFormScreenState();
}

class _CreateFormScreenState extends State<CreateFormScreen> {
  final _formKey = GlobalKey<FormState>();
  List<String> questionTypes = ["Text", "Choice", "Range"];
  String _questionType = "Text";
  List<Map<String, dynamic>> _questions = [];
  TextEditingController _questionTextController = new TextEditingController();
  TextEditingController _currentChoiceController = new TextEditingController();
  TextEditingController _lowThresholdController = new TextEditingController();
  TextEditingController _highThresholdController = new TextEditingController();
  bool _scrollParent = false;
  final _choiceFocusNode = new FocusNode();
  ScrollController controller;
  List<Map<String, dynamic>> _choices = [];
  bool _multiChoice = false;
  final appBar = AppBar(
    elevation: 5,
    title: Text("Create Form"),
    centerTitle: true,
  );
  final listViewScrollController = new ScrollController();

  _createQuestion() {
    if (!_formKey.currentState.validate()) {
      print("val");
      return;
    } else if (_questionType == "Choice") {
      if (_currentChoiceController.text.isNotEmpty) {
        _choices.add({
          "text": _questionTextController.text,
          "controller": _currentChoiceController
        });
      }
      if (_choices.isEmpty) {
        showDialog(
          context: context,
          builder: (context) {
            return ErrorDialog(message: "Choice Questions Must Have At Least One Choice", ctx: context);
          }
        );
      }
    }
    Map<String, dynamic> _currentQuestion = {
      "text": "",
      "type": _questionType,
    };
    _currentQuestion["text"] = _questionTextController.text;
    if (_questionType == "Choice") {
      _currentQuestion["choices"] = _choices;
      _currentQuestion["choice_type"] = (_multiChoice) ? "MA" : "SA";
    } else if (_questionType == "Range") {
      _currentQuestion["start_text"] = _lowThresholdController.text;
      _currentQuestion["end_text"] = _highThresholdController.text;
    }
    setState(() {
      _choices = [];
      _questionTextController.text = "";
      _lowThresholdController.text = "";
      _highThresholdController.text = "";
    });
    _currentChoiceController = new TextEditingController();
    _questions.add(_currentQuestion);
    print(_questions);
  }

  _addChoice() {
    String choice = _currentChoiceController.text;
    if (choice == null || choice.isEmpty) {
      showDialog(
        context: context,
        builder: (context) {
          return ErrorDialog(message: "Please Fill the Current Choice", ctx: context);
        }
      );
      return;
    }
    setState(() {
      _choices.add({
        "text": choice,
        "controller": _currentChoiceController
      });
      _currentChoiceController = new TextEditingController();
    });
    print(_choices);
    FocusScope.of(context).requestFocus(_choiceFocusNode);

  }

//  _validateQuestion(Map<String, dynamic> question) {
//    if (_questionType == )
//  }

  _removeChoice(choice) {
    choice["controller"].dispose();
    setState(() {
      _choices.remove(choice);
    });
  }

  _setFormAspects(BuildContext context) {
    showModalBottomSheet(
        isScrollControlled: true,
        elevation: 10,
        context: context,
        builder: (context) => GestureDetector(
              onDoubleTap: () {
                Navigator.of(context).pop();
              },
              behavior: HitTestBehavior.opaque,
              child: FormAspects(questions: _questions, scaffoldKey: _scaffoldKey,),
            ));
  }

  _scrollToBottom() {
    listViewScrollController.animateTo(
        listViewScrollController.position.maxScrollExtent * 2,
        duration: Duration(milliseconds: 200),
        curve: Curves.easeOut);
  }

  void _onReorder(int oldIndex, int newIndex) {
    print(oldIndex);
    print(newIndex);
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }
    setState(() {
      final Map<String, dynamic> item = _questions.removeAt(oldIndex);
      _questions.insert(newIndex, item);

    });
    print(_questions);
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final mediaSize = MediaQuery.of(context).size;
    final padding = MediaQuery.of(context).padding;
    return Scaffold(
      key: _scaffoldKey,
      appBar: appBar,
      body: new GestureDetector(
        onTap: () {
            FocusScope.of(context).requestFocus(new FocusNode());
          },
              child: SingleChildScrollView(
          child: Container(
            width: mediaSize.width,
            height: mediaSize.height -
                padding.top -
                padding.bottom -
                appBar.preferredSize.height,
            child: Column(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: Container(
                    width: mediaSize.width * 0.8,
                    child: DropdownButton<String>(
                      value: _questionType,
                      isExpanded: true,
                      hint: Text("Choose"),
                      iconSize: 24,
                      elevation: 16,
                      underline: Container(
                        height: 2,
                        color: Colors.grey,
                      ),
                      onChanged: (String newValue) {
                        setState(() {
                          _questionType = newValue;
                        });
                      },
                      items: questionTypes
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                Expanded(
                  flex: 7,
                  child: Container(
                    width: mediaSize.width * 0.95,
                    margin: EdgeInsets.symmetric(vertical: 20.0),
                    padding: EdgeInsets.only(top: 15, left: 15, right: 15),
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.5),
                      borderRadius: BorderRadius.all(Radius.circular(20.0)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black45,
                          offset: Offset(3.0, 10.0), //(x,y)
                          blurRadius: 6.0,
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Expanded(
                          flex: 7,
                          child: Container(
                            height: 200,
                            child: IgnorePointer(
                              ignoring: _scrollParent,
                              child: NotificationListener<OverscrollNotification>(
                                onNotification: (_) {

                                  setState(() {
                                    _scrollParent = true;
                                  });

                                  Timer(Duration(seconds: 2), () {
                                    setState(() {
                                      _scrollParent = false;
                                    });
                                  });

                                  return false;
                                },
                                child: ListView(
                                  shrinkWrap: true,
                                  children: <Widget>[
                                    Form(
                                      key: _formKey,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          TextFormField(
                                            controller: _questionTextController,
                                            validator: (String value) {
                                              if (value.isEmpty || value == null) {
                                                return 'This Field is Required';
                                              } else {
                                                return null;
                                              }
                                            },
                                            decoration: InputDecoration(
                                                prefixIcon: Icon(FontAwesomeIcons.question, color: Colors.white70,),
                                                labelText: "Type Your Question Here",
                                                labelStyle: TextStyle(color: Colors.white70)
                                            ),
                                            maxLines: 3,
                                          ),
                                          SizedBox(
                                            height: 10.0,
                                          ),
                                          _questionType == "Choice" ? Container(
                                            margin: EdgeInsets.only(left: 20.0),
                                            child: Row(
                                              children: <Widget>[
                                                Text("Multi Choice"),
                                                Switch(
                                                  value: _multiChoice,
                                                  activeColor: Colors.green,
                                                  inactiveThumbColor: Colors.grey,
                                                  inactiveTrackColor: Colors.grey,
                                                  onChanged: (type) {
                                                    setState(() {
                                                      _multiChoice = type;
                                                    });
                                                  },
                                                ),
                                              ],
                                            ),
                                          ) : Container(),
                                          SizedBox(
                                            height: 10.0,
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(left: 15.0),
                                            child: (_questionType == "Choice")
                                                ? ListView(
                                              controller: listViewScrollController,
                                              addAutomaticKeepAlives: true,
                                              physics: ClampingScrollPhysics(),
                                              shrinkWrap: true,
                                              children: _choices
                                                  .map<Widget>((choice) {
                                                return Container(
                                                  margin: EdgeInsets.only(
                                                      bottom: 3.0),
                                                  child: Row(
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: <Widget>[
                                                      Expanded(
                                                        child: TextFormField(
//                                              enabled: false,
                                                        controller: choice["controller"],
                                                          decoration: InputDecoration(
//                                                hintText: choice["text"],
                                                            prefixIcon: Icon(Icons
                                                                .question_answer),
                                                          ),
                                                        ),
                                                      ),
                                                      Container(
                                                        margin: EdgeInsets.only(left: 5.0),
                                                        decoration: BoxDecoration(
                                                          color: Colors.red,
                                                          shape: BoxShape.circle
                                                        ),
                                                        child: IconButton(
                                                          tooltip: "Remove Choice",
                                                          icon: Icon(Icons.delete, color: Colors.white70,),
                                                          onPressed: () {
                                                            _removeChoice(choice);
                                                          },
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                );
                                              }).toList(growable: true) +
                                                  [
                                                    TextFormField(
                                                      controller:
                                                      _currentChoiceController,
                                                      focusNode: _choiceFocusNode,
                                                      onFieldSubmitted: (value) {
                                                        setState(() {
                                                          _addChoice();
                                                          print("here");
                                                          _scrollToBottom();
                                                        });
                                                      },
                                                      decoration: InputDecoration(
                                                        hintText: "Question Choice",
                                                        prefixIcon: Icon(
                                                            Icons.question_answer),
                                                      ),
                                                    ),
                                                    Container(
                                                      width: double.infinity,
                                                      margin:
                                                      EdgeInsets.only(top: 5.0),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                        children: <Widget>[
                                                          FloatingActionButton(
                                                            materialTapTargetSize:
                                                            MaterialTapTargetSize
                                                                .shrinkWrap,
                                                            tooltip:
                                                            "Add Current Choice",
                                                            elevation: 5,
                                                            child: Icon(Icons.add),
                                                            backgroundColor:
                                                            Colors.blue,
                                                            heroTag: "choice",
                                                            onPressed: () {
                                                              setState(() {
                                                                _addChoice();
                                                                print("here");
                                                                _scrollToBottom();
                                                              });
                                                            },
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                            ) : (_questionType == "Range") ?
                                            ListView(
                                              shrinkWrap: true,
                                              children: <Widget>[
                                                Container(
                                                  margin: EdgeInsets.only(bottom: 3.0),
                                                  child: TextFormField(
                                                    controller: _lowThresholdController,
                                                    validator: (String value) {
                                                      if (value.isEmpty || value == null) {
                                                        return 'This Field is Required';
                                                      } else {
                                                        return null;
                                                      }
                                                    },
                                                    decoration: InputDecoration(
                                                      prefixIcon: Icon(Icons.arrow_downward),
                                                      hintText: "Low Threshold",
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  margin: EdgeInsets.only(bottom: 3.0),
                                                  child: TextFormField(
                                                    controller: _highThresholdController,
                                                    validator: (String value) {
                                                      if (value.isEmpty || value == null) {
                                                        return 'This Field is Required';
                                                      } else {
                                                        return null;
                                                      }
                                                    },
                                                    decoration: InputDecoration(
                                                      prefixIcon: Icon(Icons.arrow_upward),
                                                      hintText: "High Threshold",
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            )
                                                : Container(),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                        ),
                        Expanded(
                          flex: 2,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              Container(
                                margin: const EdgeInsets.all(10.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    FloatingActionButton(
                                      materialTapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                      elevation: 5,
                                      child: Icon(Icons.remove_red_eye),
                                      tooltip: "See Already Created Questions",
                                      backgroundColor: Colors.blueGrey,
                                      heroTag: "visit",
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            return Dialog(
                                              elevation: 10,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(10.0),
                                              ),
                                              child: StatefulBuilder(
                                                    builder: (BuildContext context, StateSetter setState) {
                                              return Container(
                                                height: _questions.isNotEmpty ? mediaSize.height * 0.8 : mediaSize.height * 0.3,
                                                width: double.infinity,
                                                child: _questions.isNotEmpty ? ReorderableListView(
                                                 header: Container(
                                                   padding: EdgeInsets.all(10.0),
                                                   margin: EdgeInsets.only(bottom: 10.0),
                                                   width: double.infinity,
                                                   child: Text("Recently Added Questions", style: TextStyle(fontSize: 15.0), textAlign: TextAlign.center,),
                                                   decoration: BoxDecoration(
                                                     borderRadius: BorderRadius.only(
                                                       bottomRight: Radius.elliptical(30, 70),
                                                       bottomLeft: Radius.elliptical(30, 70),
                                                     ),
                                                     color: Colors.lightBlue
                                                   ),
                                                 ) ,
                                                  onReorder: (a,b){
                                                    setState(() {
                                                      _onReorder(a,b);
                                                    });
                                                  },
                                                  scrollDirection: Axis.vertical,
                                                  padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
                                                  // itemBuilder: (context, index) =>
                                                   children: _questions.map((question) {
                                                     return question["type"] == "Text" ? Dismissible(
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
                                                             ),
                                                           ),
                                                         ),
                                                       ),
                                                       key: Key(question["text"] + _questions.indexOf(question).toString() + "remove"),
                                                       direction: DismissDirection.endToStart,
                                                       onDismissed: (dir) {
                                                         setState(() {
                                                           _questions.remove(question);
                                                         });
                                                       },
                                                       child: Container(
                                                           height: 80,
                                                           key: ValueKey(question["text"] + _questions.indexOf(question).toString()),
                                                           margin: EdgeInsets.only(bottom: 10.0),
                                                           padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 5.0),
                                                           decoration: BoxDecoration(
                                                               color: Colors.white30,
                                                               borderRadius: BorderRadius.circular(10.0)
                                                           ),
                                                           width: double.infinity,
                                                           child: Row(
                                                             children: <Widget>[
                                                               Flexible(
                                                                 fit: FlexFit.tight,
                                                                 flex: 5,
                                                                 child: Container(alignment: Alignment.centerLeft, child: Text('${_questions.indexOf(question) + 1}. ${question["text"]}')),
                                                               ),
                                                               Flexible(
                                                                 flex: 1,
                                                                 fit: FlexFit.tight,
                                                                 child: Container(
                                                                     alignment: Alignment.bottomRight,
                                                                     child: Text(question["type"], style: TextStyle(fontSize: 15.0, color: Colors.blue),)
                                                                 ),
                                                               ),
                                                             ],
                                                           )
                                                       ),
                                                     ) : Dismissible(
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
                                                             ),
                                                           ),
                                                         ),
                                                       ),
                                                       key: Key(question["text"] + _questions.indexOf(question).toString() + "remove"),
                                                       direction: DismissDirection.startToEnd,
                                                       onDismissed: (dir) {
                                                         setState(() {
                                                           _questions.remove(question);
                                                         });
                                                       },
                                                       child: Container(
                                                         key: ValueKey(question["text"] + _questions.indexOf(question).toString()),
                                                         margin: EdgeInsets.only(bottom: 10.0),
                                                         padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 5.0),
                                                         decoration: BoxDecoration(
                                                             color: Colors.white30,
                                                             borderRadius: BorderRadius.circular(10.0)
                                                         ),
                                                         width: double.infinity,
                                                         child: ExpansionTile(
                                                           leading: Text('${_questions.indexOf(question) + 1}. ${question["text"]}', overflow: TextOverflow.fade,),
                                                           title: question["type"] == "Choice" ? Text("${question["type"]}/${question["choice_type"]}", overflow: TextOverflow.fade,) : Text(question["type"], overflow: TextOverflow.fade,),
                                                           children: question["type"] == "Choice" ? question["choices"].map<Widget>((choice) {
                                                             return Text('${question["choices"].indexOf(choice) + 1}. ${choice["controller"].text}');
                                                           }).toList() : [
                                                             Text('Low Threshold: ${question["start_text"]}'),
                                                             Text('High Threshold: ${question["end_text"]}'),
                                                           ],
                                                         ),
                                                       ),
                                                     );
                                                   }).toList(),
                                                  // itemCount: _questions.length,
                                                ) : Center(
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: <Widget>[
                                                      Icon(FontAwesomeIcons.boxOpen),
                                                      SizedBox(height: 15.0,),
                                                      Text(
                                                        "No Records Found!"
                                                      )
                                                    ],
                                                  )
                                                ),
                                              );}),
                                            );
                                          }
                                        );
                                      },
                                    ),
                                    FloatingActionButton(
                                      materialTapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                      tooltip: "Create Question",
                                      elevation: 5,
                                      child: Icon(Icons.add),
                                      backgroundColor: Colors.redAccent,
                                      heroTag: "create",
                                      onPressed: () {
                                        _createQuestion();
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    width: double.infinity,
                    child: RaisedButton(
                      elevation: 10.0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.elliptical(100, 20),
                              topRight: Radius.elliptical(100, 20))),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      onPressed: () {
                        print(_questions);
                        _setFormAspects(context);
                      },
                      child: Text(
                        "Set Form Aspects",
                        style: TextStyle(fontSize: 18.0),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
