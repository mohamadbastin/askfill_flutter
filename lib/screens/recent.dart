import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:questionnaire_flutter/models/form.dart';
import 'package:questionnaire_flutter/providers/formProvider.dart';
import 'package:questionnaire_flutter/models/profile.dart';
import 'package:questionnaire_flutter/widgets/drawer.dart';
import 'package:questionnaire_flutter/widgets/form_item.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

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
                  : RecentForms(),
            ));
  }
}

class RecentForms extends StatefulWidget {
  @override
  _RecentFormsState createState() => _RecentFormsState();
}

class _RecentFormsState extends State<RecentForms> {
  List<myForm> ic;

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  @override
  void initState() {
    // TODO: implement initState
// initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    var initializationSettingsAndroid = AndroidInitializationSettings('app_icon');
    var initializationSettingsIOS = IOSInitializationSettings();
    var initializationSettings = InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: selectNotification);

    var time = Time(3, 47, 0);
    var androidPlatformChannelSpecifics =
    AndroidNotificationDetails('repeatDailyAtTime channel id',
        'repeatDailyAtTime channel name', 'repeatDailyAtTime description');
    var iOSPlatformChannelSpecifics =
    IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);

    flutterLocalNotificationsPlugin.showDailyAtTime(
        0,
        'show daily title',
        'Daily notification shown at approximately}',
        time,
        platformChannelSpecifics);
    super.initState();
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
              return FormItem(form: myFormsList[index],);
            },
            itemCount: myFormsList.length,
          ),
        )
    );
//    return Scaffold(
//      backgroundColor: Colors.grey,
//      appBar: AppBar(
//        elevation: 5,
//        title: Text("Recent Forms"),
//        centerTitle: true,
//      ),
//      drawer: MainDrawer(),
//      body: Container(
//        height: MediaQuery.of(context).size.height,
//        width: MediaQuery.of(context).size.width,
//        child: Center(
//          child: Container(
//            margin: EdgeInsets.only(top: 10),
//            alignment: Alignment.center,
//            height: MediaQuery.of(context).size.height * 0.9,
//            width: MediaQuery.of(context).size.width * 0.9,
//            child: ListView.builder(
//              physics: const AlwaysScrollableScrollPhysics(),
//              itemCount: myFormsList.length,
//              itemBuilder: (context, i) {
//                // print(i);
//                // return Column(children: <Widget>[
//                //   Container(
//                //     width: MediaQuery.of(context).size.width * 0.8,
//                //     height: 230,
//                //     child: Stack(children: <Widget>[
//                //       Align(
//                //         alignment: Alignment.bottomCenter,
//                //         child: Container(
//                //             // color: Colors.cyanAccent,
//                //             decoration: BoxDecoration(
//                //                 color: Colors.cyanAccent,
//                //                 borderRadius:
//                //                     BorderRadius.all(Radius.circular(10))),
//                //             height: 110,
//                //             child: Container(
//                //               // alignment: Alignment.center,
//                //               width: MediaQuery.of(context).size.width * 0.8,
//                //               child: Container(
//                //                 padding: EdgeInsets.only(
//                //                     top: 25, left: 15, right: 15, bottom: 15),
//                // child: Wrap(
//                //     alignment: WrapAlignment.start,
//                //     spacing: 20,
//                //     runSpacing: 10,
//                //     children: <Widget>[
//                //       Container(
//                //           decoration: BoxDecoration(
//                //               color: Colors.purpleAccent,
//                //               borderRadius:
//                //                   BorderRadius.circular(5)),
//                //           padding: EdgeInsets.all(5),
//                //           child: Text(myFormsList[i].name)),
//                //       Container(
//                //           decoration: BoxDecoration(
//                //               color: Colors.purpleAccent,
//                //               borderRadius:
//                //                   BorderRadius.circular(5)),
//                //           padding: EdgeInsets.all(5),
//                //           child:
//                //               Text(myFormsList[i].description)),
//                //       Container(
//                //           decoration: BoxDecoration(
//                //               color: Colors.purpleAccent,
//                //               borderRadius:
//                //                   BorderRadius.circular(5)),
//                //           padding: EdgeInsets.all(5),
//                //           child:
//                //               Text(myFormsList[i].author.name)),
//                //       Container(
//                //           decoration: BoxDecoration(
//                //               color: Colors.purpleAccent,
//                //               borderRadius:
//                //                   BorderRadius.circular(5)),
//                //           padding: EdgeInsets.all(5),
//                //           child: Text(myFormsList[i]
//                //               .estimated_time
//                //               .toString())),
//                //       Container(
//                //           decoration: BoxDecoration(
//                //               color: Colors.purpleAccent,
//                //               borderRadius:
//                //                   BorderRadius.circular(5)),
//                //           padding: EdgeInsets.all(5),
//                //           child: Text(myFormsList[i].name)),
//                //       Container(
//                //           decoration: BoxDecoration(
//                //               color: Colors.purpleAccent,
//                //               borderRadius:
//                //                   BorderRadius.circular(5)),
//                //           padding: EdgeInsets.all(5),
//                //           child: Text(myFormsList[i].name)),
//                //       Container(
//                //           decoration: BoxDecoration(
//                //               color: Colors.purpleAccent,
//                //               borderRadius:
//                //                   BorderRadius.circular(5)),
//                //           padding: EdgeInsets.all(5),
//                //           child: Text(myFormsList[i].name)),
//                //     ]),
//                //               ),
//                //             )),
//                //       ),
//                //       Align(
//                //         alignment: Alignment.topCenter,
//                //         child: Container(
//                //           decoration: BoxDecoration(
//                //               shape: BoxShape.rectangle,
//                //               color: Colors.redAccent,
//                //               borderRadius:
//                //                   BorderRadius.all(Radius.circular(10))),
//                //           height: 140,
//                //           width: MediaQuery.of(context).size.width * 0.7,
//                //           child: ClipRRect(
//                //             child: Image.asset(
//                //               'assets/images/a.png',
//                //               fit: BoxFit.fill,
//                //             ),
//                //             borderRadius: BorderRadius.circular(10),
//                //           ),
//                //         ),
//                //       ),
//                //     ]),
//                //   ),
//                //   Divider()
//                // ]);
//                return InkWell(
//                  onTap: () => Navigator.pushNamed(context, '/form',
//                      arguments: myFormsList[i]),
//                  child: Container(
//                      width: MediaQuery.of(context).size.width,
//                      child: Column(children: <Widget>[
//                        Row(
//                          children: <Widget>[
//                            Container(
//                              height: MediaQuery.of(context).size.width * 0.26,
//                              width: MediaQuery.of(context).size.width * 0.26,
//                              child: Image.asset('assets/images/a.png',
//                                  fit: BoxFit.fill),
//                            ),
//                            Padding(
//                              padding: EdgeInsets.all(5),
//                            ),
//                            Container(
//                              // color: Colors.blueAccent,
//                              height: 130,
//                              width: MediaQuery.of(context).size.width - 180,
//                              child: Align(
//                                alignment: Alignment.topLeft,
//                                child: Stack(
//                                  children: [
//                                    Wrap(
//                                        alignment: WrapAlignment.start,
//                                        spacing: 15,
//                                        // direction: Axis.vertical,
//                                        runSpacing: 5,
//                                        children: <Widget>[
//                                          Container(
//                                              // color: Colors.blue,
//                                              child: Row(
//                                                  mainAxisSize:
//                                                      MainAxisSize.max,
//                                                  children: [
//                                                Icon(
//                                                  Icons.library_books,
//                                                  color: Colors.black,
//                                                ),
//                                                Padding(
//                                                  padding: EdgeInsets.all(1),
//                                                ),
//                                                Text(
//                                                  myFormsList[i].name,
//                                                  style: TextStyle(
//                                                      color: Colors.black,
//                                                      fontSize: 20,
//                                                      fontWeight:
//                                                          FontWeight.bold),
//                                                )
//                                              ])),
//                                          Container(
//                                              // color: Colors.blue,
//                                              child: Row(
//                                                  mainAxisSize:
//                                                      MainAxisSize.max,
//                                                  children: [
//                                                Icon(
//                                                  Icons.description,
//                                                  color: Colors.black,
//                                                ),
//                                                Padding(
//                                                  padding: EdgeInsets.all(1),
//                                                ),
//                                                Text(
//                                                  myFormsList[i]
//                                                              .description
//                                                              .length >
//                                                          20
//                                                      ? myFormsList[i]
//                                                              .description
//                                                              .substring(
//                                                                  0, 20) +
//                                                          "..."
//                                                      : myFormsList[i]
//                                                          .description,
//                                                  style: TextStyle(
//                                                      color: Colors.black,
//                                                      fontSize: 15),
//                                                )
//                                              ])),
//                                          Container(
//                                              // color: Colors.blue,
//                                              child: Row(
//                                                  mainAxisSize:
//                                                      MainAxisSize.min,
//                                                  children: [
//                                                Icon(
//                                                  Icons.account_circle,
//                                                  color: Colors.black,
//                                                ),
//                                                Padding(
//                                                  padding: EdgeInsets.all(1),
//                                                ),
//                                                Text(
//                                                  myFormsList[i].author.name,
//                                                  style: TextStyle(
//                                                      color: Colors.black,
//                                                      fontSize: 15),
//                                                )
//                                              ])),
//                                          Container(
//                                              // color: Colors.blue,
//                                              child: Row(
//                                                  mainAxisSize:
//                                                      MainAxisSize.min,
//                                                  children: [
//                                                Icon(
//                                                  Icons.timer,
//                                                  color: Colors.black,
//                                                ),
//                                                Padding(
//                                                  padding: EdgeInsets.all(1),
//                                                ),
//                                                Text(
//                                                  myFormsList[i]
//                                                      .estimated_time
//                                                      .toString(),
//                                                  style: TextStyle(
//                                                      color: Colors.black,
//                                                      fontSize: 15),
//                                                )
//                                              ])),
//                                          Container(
//                                              // color: Colors.blue,
//                                              child: Row(
//                                                  mainAxisSize:
//                                                      MainAxisSize.min,
//                                                  children: [
//                                                Icon(
//                                                  Icons.calendar_today,
//                                                  color: Colors.black,
//                                                ),
//                                                Padding(
//                                                  padding: EdgeInsets.all(1),
//                                                ),
//                                                Text(
//                                                  myFormsList[i]
//                                                      .created
//                                                      .substring(0, 10),
//                                                  style: TextStyle(
//                                                      color: Colors.black,
//                                                      fontSize: 15),
//                                                )
//                                              ])),
//                                        ]),
//                                    myFormsList[i].is_private != null ? Align(
//                                      alignment: Alignment.bottomRight,
//                                      child: Icon(
//                                        myFormsList[i].is_private
//                                            ? Icons.lock_outline
//                                            : Icons.lock_open,
//                                        color: Colors.black,
//                                      ),
//                                    ) : Container()
//                                  ],
//                                ),
//                              ),
//                            ),
//                            // VerticalDivider(thickness: 2,color: Colors.black,),
//                            Icon(
//                              Icons.arrow_forward_ios,
//                              color: Colors.black,
//                            )
//                          ],
//                        ),
//                        Divider(
//                          height: 1,
//                          color: Colors.black,
//                        ),
//                      ])),
//                );
//              },
//            ),
//          ),
//        ),
//      ),
//    );
  }
}
