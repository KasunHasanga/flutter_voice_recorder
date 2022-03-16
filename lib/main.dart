import 'package:flutter/material.dart';
import 'package:voice_recorder/api/sound_recorder.dart';

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
      appBar: AppBar(
        title: const Text("Audio Recorder"),
        centerTitle: true,
        elevation: 0,
      ),
      body: Center(
        child: buildStart(),
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
            setState(() {

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
