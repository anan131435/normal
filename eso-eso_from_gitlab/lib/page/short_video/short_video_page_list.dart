import 'package:auto_orientation/auto_orientation.dart';
import 'package:eso/database/search_item.dart';
import 'package:eso/page/short_video/short_video_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';

import '../../global.dart';
import '../../menu/menu.dart';
import '../../menu/menu_item.dart';
import '../../utils.dart';
import '../../utils/flutter_slider.dart';
import '../../video/video_provider.dart';
import '../content_page_manager.dart';

class ShortVideoPageList extends StatefulWidget {
  final SearchItem searchItem;
  const ShortVideoPageList({Key key,this.searchItem}) : super(key: key);

  @override
  State<ShortVideoPageList> createState() => _ShortVideoPageListState();
}

class _ShortVideoPageListState extends State<ShortVideoPageList> {
  final PageController _pageController = PageController(initialPage: 0,keepPage: true);
  SearchItem _searchItem;
  ShortVideoPage videoPage;
  @override
  void initState() {
    _searchItem = widget.searchItem;
    AutoOrientation.portraitUpMode();
    super.initState();
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
            print("shortVideo page builder");
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
                PageView.builder(itemBuilder: (context, index) {
                  return _buildPlayer(!isLoading, context);
                },
                  itemCount: _searchItem.chapters.length,
                  scrollDirection: Axis.vertical,
                  controller: _pageController,
                  onPageChanged: (value) {
                    provider.loadChapter(value);
                  },
                ),
                if (isLoading)
                  Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 120),
                      child: _buildLoading(context),
                    ),
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
              ],
            );
          },
        ),
      ),
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

  Widget _buildPlayer(bool showPlayer, BuildContext context) {
    final provider = Provider.of<VideoPageProvider>(context, listen: false);
    if (showPlayer) {
      VideoPlayerController controller =
      context.select((VideoPageProvider provider) => provider.controller);
      final aspectRatio =
      context.select((VideoPageProvider provider) => provider.aspectRatio);
      print("controller is ${controller}");
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
        // onVerticalDragStart: provider.onVerticalDragStart,
        // onVerticalDragUpdate: provider.onVerticalDragUpdate,
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
}
