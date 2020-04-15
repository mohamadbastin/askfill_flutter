import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:questionnaire_flutter/models/profile.dart';
import 'package:questionnaire_flutter/widgets/settings.dart';
// import 'package:url_launcher/url_launcher.dart';


class MainDrawer extends StatelessWidget {
  Widget _drawerListTile(String title, String routeName, BuildContext context) {
    return ListTile(
      title: Text(title),
      onTap: () {
        // Provider.of<Profile>(context, listen: false).logout();
        Navigator.of(context).popAndPushNamed(routeName);
      },
    );
  }

  Widget _drawerListTileLogOut(
      String title, String routeName, BuildContext context) {
    return ListTile(
      title: Text(title),
      onTap: () {
        Provider.of<Profile>(context, listen: false).logout();
        Navigator.of(context).popAndPushNamed(routeName);
      },
    );
  }

  _openSettingsModal(BuildContext context) {
    showModalBottomSheet(
        isScrollControlled: true,
        elevation: 10,
        context: context,
        builder: (context) => GestureDetector(
              onDoubleTap: () {
                Navigator.of(context).pop();
              },
              behavior: HitTestBehavior.opaque,
              child: Settings(),
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        child: ListView(
          children: <Widget>[
            AppBar(
              title: Text("AskFill"),
              centerTitle: true,
              leading: IconButton(
                icon: Icon(Icons.settings),
                onPressed: () {
                  Navigator.of(context).pop();
                  _openSettingsModal(context);
                },
              ),
              // actions: <Widget>[
              //   IconButton(icon: Icon(Icons.notifications), onPressed: null)
              // ],
            ),
            GestureDetector(
                onTap: null,
                child: DrawerHeader(
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.grey,
                            Colors.blueGrey,
                          ],
                        ),
                        borderRadius: BorderRadius.only(
                          bottomRight: Radius.elliptical(200, 100),
                          bottomLeft: Radius.elliptical(200, 100),
                        )),
                    child: Container(
                      height: 150,
                      child: Column(
                        children: <Widget>[
                          Container(
                            // alignment: Alignment.centerLeft,
                            height: 100,
                            width: 100,
                            // margin: EdgeInsets.only(bottom: 20.0),
                            decoration: BoxDecoration(shape: BoxShape.circle),
                            child: FittedBox(
                              fit: BoxFit.fill,
                              child: ClipOval(
                                child: FadeInImage(
                                    placeholder: AssetImage(
                                      'assets/images/ff.png',
                                    ),
                                    image: AssetImage(
                                      'assets/images/ff.png',
                                    )),
                              ),
                            ),
                          ),
                          SizedBox(height: 10.0,),
                          Container(
                            // height: 30,
                            // width: 200,
                            alignment: Alignment.center,
                            child: FittedBox(
                                fit: BoxFit.fill, child: Text(myProfilee.name, style: TextStyle(fontSize: 20),)),
                          )
                        ],
                      ),
                    ))),
            _drawerListTile('Home', '/recent', context),
            Divider(),
            _drawerListTile('Active Forms', '/active', context),
            Divider(),
            _drawerListTile('My Forms', '/myform', context),
            Divider(),
            _drawerListTile("Create Form", '/createForm', context),
            Divider(),
            _drawerListTile("Reports", '/report1', context),
            Divider(),
            // ListTile(
            //   onTap: () => launch("tel://+989379852503"),
            //   title: Text('تماس با ما', textDirection: TextDirection.rtl),
            // ),
             _drawerListTileLogOut("Logout", '/auth', context),
//            RaisedButton(
//              onPressed: () {
//                Provider.of<Profile>(context, listen: false).logout();
//                Navigator.of(context).popAndPushNamed('/auth');
//              },
//              child: Text('Log Out'),
//            )
          ],
        ),
      ),
    );
  }
}
