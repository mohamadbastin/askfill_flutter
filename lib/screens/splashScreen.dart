import 'package:flutter/material.dart';
import 'dart:async';
import 'package:provider/provider.dart';
import 'package:questionnaire_flutter/models/profile.dart';
import 'package:questionnaire_flutter/screens/ErrorScreen.dart';
import 'package:questionnaire_flutter/screens/authScreen.dart';
import 'package:questionnaire_flutter/screens/recent.dart';




class GrowTransition extends StatelessWidget {
  GrowTransition({this.child, this.animation});

  final Widget child;
  final Animation<double> animation;

  Widget build(BuildContext context) => Center(
        child: AnimatedBuilder(
            animation: animation,
            builder: (context, child) => 
            Transform.rotate(angle: animation.value,
            child: LogoWidget())
            ,child: child)
      );
}


class LogoWidget extends StatelessWidget {
  // Leave out the height and width so it fills the animating parent
  Widget build(BuildContext context) => Container(
        height: 200,
        child: Image.asset('assets/images/frm.png'),
      );
}



class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {

  Animation<double> animation;         
  AnimationController controller;

  void navigationPage(){
    controller.dispose();

    Navigator.of(context).popAndPushNamed("/auth");
  }

  startTime() async {
    var _duration = new Duration(seconds: 3);
    return new Timer(_duration, navigationPage);
  }

  @override
  void initState() {
      super.initState();


      startTime();


      controller = AnimationController(vsync: this, duration: Duration(seconds: 2));

      animation = Tween<double>(begin: 0, end: 6).animate(controller)
      ..addStatusListener((state) {
        if (state == AnimationStatus.completed){
          controller.repeat();
        }
      });

          controller.forward();
//      _auth = Provider.of<Profile>(context, listen: false).isAuth;
//      _autologin = Provider.of<Profile>(context, listen: false).autologin();
//
//      routemaker();

    }


  @override
  Widget build(BuildContext context) {
    final profile = Provider.of<Profile>(context, listen: false);
    return FutureBuilder(
        future: profile.autologin(),
        builder: (context, snapshot) => snapshot.connectionState == ConnectionState.waiting ?
        Scaffold(
            body: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              color: Colors.blueGrey,
              child: Center(child: GrowTransition(animation: animation, child: LogoWidget()),),
            )
        ) : snapshot.hasError ? Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text("Connection Failed!"),
            elevation: 5,
          ),
          body: ErrorScreen(),
        ): snapshot.data ? RecentFormsScreen()
            : AuthScreen()
    );
  }
}