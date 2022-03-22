import 'dart:io';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:voice_recorder/api/sound_recorder.dart';
import 'package:voice_recorder/page/splash_screen.dart';
import 'package:voice_recorder/services/theme.dart';
import 'package:voice_recorder/services/theme_services.dart';
import 'package:voice_recorder/widget/recorderSingleView.dart';
import 'package:voice_recorder/widget/timer_widget.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Audio Recorder',
      debugShowCheckedModeBanner: false,
      theme: Themes.light,
      darkTheme: Themes.dark,
      themeMode: ThemeServices().theme,
      // home: HomePage(),
      home: SplashScreen(),
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
  late Directory appDirectory;
  List<String> records = [];
  late int refresherRecordCount;
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  void initState() {
    super.initState();
    initilizing();
    recorder.init();
  }

  void initilizing() async {
    getApplicationDocumentsDirectory().then((value) {
      appDirectory = value;
      appDirectory.list().listen((onData) {
        if (onData.path.contains('.aac')) records.add(onData.path);
      }).onDone(() {
        records = records.reversed.toList();
        refresherRecordCount = records.length;
        setState(() {});
      });
    });
    await GetStorage.init();
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
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text("Audio Recorder"),
        centerTitle: true,
        elevation: 0,
        leading: GestureDetector(
          onTap: () {
            ThemeServices().switchTheme();
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
          // Flexible(
          //   flex: 1,
          //   child: RecordListView(
          //       // records: records,
          //       ),
          // ),
          Flexible(
              flex: 1,
              child: SmartRefresher(
                enablePullDown: true,
                enablePullUp: false,
                header: const WaterDropHeader(),
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
                    title: Text(
                      'New recoding ${records.length - i}',
                      style: titleStyle,
                    ),
                    subtitle: Text(
                      getDateFromFilePath(filePath: records.elementAt(i)),
                      style: subTitleStyle,
                    ),
                    onTap: () async {
                      bool isDeleted = await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SingleRecordingView(
                                record: records.elementAt(i),
                                recoderName:
                                    'New recoding ${records.length - i}')),
                      );
                      if (isDeleted == true) {
                        _onRefresh();
                      }
                    },
                    trailing: const Icon(Icons.play_arrow_outlined),
                  )),
                  itemExtent: 100.0,
                  itemCount: records.length,
                ),
              )),
          Container(
            color: backgroundColor,
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

  void _onRefresh() async {
    // monitor network fetch
    await Future.delayed(const Duration(milliseconds: 1000));
    _onRecordComplete();
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    // monitor network fetch
    await Future.delayed(const Duration(milliseconds: 1000));
    // if failed,use loadFailed(),if no data return,use LoadNodata()
    if (refresherRecordCount < records.length) {
      refresherRecordCount++;
      records.add((records.length + 1).toString());
      if (mounted) {
        setState(() {});
      }
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
      refresherRecordCount = records.length;
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
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(40), topRight: Radius.circular(40))),
      child: AvatarGlow(
        glowColor: avatorGrowColor,
        endRadius: 140.0,
        duration: const Duration(milliseconds: 200),
        animate: recorder.isRecording ? true : false,
        repeatPauseDuration: const Duration(milliseconds: 100),
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
                  _onRefresh();
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
                  const SizedBox(
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
