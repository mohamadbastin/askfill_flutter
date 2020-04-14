import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:questionnaire_flutter/models/form.dart';
import 'package:questionnaire_flutter/providers/formProvider.dart';
import 'package:questionnaire_flutter/models/profile.dart';
import 'package:questionnaire_flutter/widgets/drawer.dart';
import 'package:questionnaire_flutter/widgets/form_item.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../widgets/errorDialog.dart';


class RecentFormsScreen extends StatefulWidget {
  static final routeName = "/recent";

  @override
  _RecentFormsScreenState createState() => _RecentFormsScreenState();
}

class _RecentFormsScreenState extends State<RecentFormsScreen> {

  @override
  Widget build(BuildContext context) {
    final form = Provider.of<FormProvider>(context, listen: false);
    return FutureBuilder(
        future: form
            .fetchAndSetmyForms(),
        builder: (_, snapshot) => RefreshIndicator(
              onRefresh: form
                  .fetchAndSetmyForms,
              child: snapshot.connectionState == ConnectionState.waiting
                  ? Scaffold(
                      body: Center(child: CircularProgressIndicator()),
                    )
                  : snapshot.hasError ? ErrorDialog(message: servermsg, ctx: context)
                  : RecentForms()
            ));
  }
}

class RecentForms extends StatefulWidget {
  @override
  _RecentFormsState createState() => _RecentFormsState();
}

class _RecentFormsState extends State<RecentForms> with TickerProviderStateMixin {
  List<myForm> ic;


  AnimationController controller;
  Animation<double> animation;

  @override
  void initState() {
    // TODO: implement initState
// initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    List times = [
      Time(22, 3, 0),
      Time(22, 4, 0),
      Time(22, 5, 0),
    ];

    var initializationSettingsAndroid = AndroidInitializationSettings('app_icon');
    var initializationSettingsIOS = IOSInitializationSettings();
    var initializationSettings = InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);

    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();

    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: selectNotification);
//    var time = Time(19, 03, 0);
    var androidPlatformChannelSpecifics =
    AndroidNotificationDetails('repeatDailyAtTime channel id',
        'repeatDailyAtTime channel name', 'repeatDailyAtTime description');
    var iOSPlatformChannelSpecifics =
    IOSNotificationDetails();

    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);

    times.forEach((time) {
      flutterLocalNotificationsPlugin.showDailyAtTime(
          times.indexOf(time),
          'show daily title',
          'Daily notification1 shown at approximately}',
          time,
          platformChannelSpecifics);
    });

    super.initState();

    controller = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);
    animation = CurvedAnimation(parent: controller, curve: Curves.easeIn);

    /*animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller.reverse();
      } else if (status == AnimationStatus.dismissed) {
        controller.forward();
      }
    });*/

    controller.forward();

  }

  Future selectNotification(String payload) async {
    if (payload != null) {
      debugPrint('notification payload: ' + payload);
    }
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => RecentForms()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MainDrawer(),
        appBar: AppBar(
          elevation: 5,
          title: Text("Recent Forms"),
          centerTitle: true,
        ),
        body: Container(
          margin: EdgeInsets.all(5.0),
          child: ListView.builder(
            itemBuilder: (context, index) {
              return Container(
//                color: Colors.white,
                child: FadeTransition(
                  opacity: animation,
                  alwaysIncludeSemantics: true,
                  child: FormItem(form: myFormsList[index],)
                ),
              );
            },
            itemCount: myFormsList.length,
          ),
        )
    );
  }
}
