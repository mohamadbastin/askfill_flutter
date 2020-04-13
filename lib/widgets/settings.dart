import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:questionnaire_flutter/models/profile.dart';
import 'package:url_launcher/url_launcher.dart';


class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
//    final profile = Provider.of<Profile>(context, listen: false);
    final mediaSize = MediaQuery.of(context).size;
    return Container(
        height: mediaSize.height * 0.3,
        width: double.infinity,
        margin: EdgeInsets.only(left: 20.0),
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Text("Notifications", style: TextStyle(fontSize: 18.0),),
                Consumer<Profile>(
                  builder: (context, profile, child) => Switch(
                    value: profile.notifications,
                    activeColor: Colors.green,
                    inactiveThumbColor: Colors.grey,
                    inactiveTrackColor: Colors.grey,
                    onChanged: (value) {
                      profile.changeNotificationStatus(value);
                    },
                  ),
                ),
              ],
            ),
            Divider(),
            ListTile(
              onTap: () => launch("tel://+989379852503"),
              title: Text('تماس با ما', textDirection: TextDirection.rtl),
            ),
          ],
        )
    );
  }
}