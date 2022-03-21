import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:voice_recorder/services/theme.dart';
import 'package:voice_recorder/widget/recorderSingleView.dart';

class RecordListView extends StatefulWidget {
  // final List<String> records;
  const RecordListView({
    Key? key,
    // required this.records,
  }) : super(key: key);

  @override
  _RecordListViewState createState() => _RecordListViewState();
}

class _RecordListViewState extends State<RecordListView> {
  late Directory appDirectory;
  List<String> records = [];
  late int refresherRecordCount;
  RefreshController _refreshController =
  RefreshController(initialRefresh: false);


  @override
  void initState() {
    getApplicationDocumentsDirectory().then((value) {
      appDirectory = value;
      appDirectory.list().listen((onData) {
        if (onData.path.contains('.aac')) records.add(onData.path);
      }).onDone(() {
        records = records.reversed.toList();
        refresherRecordCount=records.length;
        setState(() {});
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    appDirectory.delete();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
return Scaffold(
  backgroundColor: backgroundColor,
body: SmartRefresher(
  enablePullDown: true,
  enablePullUp: false,
  header: WaterDropHeader(),
  // footer: CustomFooter(
  //   builder: (BuildContext context,LoadStatus mode){
  //     Widget body ;
  //     if(mode==LoadStatus.idle){
  //       body =  Text("pull up load");
  //     }
  //     else if(mode==LoadStatus.loading){
  //       body =  CupertinoActivityIndicator();
  //     }
  //     else if(mode == LoadStatus.failed){
  //       body = Text("Load Failed!Click retry!");
  //     }
  //     else if(mode == LoadStatus.canLoading){
  //       body = Text("release to load more");
  //     }
  //     else{
  //       body = Text("No more Data");
  //     }
  //     return Container(
  //       height: 55.0,
  //       child: Center(child:body),
  //     );
  //   },
  // ),
  controller: _refreshController,
  onRefresh: _onRefresh,
  onLoading: _onLoading,
  child: ListView.builder(
    itemBuilder: (c, i) => Card(
        child: ListTile(
          title: Text('New recoding ${records.length - i}',style: titleStyle,),
          subtitle: Text(getDateFromFilePath(
              filePath: records.elementAt(i)),style: subTitleStyle,),
          onTap: () async{
            bool isDeleted =await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => SingleRecordingView(
                      record: records.elementAt(i),
                      recoderName:
                      'New recoding ${records.length - i}')),
            );
            if(isDeleted!=null  &&isDeleted==true){
              _onRefresh();
            }
          },
          trailing: Icon(Icons.play_arrow_outlined),
        )),
    itemExtent: 100.0,
    itemCount: records.length,
  ),
)
);
  }
  void _onRefresh() async{
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    _onRecordComplete();
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }
  void _onLoading() async{
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use loadFailed(),if no data return,use LoadNodata()
    if(refresherRecordCount<records.length){
      refresherRecordCount++;
      records.add((records.length+1).toString());
      if(mounted)
        setState(() {

        });
    }


    _refreshController.loadComplete();
  }

  _onRecordComplete() {
    records.clear();
    appDirectory.list().listen((onData) {
      if (onData.path.contains('.aac')) records.add(onData.path);
    }).onDone(() {
      records.sort();
      records = records.reversed.toList();
      refresherRecordCount=records.length;
      setState(() {});
    });
  }
  
  String getDateFromFilePath({required String filePath}) {
    String fromEpoch = filePath.substring(
        filePath.lastIndexOf('/') + 1, filePath.lastIndexOf('.'));

    DateTime recordedDate =
        DateTime.fromMillisecondsSinceEpoch(int.parse(fromEpoch));
    int year = recordedDate.year;
    String month = recordedDate.month.toString().length == 1
        ? '0${recordedDate.month}'
        : recordedDate.month.toString();
    String day = recordedDate.day.toString().length == 1
        ? '0${recordedDate.day}'
        : recordedDate.day.toString();

    return ('$year-$month-$day');
  }

}
