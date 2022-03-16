import 'package:flutter/material.dart';

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
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Audio Recorder"),
        centerTitle: true,
        elevation: 0,
      ),
      body: Center(
        child: buildStart(),
      ),
    );
  }

  Widget buildStart() {

    final isRecording =true;
    final icon =isRecording ?Icons.stop :Icons.mic;
    final text =isRecording ? 'STOP': 'START';
    final primary =isRecording? Colors.red :Colors.white;
    final onPrimary =isRecording ?Colors.white:Colors.black;
    return ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
            minimumSize: Size(175, 50),
            primary: primary,
            onPrimary: onPrimary),
        onPressed: ()  {

        },
        icon: Icon(icon),
        label: Text(
          text,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ));
  }
}
