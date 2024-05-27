import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:auto_orientation/auto_orientation.dart';
import 'package:dlna/dlna.dart';
import 'package:eso/database/history_item_manager.dart';
import 'package:eso/menu/menu.dart';
import 'package:eso/menu/menu_item.dart';
import 'package:eso/ui/ui_chapter_select.dart';
import 'package:eso/utils/flutter_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:huijing_ads_plugin/huijing_ads_plugin.dart';
import 'package:intl/intl.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:provider/provider.dart';
import 'package:device_display_brightness/device_display_brightness.dart';
import 'package:umeng_common_sdk/umeng_common_sdk.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';

import '../database/search_item.dart';
import '../database/search_item_manager.dart';
import '../global.dart';
import '../model/audio_service.dart';
import '../utils.dart';
import '../utils/dlna_util.dart';
import '../video/video_provider.dart';
import 'audio_page_refactor.dart';
import 'content_page_manager.dart';
import 'home/model/reward_listener.dart';

class VideoPage extends StatefulWidget {
  final SearchItem searchItem;
  const VideoPage({this.searchItem, Key key}) : super(key: key);

  @override
  State<VideoPage> createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> with WidgetsBindingObserver{
  HjRewardAd rewardAd;
  int _count = 0;
  EsoRewardListener _rewardListener;
  Timer _timer;
  var box = Hive.box(Global.rewardAdShowCountKey);

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed: {
        print("AppLifecycleState.resumed");
        _fireTimer();
        break;
      }
      case AppLifecycleState.paused:{
        print("AppLifecycleState.paused");
        cancelTimer();
        break;
      }
      case AppLifecycleState.inactive:{
        print("AppLifecycleState.inactive");
        cancelTimer();
        break;
      }
      case AppLifecycleState.detached:{
        print("AppLifecycleState.detached");
        cancelTimer();
        break;
      }
    }
    super.didChangeAppLifecycleState(state);
  }

  void _fireTimer() {
    int showCount = box.get(_fetchCurrentDate());
    if (showCount == null || showCount < 3 ) {
      cancelTimer();
      _timer = Timer.periodic(const Duration(seconds: 60), (timer) async {
        _count ++;
        print(_count);
        _startRequestAd();
      });
    } else {
      cancelTimer();
      print("达到3次了");
    }
  }

  String _fetchCurrentDate() {
    DateTime now = DateTime.now();
    String dateStr = DateFormat.yMd().format(now);
    return dateStr;
  }

  void cancelTimer() {
    if (_timer != null) {
      print("timer销毁");
      _timer.cancel();
    }
  }

  void _startRequestAd() {
    if (Platform.isIOS) {
      _requestRewardAd();
    } else {
      _requestAndroidRewardAd();
    }
  }

  void _requestRewardAd() async {
    if (rewardAd == null) {
      HjAdRequest request = HjAdRequest(placementId: "3283392768998526");
      rewardAd = HjRewardAd(
          request: request,
          listener: _rewardListener);
      rewardAd.loadAdData();
    } else {
      _showRewardAd();
    }
  }

  void _showRewardAd() async {
    bool isReady = await rewardAd.isReady();
    print("xiuxiu isReady $isReady");
    if (isReady) {
      rewardAd.showAd();
    } else {
      rewardAd.loadAdData();
    }
  }

  void _requestAndroidRewardAd() async {
    if (rewardAd == null) {
      HjAdRequest request = HjAdRequest(placementId: "8727293799263656");
      rewardAd = HjRewardAd(
          request: request,
          listener: _rewardListener);
      rewardAd.loadAdData();
    } else {
      _showRewardAd();
    }
  }
  //监听广告SDK回调
  void _onListenAdCallback() {
    eventBus.on<String>().listen((event) async{
      String dateStr = _fetchCurrentDate();
      int showCount = box.get(dateStr);
      print("xiuxiu回调了$event");
      if (event == "onAdReward") {
        UmengCommonSdk.onEvent("getReward", {"date":dateStr,"platForm":Platform.isIOS ? "iOS" : "Android"});
        print("xiuxiu${dateStr}存储了${showCount}次奖励");
        if (showCount == null ) {
          showCount = 1;
        } else {
          showCount += 1;
        }
        print("xiuxiu${dateStr}拿到了${showCount}次奖励");
        box.put(dateStr, showCount);
        if (showCount >= 3) {
          cancelTimer();
        }
      } else if (event == "onAdClose") {

        print("xiuxiu${dateStr}关闭广告了");
        // if (showCount == null || showCount < 3) {
        //   _startRequestAd();
        // }
      }

    });
  }


  @override
  void initState() {
    _onListenAdCallback();
    _rewardListener = EsoRewardListener(loadCallBack: (ad) {
      print("广告加载回调OK");
    },rewardCallBack: () {
      print("广告激励回调OK");
    },closeCallBack: (){
      print("广告关闭回调OK");
    });
    _fireTimer();
    _startRequestAd();
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void deactivate() {
    cancelTimer();
    super.deactivate();
  }

  @override
  void dispose() {
    cancelTimer();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final contentProvider = Provider.of<ContentProvider>(context);
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: Colors.black87,
        body: ChangeNotifierProvider<VideoPageProvider>(
          create: (context) =>
              VideoPageProvider(searchItem: widget.searchItem, contentProvider: contentProvider),
          builder: (BuildContext context, child) {
            final provider = Provider.of<VideoPageProvider>(context, listen: false);
            final isLoading =
                context.select((VideoPageProvider provider) => provider.isLoading);
            final showController =
                context.select((VideoPageProvider provider) => provider.showController);
            final hint = context.select((VideoPageProvider provider) => provider.hint);
            final showChapter =
                context.select((VideoPageProvider provider) => provider.showChapter);
            return Stack(
              children: [
                _buildPlayer(!isLoading && !Global.isDesktop, context),
                if (isLoading)
                  Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: _buildLoading(context),
                    ),
                  ),
                if (isLoading)
                  Positioned(
                    left: 30,
                    bottom: 80,
                    right: 30,
                    child: _buildLoadingText(context),
                  ),
                if (showController)
                  Container(
                    padding: EdgeInsets.fromLTRB(
                        10, 10 + MediaQuery.of(context).padding.top, 10, 10),
                    color: Color(0x20000000),
                    child: _buildTopBar(context),
                  ),
                if (showController)
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(4, 4, 4, 8),
                      color: Color(0x20000000),
                      child: _buildBottomBar(context),
                    ),
                  ),
                if (showChapter)
                  UIChapterSelect(
                    loadChapter: (index) => provider.loadChapter(index),
                    searchItem: widget.searchItem,
                    color: Colors.black45,
                    fontColor: Colors.white70,
                    border: BorderSide(color: Colors.white12, width: Global.borderSize),
                    heightScale: 0.6,
                  ),
                if (hint != null)
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Color(0x20000000),
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                      ),
                      child: hint,
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildPlayer(bool showPlayer, BuildContext context) {
    final provider = Provider.of<VideoPageProvider>(context, listen: false);
    if (showPlayer) {
      final controller =
          context.select((VideoPageProvider provider) => provider.controller);
      final aspectRatio =
          context.select((VideoPageProvider provider) => provider.aspectRatio);
      return GestureDetector(
        child: Container(
          // 增加color才能使全屏手势生效
          color: Colors.transparent,
          width: double.infinity,
          height: double.infinity,
          alignment: Alignment.center,
          child: aspectRatio == VideoAspectRatio.full || provider.getAspectRatio() == 0
              ? VideoPlayer(controller)
              : AspectRatio(
                  aspectRatio: provider.getAspectRatio(),
                  child: VideoPlayer(controller),
                ),
        ),
        onDoubleTap: provider.playOrPause,
        onTap: provider.toggleControllerBar,
        onHorizontalDragStart: provider.onHorizontalDragStart,
        onHorizontalDragUpdate: provider.onHorizontalDragUpdate,
        onHorizontalDragEnd: provider.onHorizontalDragEnd,
        onVerticalDragStart: provider.onVerticalDragStart,
        onVerticalDragUpdate: provider.onVerticalDragUpdate,
      );
    }
    return GestureDetector(
      child: Container(
        // 增加color才能使全屏手势生效
        color: Colors.transparent,
        width: double.infinity,
        height: double.infinity,
        alignment: Alignment.center,
      ),
      onTap: provider.toggleControllerBar,
    );
  }

  Widget _buildLoading(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: 20,
          width: 20,
          margin: EdgeInsets.only(bottom: 10),
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(const Color(0xA0FFFFFF)),
            strokeWidth: 2,
          ),
        ),
        Text(
          context.select((VideoPageProvider provider) => provider.titleText),
          style: const TextStyle(
            color: const Color(0xD0FFFFFF),
            fontWeight: FontWeight.bold,
            fontSize: 12,
            height: 2,
          ),
        ),
      ],
    );
  }

  Widget _buildLoadingText(BuildContext context) {
    context.select((VideoPageProvider provider) => provider.loadingText.length);
    const style = TextStyle(
      color: Color(0xB0FFFFFF),
      fontSize: 12,
    );
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: context
          .select((VideoPageProvider provider) => provider.loadingText)
          .map((s) => Text(
                s,
                style: style,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ))
          .toList(),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    final provider = Provider.of<VideoPageProvider>(context, listen: false);
    final vertical = context
        .select((VideoPageProvider provider) => provider.screenAxis == Axis.vertical);
    final speed = context.select((VideoPageProvider provider) => provider.currentSpeed);
    final primaryColor = Theme.of(context).primaryColor;
    return Row(
      children: [
        Container(
          height: 20,
          child: IconButton(
            padding: EdgeInsets.zero,
            icon: Icon(Icons.arrow_back_ios, size: 20),
            onPressed: () => Navigator.of(context).pop(),
            color: Colors.white,
            tooltip: "返回",
          ),
        ),
        Expanded(
          child: Text(
            context.select((VideoPageProvider provider) => provider.titleText),
            style: TextStyle(color: Colors.white),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ),
        Container(
          height: 20,
          child: IconButton(
            color: Colors.white,
            iconSize: 20,
            padding: EdgeInsets.zero,
            icon: Icon(Icons.open_in_browser),
            onPressed: () =>
                launch(widget.searchItem.chapters[widget.searchItem.durChapterIndex].contentUrl),
            tooltip: "查看原网页",
          ),
        ),
        Container(
          height: 20,
          child: IconButton(
            color: Colors.white,
            iconSize: 20,
            padding: EdgeInsets.zero,
            icon: Icon(Icons.open_in_new),
            onPressed: provider.openInNew,
            tooltip: "使用其他播放器打开",
          ),
        ),
        Container(
          height: 20,
          child: Menu<double>(
            tooltip: "倍速",
            icon: Icons.slow_motion_video_outlined,
            color: Colors.white,
            items: [0.5, 0.75, 1.0, 1.25, 1.5, 1.75, 2.0]
                .map((value) => MenuItemEso<double>(
                      value: value,
                      text: "$value",
                      textColor: (speed - value).abs() < 0.1 ? primaryColor : null,
                    ))
                .toList(),
            onSelect: (double value) async {
              provider.changeSpeed(value);
            },
          ),
        ),
        if (vertical)
          IconButton(
            color: Colors.white,
            iconSize: 20,
            padding: EdgeInsets.zero,
            icon: Icon(Icons.airplay),
            onPressed: () => provider.openDLNA(context),
            tooltip: "DLNA投屏",
          ),
        if (vertical)
          IconButton(
            color: Colors.white,
            iconSize: 20,
            padding: EdgeInsets.zero,
            icon: Icon(Icons.zoom_out_map),
            onPressed: provider.zoom,
            tooltip: "缩放",
          ),
        Container(
          height: 20,
          child: IconButton(
            padding: EdgeInsets.zero,
            icon: Icon(Icons.format_list_bulleted, size: 20),
            onPressed: () => provider.toggleChapterList(),
            color: Colors.white,
            tooltip: "节目列表",
          ),
        ),
      ],
    );
  }

  Widget _buildBottomBar(BuildContext context) {
    return Consumer<VideoPageProvider>(
      builder: (context, provider, child) {
        final value = provider.isLoading ? 0 : provider.position.inSeconds.toDouble();
        return SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              provider.isLoading
                  ? LinearProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                          VideoProgressColors().playedColor),
                      backgroundColor: VideoProgressColors().backgroundColor,
                    )
                  : FlutterSlider(
                      values: [value > 0 ? value : 0],
                      min: 0,
                      max: provider.duration.inSeconds.toDouble(),
                      onDragging: (handlerIndex, lowerValue, upperValue) {
                        provider.setHintText(
                            "跳转至  " +
                                Utils.formatDuration(
                                    Duration(seconds: (lowerValue as double).toInt())),
                            true);
                        provider.controller
                            .seekTo(Duration(seconds: (lowerValue as double).toInt()));
                      },
                      handlerHeight: 12,
                      handlerWidth: 12,
                      handler: FlutterSliderHandler(
                        child: Container(
                          width: 12,
                          height: 12,
                          alignment: Alignment.center,
                          child: Icon(Icons.videocam, color: Colors.red, size: 8),
                        ),
                      ),
                      touchSize: 20,
                      trackBar: FlutterSliderTrackBar(
                        inactiveTrackBar: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.white54,
                        ),
                        activeTrackBar: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: Colors.white70,
                        ),
                      ),
                      tooltip: FlutterSliderTooltip(disabled: true),
                    ),
              Padding(
                padding: const EdgeInsets.only(right: 6),
                child: Text(
                  provider.isLoading
                      ? "" //"--:-- / --:--"
                      : "${provider.positionString} / ${provider.durationString}",
                  style: TextStyle(fontSize: 10, color: Colors.white),
                  textAlign: TextAlign.end,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    color: provider.allowPlaybackground ? Colors.red : Colors.grey,
                    iconSize: 20,
                    padding: EdgeInsets.zero,
                    icon: Icon(Icons.switch_video),
                    onPressed: () =>
                        provider.allowPlaybackground = !provider.allowPlaybackground,
                    tooltip: "后台播放",
                  ),
                  if (provider.screenAxis == Axis.horizontal)
                    IconButton(
                      color: Colors.white,
                      iconSize: 20,
                      padding: EdgeInsets.zero,
                      icon: Icon(Icons.airplay),
                      onPressed: () => provider.openDLNA(context),
                      tooltip: "DLNA投屏",
                    ),
                  IconButton(
                    color: Colors.white,
                    iconSize: 25,
                    padding: EdgeInsets.zero,
                    icon: Icon(Icons.skip_previous),
                    onPressed: () =>
                        provider.parseContent(widget.searchItem.durChapterIndex - 1),
                    tooltip: "上一集",
                  ),
                  IconButton(
                    color: Colors.white,
                    iconSize: 40,
                    padding: EdgeInsets.zero,
                    icon: Icon(!provider.isLoading && provider.isPlaying
                        ? Icons.pause
                        : Icons.play_arrow),
                    onPressed: provider.playOrPause,
                    tooltip: !provider.isLoading && provider.isPlaying ? "暂停" : "播放",
                  ),
                  IconButton(
                    color: Colors.white,
                    iconSize: 25,
                    padding: EdgeInsets.zero,
                    icon: Icon(Icons.skip_next),
                    onPressed: () =>
                        provider.parseContent(widget.searchItem.durChapterIndex + 1),
                    tooltip: "下一集",
                  ),
                  if (provider.screenAxis == Axis.horizontal)
                    IconButton(
                      color: Colors.white,
                      iconSize: 20,
                      padding: EdgeInsets.zero,
                      icon: Icon(Icons.zoom_out_map),
                      onPressed: provider.zoom,
                      tooltip: "缩放",
                    ),
                  IconButton(
                    color: Colors.white,
                    iconSize: 20,
                    padding: EdgeInsets.zero,
                    icon: Icon(Icons.screen_rotation),
                    onPressed: provider.screenRotation,
                    tooltip: "旋转",
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }
}



enum VideoAspectRatio {
  uninit, // 未初始化
  auto, // 自动
  full, // 充满
  a43, // 4：3
  a169, // 16：9
  a916, // 9：16
}
