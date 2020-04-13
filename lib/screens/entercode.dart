import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pin_put/pin_put.dart';
import 'package:provider/provider.dart';
import 'package:questionnaire_flutter/models/profile.dart';
import 'package:questionnaire_flutter/widgets/errorDialog.dart';




class EnterCodeScreen extends StatefulWidget {
  static final routeName ='/entercode';
  @override
  _EnterCodeScreenState createState() => _EnterCodeScreenState();
}

class _EnterCodeScreenState extends State<EnterCodeScreen> {


  Future<void> _showMessageDialog(String message) async {
    return showDialog(
      context: context,
      builder: (ctx) => ErrorDialog(message: message, ctx: ctx,),
    );
  }

  TextEditingController cn1 = new TextEditingController();
  TextEditingController cn2 = new TextEditingController();
  TextEditingController cn3 = new TextEditingController();
  TextEditingController cn4 = new TextEditingController();

  String pin = '';
  String _phone;
  Future<void> make;

  verifycode(String pinn) async {
      setState(() {
        pin = pinn;
      });

      _phone = Provider.of<Profile>(context, listen: false).phone;
      Provider.of<Profile>(context, listen: false).login(pin, _phone).then((resp) {
        Navigator.pushReplacementNamed(context, '/recent');

      }).catchError((e) {
        _showMessageDialog('Cannot Connect To Server');
      });
      
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(leading: IconButton(icon: Icon(Icons.arrow_back),onPressed: (){
        Navigator.of(context).pop();
        },),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.done),onPressed: () async {
            await verifycode(pin);
          },)
        ],
        elevation: 0,
      
    ),
    body: new GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Center(
            child: Column(children: <Widget>[
              Expanded(
                flex: 1,
                child: SizedBox(height: 100),
              ),
              Expanded(
                  flex: 1,
                  child: Container(
                    child: Image.asset('assets/images/frm.png'),
                    width: 200,
                  )),
              Expanded(
                flex: 1,
                child: SizedBox(height: 100),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: Align(
                    alignment: Alignment(0, -0.8),
                    child: Text(
                      "Enter Code",
                      style: TextStyle(fontSize: 25),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: SizedBox(height: 20),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  // foregroundDecoration: BoxDecoration(
                  //   color: Colors.grey,
                  //   backgroundBlendMode: BlendMode.clear,
                  // ),
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: PinPut(onSubmit: (String pin) => verifycode(pin), fieldsCount: 4,actionButtonsEnabled: false,)
                ),
              ),
              Expanded(flex: 2, child: Container()),
            ]),
          ),
        ),
      ),
      

    );
    }
}