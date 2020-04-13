import 'package:flutter/material.dart';

class ErrorScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            child: Icon(Icons.warning, color: Colors.red, size: 100.0,),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("Server Connection Error, Please Try Again Later!"),
          )
        ],
      ),
    );
  }
}
