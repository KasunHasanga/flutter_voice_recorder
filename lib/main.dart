import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:voice_recorder/api/sound_recorder.dart';
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
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
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

  @override
  void initState() {

    super.initState();
    recorder.init();
  }

  @override
  void dispose() {
    recorder.dispose();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Audio Recorder"),
        centerTitle: true,
        elevation: 0,
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            AvatarGlow(
              glowColor: Colors.white,
              endRadius: 140.0,
              duration: Duration(milliseconds: 200),
              animate: recorder.isRecording?true:false,
              repeatPauseDuration: Duration(milliseconds: 100),
              child: CircleAvatar(
                radius: 100,
                backgroundColor: Colors.white,
                child: CircleAvatar(
                  backgroundColor: Colors.indigo.shade900.withBlue(70),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.mic),
                      TimerWidget(controller: timerController,),
                        SizedBox(height: 8,),

                    ],
                  ),
                  radius: 92.0,
                ),
              ),
            ),

            buildStart(),
          ],
        ),
      ),
    );
  }

  Widget buildStart() {

    final isRecording =recorder.isRecording;
    final icon =isRecording ?Icons.stop :Icons.mic;
    final text =isRecording ? 'STOP': 'START';
    final primary =isRecording? Colors.red :Colors.white;
    final onPrimary =isRecording ?Colors.white:Colors.black;
    return ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
            minimumSize: const Size(175, 50),
            primary: primary,
            onPrimary: onPrimary),
        onPressed: ()  async{
          // bool isPermissionOk=await recorder.checkMicrophonePermission();
          // if (isPermissionOk){
            await recorder.toggleRecording();
            final isRecording =recorder.isRecording;
            setState(() {
              if(isRecording){
                timerController.startTimer();
              }else{
                timerController.stopTimer();
              }
            });
          // }else{
          //   print("Something went Wrong");
          // }

        },
        icon: Icon(icon),
        label: Text(
          text,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ));
  }
}
