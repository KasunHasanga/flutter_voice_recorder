import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:voice_recorder/main.dart';
import 'package:voice_recorder/services/theme.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    ///todo get all permission on this page if not not go to home screen
    // initilizing();
    Timer(
        Duration(seconds: 3),
            () => Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) => HomePage())));
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkHeaderClr,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Audio Recorder',style: titleStyle.copyWith(fontSize: 25,color: Colors.white),),
          SizedBox(height: 30,),
          SpinKitFadingCircle(
            color: Colors.white,
          )
        ],
      ),
    );
  }



}
