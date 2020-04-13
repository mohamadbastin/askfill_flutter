import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:questionnaire_flutter/models/profile.dart';

class AuthScreen extends StatefulWidget {
  static final routeName = "/auth";

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  TextEditingController phoneController = new TextEditingController();
  TextEditingController nameController = new TextEditingController();
  var nameNode = new FocusNode();
  var phoneNode = new FocusNode();
  String that = "next";
  Profile _pro;

  validatephone() async {
    // phoneController.
    if (that == "next") {
      setState(() {
        that = "";
        FocusScope.of(context).requestFocus(new FocusNode());
      });
      if (phoneController.text.length == 10 && phoneController.text[0] == "9") {
        _pro = Provider.of<Profile>(context, listen: false);
        _pro.sendCode("+98" + phoneController.text, nameController.text);
        
        _pro.phone = "+98" + phoneController.text;
        Navigator.pushNamed(context, '/entercode');
        setState(() {
          that = "next";
          FocusScope.of(context).requestFocus(phoneNode);
        });
        FocusScope.of(context).requestFocus(phoneNode);
      } else {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                elevation: 10,
                title: Text("Invalid Phone Number, Try Again."),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0)),
                actions: <Widget>[
                  RaisedButton(
                    elevation: 5,
                    onPressed: () {
                      Navigator.of(context).pop();
                      validatephone();
                      // setState(() {
                      // that = "next";
                      // FocusScope.of(context).requestFocus(focusNode);
                      // });
                    },
                    child: Text(
                      "Ok",
                      style: TextStyle(
                          color: Colors.white),
                    ),
                  )
                ],
              );
            });
      }
    } else {
      setState(() {
        that = "next";
        FocusScope.of(context).requestFocus(phoneNode);
      });
    }
  }

  enabletext() {
    if (that == "next") {
      return true;
    } else {
      return false;
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final mediaSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 5,
        title: Text("Login"),
        centerTitle: true,
      ),
      resizeToAvoidBottomPadding: true,
      body: Center(
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(new FocusNode());
          },
          child: Container(
            width: mediaSize.width * 0.9,
            height: mediaSize.height * 0.6,
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black45,
                    offset: Offset(0.0, 10.0), //(x,y)
                    blurRadius: 6.0,
                  ),
                ],
              gradient: LinearGradient(colors: [
                Colors.grey.withOpacity(0.8),
                Colors.grey.withOpacity(0.5),
                Colors.grey.withOpacity(0.2),
              ])
            ),
            child: ListView(
//            mainAxisAlignment: MainAxisAlignment.center,
//              crossAxisAlignment: CrossAxisAlignment.center,
            shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                children: <Widget>[
              Container(
                child: Image.asset('assets/images/frm.png'),
                width: 50,
                height: 70,
                margin: EdgeInsets.only(top: 10),
              ),
                SizedBox(height: 20,),
              Container(
                // foregroundDecoration: BoxDecoration(
                //   color: Colors.grey,
                //   backgroundBlendMode: BlendMode.clear,
                // ),
                width: MediaQuery.of(context).size.width * 0.8,
                child: Column(
                  children: <Widget>[
                    TextField(
                        controller: nameController,
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.next,
                        focusNode: nameNode,
                        autofocus: true,
                        // readOnly: that=="next"? false : true,
                        // enabled: that=="next"? false : true,
                        enabled: true,
                        // enabled: enabletext() ,
                        onSubmitted: (value) {
                          FocusScope.of(context).requestFocus(phoneNode);
                        },
                        decoration: InputDecoration(
                          hintText: 'Name',

                          border: InputBorder.none,
                          prefixIcon: Icon(
                            Icons.account_box,
                            color: Colors.white,
                          ),
                          // labelText: 'Enter Your Phone Number',
                          // enabledBorder: UnderlineInputBorder(
                          //     borderSide: BorderSide(color: Colors.black, width: 0.0)),
                          // hintText: 'Enter Your Phone Number',
                          // prefix: Text('+98'),
                          hintStyle: TextStyle(color: Colors.white),
                        ))
                    ,Padding(padding: EdgeInsets.only(top: 30)),
                    TextField(
                        controller: phoneController,
                        keyboardType: TextInputType.phone,
                        textInputAction: TextInputAction.done,
                        focusNode: phoneNode,
                        autofocus: true,
                        // readOnly: that=="next"? false : true,
                        // enabled: that=="next"? false : true,
                        enabled: true,
                        onSubmitted: (value) async {
                          await validatephone();
                        },
                        // enabled: enabletext() ,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          // hintText: '+98',
                          prefixIcon: Icon(
                            Icons.phone,
                            color: Colors.white,
                          ),
                          // labelText: 'Enter Your Phone Number',
                          // enabledBorder: UnderlineInputBorder(
                          //     borderSide: BorderSide(color: Colors.black, width: 0.0)),
                          // hintText: 'Enter Your Phone Number',
                          prefix: Text('+98'),
                          hintStyle: TextStyle(color: Colors.white),
                        )),
                  ],
                ),

              ),
                  Container(
                    margin: EdgeInsets.only(top: 30.0),
                    child: RaisedButton(
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 40.0),
                      onPressed: () async {
                        await validatephone();
                      },
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      child: Text(
                        "Retrieve Code",
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
            ]),
          ),
        ),
      ),
      // floatingActionButton: FloatingActionButton(onPressed: null),
    );
  }
}
