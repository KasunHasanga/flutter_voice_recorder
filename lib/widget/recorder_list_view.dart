import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:share_plus/share_plus.dart';
import 'package:voice_recorder/widget/recorderSingleView.dart';

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
  @override
  Widget build(BuildContext context) {
    return widget.records.isEmpty
        ? Center(child: Text('No records yet '))
        : ListView.builder(
      itemCount: widget.records.length,
      shrinkWrap: true,
      reverse: true,
      itemBuilder: (BuildContext context, int i) {
        return Slidable(
          key: ValueKey(i),
          child: ListTile(
            title:Text('New recoding ${widget.records.length - i}'),
            subtitle: Text(_getDateFromFilePatah(filePath: widget.records.elementAt(i))),
            // trailing:     Row(
            //
            //   children: [
            //     IconButton(
            //         icon: Icon(Icons.share),
            //         onPressed: () {
            //           print(widget.records.elementAt(i));
            //           Share.shareFiles([widget.records.elementAt(i)], text: _getNameFromFilePath(filePath:widget.records.elementAt(i)));
            //         }
            //     ),
            //     // IconButton(
            //     //     icon: Icon(Icons.delete_forever),
            //     //     onPressed: () async{
            //     //       final dir =Directory(widget.records.elementAt(i));
            //     //       await dir.delete(recursive: true);
            //     //
            //     //     }
            //     // ),
            //     IconButton(
            //         icon: Icon(Icons.cancel),
            //         onPressed: () {
            //           Navigator.push(
            //             context,
            //             MaterialPageRoute(builder: (context) =>  SingleRecordingView(record:widget.records.elementAt(i) ,)),
            //           );
            //
            //         }
            //     ),
            //   ],
            // ),

          ),
          startActionPane: ActionPane(
            // A motion is a widget used to control how the pane animates.
            motion: const ScrollMotion(),

            // A pane can dismiss the Slidable.
            dismissible: DismissiblePane(onDismissed: () {}),

            // All actions are defined in the children parameter.
            children:  [
              IconButton(
                  icon: Icon(Icons.share),
                  onPressed: () {
                    print(widget.records.elementAt(i));
                    Share.shareFiles([widget.records.elementAt(i)], text: _getNameFromFilePath(filePath:widget.records.elementAt(i)));
                  }
              ),
              IconButton(
                  icon: Icon(Icons.delete_forever),
                  onPressed: () async{
                    final dir =Directory(widget.records.elementAt(i));
                    await dir.delete(recursive: true);

                  }
              ),
              IconButton(
                  icon: Icon(Icons.cancel),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) =>  SingleRecordingView(record:widget.records.elementAt(i) ,)),
                    );

                  }
              ),
            ],
          ),

          // The end action pane is the one at the right or the bottom side.
          endActionPane:  ActionPane(
            motion: ScrollMotion(),
            children: [
              IconButton(
                  icon: Icon(Icons.share),
                  onPressed: () {
                    print(widget.records.elementAt(i));
                    Share.shareFiles([widget.records.elementAt(i)], text: _getNameFromFilePath(filePath:widget.records.elementAt(i)));
                  }
              ),
              IconButton(
                  icon: Icon(Icons.delete_forever),
                  onPressed: () async{
                    final dir =Directory(widget.records.elementAt(i));
                    await dir.delete(recursive: true);

                  }
              ),
              IconButton(
                  icon: Icon(Icons.cancel),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) =>  SingleRecordingView(record:widget.records.elementAt(i) ,)),
                    );

                  }
              ),
            ],
          ),
        );



      },
    );
  }


  String _getDateFromFilePatah({required String filePath}) {
    String fromEpoch = filePath.substring(
        filePath.lastIndexOf('/') + 1, filePath.lastIndexOf('.'));

    DateTime recordedDate =
    DateTime.fromMillisecondsSinceEpoch(int.parse(fromEpoch));
    int year = recordedDate.year;
    String month =recordedDate.month.toString().length==1?'0${recordedDate.month}': recordedDate.month.toString();
    String day =recordedDate.day.toString().length==1?'0${recordedDate.day}': recordedDate.day.toString();

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
