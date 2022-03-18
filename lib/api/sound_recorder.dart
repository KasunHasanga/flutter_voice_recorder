

import 'dart:io';


import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';



class SoundRecorder {
  FlutterSoundRecorder? _audioRecorder;
  bool _isRecorderInitilized=false;

  bool get isRecording =>_audioRecorder!.isRecording;

  Future init() async{
    _audioRecorder =FlutterSoundRecorder();

    final status =await Permission.microphone.request();
    if(status!=PermissionStatus.granted){
      print('Microphone Permission Required');
      throw RecordingPermissionException('Microphone Permission Required');
    }
    await _audioRecorder!.openRecorder();
    _isRecorderInitilized=true;
  }


  Future checkMicrophonePermission() async{
    final status =await Permission.microphone.request();
    if(status!=PermissionStatus.granted){
      // ScaffoldMessenger.of(context).hideCurrentSnackBar();
      // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      //   content: Text('Please allow recording from settings.'),
      // ));
     return false;
    }else{
      return true;
    }
  }


Future dispose() async{
    if(!_isRecorderInitilized) return;
    _audioRecorder!.closeRecorder();
    _audioRecorder=null;
    _isRecorderInitilized =false;
}

  Future _record() async {
    if(!_isRecorderInitilized) return;
    Directory appDirectory = await getApplicationDocumentsDirectory();
    String filePath = await appDirectory.path +
        '/' +
        DateTime.now().millisecondsSinceEpoch.toString() +
        '.aac';
    await _audioRecorder!.startRecorder(toFile:filePath,codec: Codec.aacMP4);

  }

  Future _stop() async {
    if(!_isRecorderInitilized) return;
    await _audioRecorder!.stopRecorder();
  }

  Future toggleRecording() async{

    if(_audioRecorder!.isStopped){
      await _record();
    }else{
      await _stop();
    }
  }





}