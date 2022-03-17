import 'dart:async';
import 'package:flutter/material.dart';

class TimerController extends ValueNotifier<bool>{
  TimerController({bool isPlaying =false}):super(isPlaying);

  void startTimer()=> value =true;

  void stopTimer() =>value =false;
}


class TimerWidget extends StatefulWidget {
  final TimerController controller;
  const TimerWidget({Key? key, required this.controller}) : super(key: key);

  @override
  State<TimerWidget> createState() => _TimerWidgetState();
}

class _TimerWidgetState extends State<TimerWidget> {
  Duration duration = Duration();
  Timer? timer;

  @override
  void initState() {
    super.initState();

    widget.controller.addListener(() {
      if(widget.controller.value){
        startTime();
      }else{
        stopTimer();
      }
    });
  }

  void reset() => setState(() {
        duration = Duration();
      });

  void addTime() {
    const addSecond = 1;

    setState(() {
      final seconds = duration.inSeconds + addSecond;

      if (seconds < 0) {
        timer?.cancel();
      } else {
        duration = Duration(seconds: seconds);
      }
    });
  }

  void startTime({bool resets = true}) {
    if (!mounted) return;
    if (resets) {
      reset();
    }
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      addTime();
    });
  }

  void stopTimer({bool resets = true}) {
    if (!mounted) return;
    if (resets) {
      reset();
    }
    setState(() {
      timer?.cancel();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(timeFormat(duration),style: TextStyle(fontSize: 26,fontWeight: FontWeight.bold),),

        Text(widget.controller.value ?"Recording":"Press Start")
      ],
    );
  }

  String timeFormat(Duration duration){
    String minutes=duration.inMinutes.remainder(60).toString().length>1?duration.inMinutes.remainder(60).toString():"0${duration.inMinutes.remainder(60).toString()}";
    String seconds=duration.inSeconds.remainder(60).toString().length>1?duration.inSeconds.remainder(60).toString():"0${duration.inSeconds.remainder(60).toString()}";
    return "$minutes : $seconds";
  }
}
