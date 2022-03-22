import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:voice_recorder/api/sound_recorder.dart';
import 'package:voice_recorder/main.dart';
import 'package:voice_recorder/services/theme.dart';
import 'package:app_settings/app_settings.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final recorder = SoundRecorder();
  bool isPermissionOk = false;
  bool isOpenAppSettingRequired = false;
  @override
  void initState() {
    super.initState();

    ///todo get all permission on this page if not not go to home screen
    initilizing();
  }

  initilizing() async {
    isPermissionOk = await recorder.checkMicrophonePermission();
    if (isPermissionOk) {
      Timer(
          Duration(seconds: 3),
          () => Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (BuildContext context) => HomePage())));
    } else {
      setState(() {
        isOpenAppSettingRequired = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkHeaderClr,
      body: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Audio Recorder',
              style: titleStyle.copyWith(fontSize: 25, color: Colors.white),
            ),
            const SizedBox(
              height: 30,
            ),
            isOpenAppSettingRequired
                ? GestureDetector(
                    onTap: () async {
                      await AppSettings.openAppSettings();
                      initilizing();
                    },
                    child: Text(
                      'Enable Microphone permission by clicking here',
                      style: titleStyle.copyWith(color: Colors.white),
                    ))
                : const SpinKitFadingCircle(
                    color: Colors.white,
                  ),
          ],
        ),
      ),
    );
  }
}
