import 'package:flutter/material.dart';
import 'package:questionnaire_flutter/models/form.dart';
import 'package:questionnaire_flutter/widgets/drawer.dart';

class ReportMenuScreen extends StatelessWidget {
  static final routeName = "/report1";


  Widget _drawerListTile(String title, String routeName, BuildContext context, String arg) {
    return ListTile(
      trailing: IconButton(icon: Icon(Icons.arrow_forward_ios), onPressed: null),
      title: Text(title),
      onTap: () {
        // Provider.of<Profile>(context, listen: false).logout();
        Navigator.of(context).pushNamed(routeName, arguments: arg);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final myForm form = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(title: Text('Reports')),
      // drawer: MainDrawer(),
      body: ListView(children: [
        _drawerListTile("By Form", "/chooseform", context, 'f'),
        Divider(),
        _drawerListTile("By Question", "/chooseform", context, 'q'),

      ]),
      
    );
  }
}