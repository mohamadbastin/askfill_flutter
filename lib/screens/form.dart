import 'package:flutter/material.dart';
import 'package:questionnaire_flutter/models/form.dart';
import 'package:intl/intl.dart' as intl;
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:questionnaire_flutter/models/profile.dart';
import 'package:questionnaire_flutter/screens/formQuestionsScreen.dart';
import 'package:questionnaire_flutter/widgets/drawer.dart';

class FormScreen extends StatefulWidget {
  static final routeName = "/form";
  // final myForm form;
  // FormScreen({@required this.form});
  @override
  _FormScreenState createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  TextEditingController pass = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    final myForm form = ModalRoute.of(context).settings.arguments;
    final FocusNode passf = new FocusNode();
    final mediaSize = MediaQuery.of(context).size;

    void _participate() async {
      showDialog(
          context: context,
          builder: (context) {
            return Dialog(
                elevation: 10,
                // shape: RoundedRectangleBorder(
                //   borderRadius: BorderRadius.circular(10.0),
                // ),
                child: SizedBox(
              height: 30,
              width: 30,
              child: LinearProgressIndicator(),
            ));
          });

      final _pro = Provider.of<Profile>(context, listen: false);
      var res = await _pro.participate(pass.text, form.id);
      // print(res);
      if (res == "yes") {
        Navigator.of(context)
            .popAndPushNamed(FormQuestionsScreen.routeName, arguments: form.id);
      } else {
        Navigator.pop(context);
        // passf.requestFocus();
        showDialog(
          context: context,
          builder: (context) {
            return Dialog(
                elevation: 10,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(
                  Radius.circular(10.0)
                )),
                // shape: RoundedRectangleBorder(
                //   borderRadius: BorderRadius.circular(10.0),
                // ),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                  height: mediaSize.height * 0.2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text("Password is Incorrect!"),
                      SizedBox(height: 15,),
                      RaisedButton(onPressed: ()=>Navigator.pop(context), child: Text("ok"),)
                    ],
                  ),
                ));
          });
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(form.name),
        centerTitle: true,
        elevation: 5.0,
      ),
      // drawer: MainDrawer(),
      backgroundColor: Colors.grey,
      body: SingleChildScrollView(
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(new FocusNode());
          },
          child: Container(
            width: MediaQuery.of(context).size.width,
            child: ListView(
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
              children: <Widget>[
                Hero(
                  tag: form.name + form.author.name,
                  child: Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    child: Column(
                      children: <Widget>[
                        Stack(
                          children: <Widget>[
                            ClipRRect(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(15),
                                  topRight: Radius.circular(15)),
                              child: Image.asset(
                                'assets/images/a.png',
                                fit: BoxFit.cover,
                                height: 150,
                                width: double.infinity,
                              ),
                            ),
                            Positioned(
                              bottom: 10,
                              right: 20,
                              child: Container(
                                color: Colors.black54,
                                height: 40,
                                width: 300,
                                padding: EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 5),
                                child: Text(
                                  form.name,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                  ),
                                  textAlign: TextAlign.center,
                                  softWrap: true,
                                  overflow: TextOverflow.fade,
                                ),
                              ),
                            )
                          ],
                        ),
                        Padding(
                            padding: EdgeInsets.all(10),
                            child: Container(
                                // height: 300,
                                padding: EdgeInsets.symmetric(horizontal: 10.0),
                                child: Container(
                                  // color:Colors.red,
                                  padding: EdgeInsets.only(top: 30),
                                  child: Column(
                                    children: <Widget>[
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: <Widget>[
                                                  Icon(Icons.timer),
                                                  SizedBox(
                                                    width: 3,
                                                  ),
                                                  Container(
                                                      child: Text(
                                                          '${form.estimated_time.toString()} min'))
                                                ],
                                              ),
                                              SizedBox(
                                                height: 10.0,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: <Widget>[
                                                  Icon(Icons.calendar_today),
                                                  SizedBox(
                                                    width: 3,
                                                  ),
                                                  Container(
                                                    child: Text(
                                                        // DateFormat.yMMMEd().format(DateTime.parse(form.created)),

                                                        intl.DateFormat.yMMMMd()
                                                            .format(DateTime
                                                                .parse(form
                                                                    .created))
                                                        // form.created
                                                        ),
                                                  )
                                                ],
                                              ),
                                            ],
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Row(
                                                children: <Widget>[
                                                  // Padding(padding: EdgeInsets.only(left:45),),
                                                  Icon(FontAwesomeIcons.pen),
                                                  SizedBox(
                                                    width: 3,
                                                  ),
                                                  Container(
                                                      child: Text(
                                                          form.author.name))
                                                ],
                                              ),
                                              SizedBox(
                                                height: 10.0,
                                              ),
                                              Row(
                                                children: <Widget>[  
                                                  // Padding(padding: EdgeInsets.only(left:45),),
                                                  Icon(form.is_private ? Icons.lock : Icons.lock_open),
                                                   SizedBox(
                                                     width: 3,
                                                   ),
                                                   Container(
                                                       child: Text(
                                                         form.is_private ? 'Private' : 'Public'
                                                       )
                                                   )
                                                ],
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                      SizedBox(
                                        height: 10.0,
                                      ),
                                      Divider(
                                        height: 1,
                                      ),
                                      SizedBox(
                                        height: 10.0,
                                      ),
                                      Row(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
//                                              Icon(
//                                                Icons.description,
//                                                color: Colors.black,
//                                              ),
                                            Expanded(
                                              child: Container(
                                                child: Directionality(
                                                  // TODO
                                                  textDirection:
                                                      TextDirection.rtl,
                                                  child: Text(
                                                    form.description,
                                                    //  textDirection:,

                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 15),
                                                  ),
                                                ),
                                              ),
                                            )
                                          ]),
                                      SizedBox(
                                        height: 20.0,
                                      ),
                                      form.is_private == true
                                          ? TextField(
                                              onChanged: (value) =>
                                                  setState(() {}),
                                              controller: pass,
                                              onSubmitted: (value) {
                                                pass.text.isEmpty && form.is_private
                                                    ? null
                                                    : _participate();
                                              },
                                              decoration: InputDecoration(
                                                  prefixIcon:
                                                      Icon(Icons.lock_outline),
                                                  labelText: "Password"))
                                          : Container(),
                                      SizedBox(
                                        height: 30.0,
                                      ),
                                      Container(
                                        width: double.infinity,
                                        child: RaisedButton(
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.only(
                                              topRight:
                                                  Radius.elliptical(100, 70),
                                              topLeft:
                                                  Radius.elliptical(100, 70),
                                            )),
                                            materialTapTargetSize:
                                                MaterialTapTargetSize
                                                    .shrinkWrap,
                                            onPressed: () {
                                              pass.text.isEmpty && form.is_private
                                                  ? null
                                                  : _participate();
                                            },
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 12.0),
                                              child: Text('Participate'),
                                            )),
                                      )
                                    ],
                                  ),
                                )))
                      ],
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
