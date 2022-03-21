import 'dart:io';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:voice_recorder/api/sound_recorder.dart';
import 'package:voice_recorder/services/theme.dart';
import 'package:voice_recorder/services/theme_services.dart';
import 'package:voice_recorder/widget/recorder_list_view.dart';
import 'package:voice_recorder/widget/timer_widget.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Audio Recorder',
      debugShowCheckedModeBanner: false,
      theme: Themes.light,
      darkTheme: Themes.dark,
      themeMode: ThemeServices().theme,
      home:  HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final timerController = TimerController();
  final recorder = SoundRecorder();


  @override
  void initState() {
    super.initState();
    initilizing();
    recorder.init();
  }
  void initilizing() async {
    await GetStorage.init();
  }


  @override
  void dispose() {
    recorder.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text("Audio Recorder"),
        centerTitle: true,
        elevation: 0,
        leading: GestureDetector(
          onTap: () {
            ThemeServices().switchTheme();
            print(Get.isDarkMode);
          },
          child: Icon(
            Get.isDarkMode ? Icons.wb_sunny_rounded : Icons.nightlight_round,
            size: 20,
            color: Get.isDarkMode ? Colors.white : Colors.black,
          ),
        ),
      ),
      body: Column(
        // crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            flex: 1,
            child: RecordListView(
              // records: records,
            ),
          ),
          Container(
            color:backgroundColor,
            height: 280,
            child: Column(
              children: [
                recodingWidget(),
                // buildStart(),
              ],
            ),
          ),
        ],
      ),
    );
  }



  Widget recodingWidget() {
    final isRecording = recorder.isRecording;
    final icon = isRecording ? Icons.stop : Icons.mic;
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 280,
      decoration: BoxDecoration(
        color: avatorBackgroundColor,
        border: Border.all(
          color: avatorBackgroundColor,
        ),
          borderRadius: BorderRadius.only(topLeft: Radius.circular(40),topRight: Radius.circular(40))
      ),
      child: AvatarGlow(
        glowColor: avatorGrowColor,
        endRadius: 140.0,
        duration: Duration(milliseconds: 200),
        animate: recorder.isRecording ? true : false,
        repeatPauseDuration: Duration(milliseconds: 100),
        child: CircleAvatar(
          radius: 100,
          backgroundColor: avatorGrowColor,
          child: GestureDetector(
            onTap: () async {
              // bool isPermissionOk=await recorder.checkMicrophonePermission();
              // if (isPermissionOk){
              await recorder.toggleRecording();
              final isRecording = recorder.isRecording;
              setState(() {
                if (isRecording) {
                  timerController.startTimer();
                } else {
                  timerController.stopTimer();
                  // _onRecordComplete();
                }
              });
              // }else{
              //   print("Something went Wrong");
              // }
            },
            child: CircleAvatar(
              backgroundColor: Colors.indigo.shade900.withBlue(70),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon),
                  TimerWidget(
                    controller: timerController,
                  ),
                  SizedBox(
                    height: 8,
                  ),
                ],
              ),
              radius: 92.0,
            ),
          ),
        ),
      ),
    );
  }
}
