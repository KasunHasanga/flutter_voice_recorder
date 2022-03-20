import 'dart:io';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:voice_recorder/api/sound_recorder.dart';
import 'package:voice_recorder/widget/recorder_list_view.dart';
import 'package:voice_recorder/widget/timer_widget.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Audio Recorder',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final timerController =TimerController();
  final recorder=SoundRecorder();
  late Directory appDirectory;
  List<String> records = [];

  @override
  void initState() {

    super.initState();
    getApplicationDocumentsDirectory().then((value) {
      appDirectory = value;
      appDirectory.list().listen((onData) {
        if (onData.path.contains('.aac')) records.add(onData.path);
      }).onDone(() {
        records = records.reversed.toList();
        setState(() {});
      });
    });
    recorder.init();
  }

  @override
  void dispose() {
    recorder.dispose();
    appDirectory.delete();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow,
      appBar: AppBar(
        title: const Text("Audio Recorder"),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        // crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            flex: 1,
            child: RecordListView(
              records: records,
            ),
          ),
          SizedBox(
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
  _onRecordComplete() {
    records.clear();
    appDirectory.list().listen((onData) {
      if (onData.path.contains('.aac')) records.add(onData.path);
    }).onDone(() {
      records.sort();
      records = records.reversed.toList();
      setState(() {});
    });
  }
  Widget recodingWidget(){
    final isRecording =recorder.isRecording;
    final icon =isRecording ?Icons.stop :Icons.mic;
    final text =isRecording ? 'STOP': 'START';
    final primary =isRecording? Colors.red :Colors.white;
    final onPrimary =isRecording ?Colors.white:Colors.black;
    return AvatarGlow(
      glowColor: Colors.white,
      endRadius: 140.0,
      duration: Duration(milliseconds: 200),
      animate: recorder.isRecording?true:false,
      repeatPauseDuration: Duration(milliseconds: 100),
      child: CircleAvatar(
        radius: 100,
        backgroundColor: Colors.white,
        child: GestureDetector(
          onTap: ()  async{
            // bool isPermissionOk=await recorder.checkMicrophonePermission();
            // if (isPermissionOk){
            await recorder.toggleRecording();
            final isRecording =recorder.isRecording;
            setState(() {
              if(isRecording){
                timerController.startTimer();
              }else{
                timerController.stopTimer();
                _onRecordComplete();
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
                TimerWidget(controller: timerController,),
                SizedBox(height: 8,),

              ],
            ),
            radius: 92.0,
          ),
        ),
      ),
    );
  }
}
