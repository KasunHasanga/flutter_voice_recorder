import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

class RecordListView extends StatefulWidget {
  final List<String> records;
  const RecordListView({
    Key? key,
    required this.records,
  }) : super(key: key);

  @override
  _RecordListViewState createState() => _RecordListViewState();
}

class _RecordListViewState extends State<RecordListView> {
  late int _totalDuration;
  late int _currentDuration;
  double _completedPercentage = 0.0;
  bool _isPlaying = false;
  int _selectedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return widget.records.isEmpty
        ? Center(child: Text('No records yet '))
        : ListView.builder(
      itemCount: widget.records.length,
      shrinkWrap: true,
      reverse: true,
      itemBuilder: (BuildContext context, int i) {
        return ExpansionTile(
          title: Text('New recoding ${widget.records.length - i}'),
          subtitle: Text(_getDateFromFilePatah(
              filePath: widget.records.elementAt(i))),
          onExpansionChanged: ((newState) {
            if (newState) {
              setState(() {
                _selectedIndex = i;
              });
            }
          }),
          children: [
            Container(
              height: 125,
              padding: const EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  LinearProgressIndicator(
                    minHeight: 5,
                    backgroundColor: Colors.black,
                    valueColor:
                    AlwaysStoppedAnimation<Color>(Colors.green),
                    value: _selectedIndex == i ? _completedPercentage : 0,
                  ),
                  IconButton(
                    icon: _selectedIndex == i
                        ? _isPlaying
                        ? Icon(Icons.pause)
                        : Icon(Icons.play_arrow)
                        : Icon(Icons.play_arrow),
                    onPressed: () => _onPlay(
                        filePath: widget.records.elementAt(i), index: i),
                  ),
                  IconButton(
                    icon: Icon(Icons.share),
                    onPressed: () {
                      print(widget.records.elementAt(i));
                      Share.shareFiles([widget.records.elementAt(i)], text: _getNameFromFilePath(filePath:widget.records.elementAt(i)));
                    }
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _onPlay({required String filePath, required int index}) async {
    AudioPlayer audioPlayer = AudioPlayer();

    if (!_isPlaying) {
      audioPlayer.play(filePath, isLocal: true);
      setState(() {
        _selectedIndex = index;
        _completedPercentage = 0.0;
        _isPlaying = true;
      });

      audioPlayer.onPlayerCompletion.listen((_) {
        setState(() {
          _isPlaying = false;
          _completedPercentage = 0.0;
        });
      });
      audioPlayer.onDurationChanged.listen((duration) {
        setState(() {
          _totalDuration = duration.inMicroseconds;
        });
      });

      audioPlayer.onAudioPositionChanged.listen((duration) {
        setState(() {
          _currentDuration = duration.inMicroseconds;
          _completedPercentage =
              _currentDuration.toDouble() / _totalDuration.toDouble();
        });
      });
    }
  }

  String _getDateFromFilePatah({required String filePath}) {
    String fromEpoch = filePath.substring(
        filePath.lastIndexOf('/') + 1, filePath.lastIndexOf('.'));

    DateTime recordedDate =
    DateTime.fromMillisecondsSinceEpoch(int.parse(fromEpoch));
    int year = recordedDate.year;
    int month = recordedDate.month;
    int day = recordedDate.day;

    return ('$year-$month-$day');
  }
  String _getNameFromFilePath({required String filePath}) {
    String fromEpoch = filePath.substring(
        filePath.lastIndexOf('/') + 1, filePath.lastIndexOf('.'));

    DateTime recordedDate =
    DateTime.fromMillisecondsSinceEpoch(int.parse(fromEpoch));
    int year = recordedDate.year;
    int month = recordedDate.month;
    int day = recordedDate.day;
    int hour = recordedDate.hour;
    int minute = recordedDate.minute;
    int second =recordedDate.second;

    return ('Recording $year:$month:$day-$hour:$minute:$second');
  }
}
