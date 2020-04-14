import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:questionnaire_flutter/models/profile.dart';
import 'package:questionnaire_flutter/providers/formProvider.dart';
import 'package:questionnaire_flutter/screens/ErrorScreen.dart';
import 'package:questionnaire_flutter/screens/byques.dart';
import 'package:questionnaire_flutter/screens/chooseform.dart';
import 'package:questionnaire_flutter/screens/createForm.dart';
import 'package:questionnaire_flutter/screens/entercode.dart';
import 'package:questionnaire_flutter/screens/form.dart';
import 'package:questionnaire_flutter/screens/formQuestionsScreen.dart';
import 'package:questionnaire_flutter/screens/reportbyform.dart';
import 'package:questionnaire_flutter/screens/singleForm.dart';
import 'package:questionnaire_flutter/screens/recent.dart';
import 'package:questionnaire_flutter/screens/reportbyquestion.dart';
import 'package:questionnaire_flutter/screens/splashScreen.dart';
import 'screens/authScreen.dart';
import 'screens/singleForm.dart';
import 'screens/ActiveForms.dart';
import 'screens/myforms.dart';
import 'screens/report_menu.dart';
import 'package:rxdart/subjects.dart';

void main() => runApp(MyApp());

final String host = "https://ques.mbastin.ir";

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider<Profile>.value(value: Profile()),
      ChangeNotifierProvider<FormProvider>.value(value: FormProvider())
      ],
      child: MaterialApp(
        title: 'AskFill',
        theme: ThemeData(
            primarySwatch: Colors.red,
            focusColor: Colors.deepOrange,
            accentColor: Colors.redAccent,
            brightness: Brightness.dark,
            inputDecorationTheme: InputDecorationTheme(
                filled: true,
                hintStyle: TextStyle(color: Colors.white),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: BorderSide(
                        width: 2.0
                    ),
                ),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: BorderSide(
                        color: Colors.white70,
                        width: 2.0
                    )
                ),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: BorderSide(
                        color: Colors.white,
                        width: 1.0
                    )
                )
            )
        ),
        onGenerateRoute: (RouteSettings settings) {
          print('build route for ${settings.name}');
          print('build route for ${settings.arguments}');
          var routes = <String, WidgetBuilder>{
            FormQuestionsScreen.routeName: (ctx) => FormQuestionsScreen(settings.arguments),
          };
          WidgetBuilder builder = routes[settings.name];
          return MaterialPageRoute(builder: (ctx) => builder(ctx));
        },
        home: MyHomePage(),
        routes: {
          // "/": (_) => SplashScreen(),
          RecentFormsScreen.routeName : (_) => RecentFormsScreen(),
          AuthScreen.routeName : (_) => AuthScreen(),
          EnterCodeScreen.routeName: (_) => EnterCodeScreen(),
          CreateFormScreen.routeName: (_) => CreateFormScreen(),
          SingleFormScreen.routeName: (_) => SingleFormScreen(),
          FormScreen.routeName: (_) => FormScreen(),
          ReportByFormScreen.routeName: (_) => ReportByFormScreen(),
          ChooseQuesScreen.routeName: (_) => ChooseQuesScreen(),
          ReportByQuesScreen.routeName: (_) => ReportByQuesScreen(),
          ChooseFormsSceen.routeName: (_) => ChooseFormsSceen(),
          ReportMenuScreen.routeName: (_) => ReportMenuScreen(),
          MyFormsSceen.routeName: (_) => MyFormsSceen(),
          ActiveFormsSceen.routeName: (_) => ActiveFormsSceen(),
//          FormQuestionsScreen.routeName: (_) => FormQuestionsScreen(s),
        },
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    
    return Consumer<Profile>(
        builder: (context, profile, child) => profile.isAuth ? RecentFormsScreen() : FutureBuilder(
            future: profile.autologin(),
            builder: (context, snapshot) => snapshot.connectionState == ConnectionState.waiting ?
            Scaffold(
                body: Center(child: CircularProgressIndicator(),)
            ) : snapshot.hasError ? Scaffold(
              appBar: AppBar(
                centerTitle: true,
                title: Text("Connection Failed!"),
                elevation: 5,
                backgroundColor: Colors.red,
              ),
              body: ErrorScreen(),
            ): snapshot.data ? RecentFormsScreen()
                : AuthScreen()
        )
    );
  }
}
