import 'dart:math';
import 'dart:ui';
import 'package:eso/database/chapter_item.dart';
import 'package:eso/main.dart';
import 'package:eso/menu/menu.dart';
import 'package:eso/menu/menu_chapter.dart';
import 'package:eso/eso_theme.dart';
import 'package:eso/page/chapter_new_page.dart';
import 'package:eso/page/photo_view_page.dart';
import 'package:eso/utils/router_helper.dart';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:text_composition/text_composition.dart';
import 'package:eso/ui/ui_image_item.dart';
import 'package:eso/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:eso/ui/widgets/draggable_scrollbar_sliver.dart';
import '../database/search_item_manager.dart';
import '../database/search_item.dart';
import '../model/chapter_page_provider.dart';
import 'content_page_manager.dart';
import 'langding_page.dart';

class NextPageAnimation extends StatefulWidget {
  final String text;
  const NextPageAnimation({Key key, this.text = "加载下一页。。。"}) : super(key: key);

  @override
  State<NextPageAnimation> createState() => _NextPageAnimationState();
}

class _NextPageAnimationState extends State<NextPageAnimation> {
  int count = 0;

  @override
  void initState() {
    start();
    super.initState();
  }

  @override
  void dispose() {
    count = -1;
    super.dispose();
  }

  void start() {
    if (count == -1 || !mounted) return;
    if (kDebugMode) {
      // print("播放动画 $count");
    }
    Future.delayed(const Duration(milliseconds: 200), start);
    setState(() {
      count++;
    });
  }

  @override
  Widget build(BuildContext context) {
    final text = widget.text;
    return Text(text.substring(0, count % (text.length + 1)));
  }
}

class ChapterPage extends StatefulWidget {
  final SearchItem searchItem;
  final bool fromHistory;
  const ChapterPage({this.searchItem, this.fromHistory = false, Key key})
      : super(key: key);

  @override
  _ChapterPageState createState() => _ChapterPageState(searchItem);
}

class _ChapterPageState extends State<ChapterPage> {
  _ChapterPageState(this.searchItem) : super();

  double opacity = 0.0;
  StateSetter state;
  final SearchItem searchItem;
  ScrollController _controller;

  @override
  void initState() {
    super.initState();
  }

  void jumpToSpecChapter(BuildContext context, int index) {
    print("jumpToSpecChapter $index");
    ChapterPageProvider provider = Provider.of<ChapterPageProvider>(context,listen: false);
    provider.changeChapter(index);
    Navigator.of(context)
        .push(ContentPageRoute().route(searchItem))
        .whenComplete(provider.adjustScroll);
  }

  Widget bottomRow(BuildContext context) {
    ChapterPageProvider provider = context.watch<ChapterPageProvider>();
    return Padding(
      padding: const EdgeInsets.only(left: 16.0,right: 16.0,bottom: 36.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(searchItem.chapters == null
                  ? "加载中"
                  : "共${searchItem.chapters.length}章"),
              Text(searchItem.chapters == null
                  ? "加载中"
                  : searchItem.chapters.last.name.length > 8 ? searchItem.chapters.last.name.substring(0,7) : searchItem.chapters.last.name),
            ],
          ),
          Container(
            height: 50,
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              color: Colors.yellow,
            ),
            child: TextButton(
                onPressed: () {
                  jumpToSpecChapter(
                      context, searchItem.durChapterIndex);
                },
                child: Text(
                  searchItem.durChapter.length > 7 ? "阅至 ${searchItem.durChapter.substring(0,6)}" : "阅至 ${searchItem.durChapter}",
                  style: TextStyle(
                      color: Theme.of(context)
                          .textTheme
                          .bodyText1
                          .color),
                )),
          ),
        ],
      ),
    );
  }

  Widget changeRule(BuildContext context) {
    ChapterPageProvider provider = context.watch<ChapterPageProvider>();
    return GestureDetector(
      onTap: () {
      provider.onSelect(MenuChapter.change, context);
      },
      child: Row(
        children: [
          Text(
            searchItem.origin,
            style: TextStyle(fontSize: 16.0),
          ),
          Icon(Icons.refresh_outlined,color: Colors.black,),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final topHeight = kToolbarHeight + MediaQuery.of(context).padding.top;
    _controller = ScrollController();
    print("CapturePage build");
    return ChangeNotifierProvider<ChapterPageProvider>(
      create: (context) =>
          ChapterPageProvider(searchItem: searchItem, size: size),
      builder: (context, child) => Container(
        // decoration: globalDecoration,
        color: Theme.of(context).canvasColor,
        child: SafeArea(
          bottom: false,
          top: false,
          child: Scaffold(
              appBar: _buildAlphaAppbar(context),
              body: Stack(
                children: [
                  Positioned(
                    left: 0.0,
                    right: 0.0,
                    top: 0.0,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            searchItem.name,
                            style: TextStyle(fontSize: 24.0),
                          ),
                          SizedBox(height: 8.0,),
                          Text(
                            searchItem.author,
                            style: TextStyle(fontSize: 16.0),
                          ),
                          SizedBox(height: 8.0,),
                          changeRule(context),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    left: 0.0,
                    right: 0.0,
                    top: 138.0,
                    height: MediaQuery.of(context).size.height - 138 - 64,
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(
                                20,
                              ),
                              topRight: Radius.circular(20.0)),
                          color: Colors.white),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "简介",
                              style: TextStyle(fontSize: 16),
                            ),
                            SizedBox(
                              height: 8.0,
                            ),
                            Column(
                              children: [Text(searchItem.description)],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TextButton(
                                    onPressed: () {
                                      RouterHelper.showBottomSheet(
                                        ChapterNewPage(
                                          searchItem: searchItem,
                                        ),
                                        context: context,
                                      );
                                    },
                                    child: Text(
                                      "全部章节",
                                      style: TextStyle(
                                        color: Theme.of(context).primaryColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )),
                                Row(
                                  children: [
                                    TextButton(
                                        onPressed: () {
                                          if (searchItem.chapters.isNotEmpty) {
                                            jumpToSpecChapter(context,
                                                searchItem.chapters.length - 1);
                                          }
                                        },
                                        child: Text(
                                          "更至 ${searchItem.chapters == null ? "无" : searchItem.chapters.last.name.length > 8 ? searchItem.chapters.last.name.substring(0,8) : searchItem.chapters.last.name}",
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .textTheme
                                                  .bodyText1
                                                  .color),
                                        )),
                                    Icon(Icons.keyboard_arrow_right),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 16.0,
                            ),
                            Image.network(
                              searchItem.cover,
                              width: double.infinity,
                              height: 329,
                              fit: BoxFit.cover,
                            ),
                            const SizedBox(
                              height: 16.0,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: bottomRow(context),
                  ),
                  Positioned(
                    top: 0,
                      right: 19,
                      child: Container(
                        width: 126,
                        height: 170,
                        clipBehavior: Clip.hardEdge,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Image.network(
                          searchItem.cover,
                          fit: BoxFit.cover,
                        ),
                      ),
                  ),
                  // buildPage(context),
                ],
              )),
        ),
      ),
    );
  }



  Widget buildPage(BuildContext context) {
    final page = Provider.of<ChapterPageProvider>(context, listen: true).page;
    print("ChapterPageProvider$page");
    if (page > 0)
      return Positioned(
        right: 20,
        bottom: 10,
        child: Row(
          children: [
            Text("${Provider.of<ChapterPageProvider>(context).page}"),
            NextPageAnimation(text: "页加载中")
          ],
        ),
      );
    return Positioned(
      right: 20,
      bottom: 10,
      child: Card(
          child: Text("${-Provider.of<ChapterPageProvider>(context).page}页")),
    );
  }

  //头部
  Widget _buildAlphaAppbar(BuildContext context) {
    final provider = Provider.of<ChapterPageProvider>(context, listen: false);

    return AppBar(
      elevation: 0.0,
      backgroundColor:
          Theme.of(context).appBarTheme.backgroundColor.withOpacity(opacity),
      centerTitle: true,
      title: Text(
        searchItem.name,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      actions: <Widget>[
        // 加入收藏时需要刷新图标，其他不刷新
        Consumer<ChapterPageProvider>(
          builder: (context, provider, child) => IconButton(
            icon: SearchItemManager.isFavorite(
                    searchItem.originTag, searchItem.url)
                ? Icon(Icons.favorite)
                : Icon(Icons.favorite_border),
            iconSize: 21,
            onPressed: provider.toggleFavorite,
          ),
        ),
        Menu<MenuChapter>(
          items: chapterMenus,
          onSelect: (value) => provider.onSelect(value, context),
        ),
      ],
    );
  }

  static double lastTopHeight = 0.0;


  List<ChapterRoad> parseChapers(List<ChapterItem> chapters) {
    currentRoad = 0;
    final roads = <ChapterRoad>[];
    if (chapters.isEmpty || !chapters.first.name.startsWith('@线路'))
      return roads;
    var roadName = chapters.first.name.substring(3);
    var startIndex = 1;
    for (var i = 1, len = chapters.length; i < len; i++) {
      if (chapters[i].name.startsWith('@线路')) {
        if (searchItem.durChapterIndex >= startIndex &&
            searchItem.durChapterIndex < i) {
          currentRoad = roads.length;
        }
        // 上一个线路
        roads.add(ChapterRoad(roadName, startIndex, i - startIndex));
        roadName = chapters[i].name.substring(3);
        startIndex = i + 1;
      }
    }
    // 最后一个线路
    roads.add(ChapterRoad(roadName, startIndex, chapters.length - startIndex));
    return roads;
  }
  var currentRoad = 0;

}

class ArcBannerImage extends StatelessWidget {
  ArcBannerImage(this.imageUrl, {this.arcH = 30.0, this.height = 335.0});
  final String imageUrl;
  final double height, arcH;

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: ArcClipper(this),
      child: Stack(
        children: [
          SizedBox(
            width: double.infinity,
            height: height,
            child:
                UIImageItem(cover: imageUrl, radius: null, fit: BoxFit.cover),
          ),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
            child: Container(
              color: Theme.of(context).bottomAppBarColor.withOpacity(0.8),
              height: height,
            ),
          ),
        ],
      ),
    );
  }
}

class ArcClipper extends CustomClipper<Path> {
  final ArcBannerImage widget;
  ArcClipper(this.widget);

  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0.0, size.height - widget.arcH);

    var firstControlPoint = Offset(size.width / 4, size.height);
    var firstPoint = Offset(size.width / 2, size.height);
    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstPoint.dx, firstPoint.dy);

    var secondControlPoint = Offset(size.width - (size.width / 4), size.height);
    var secondPoint = Offset(size.width, size.height - widget.arcH);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondPoint.dx, secondPoint.dy);

    path.lineTo(size.width, 0.0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class ChapterRoad {
  final String name;
  final int startIndex;
  final int length;
  ChapterRoad(this.name, this.startIndex, this.length);
}
