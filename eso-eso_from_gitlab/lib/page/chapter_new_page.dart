import 'package:eso/database/search_item.dart';
import 'package:eso/main.dart';
import 'package:eso/page/langding_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../database/chapter_item.dart';
import '../model/chapter_page_provider.dart';
import 'chapter_page.dart';

class ChapterNewPage extends StatefulWidget {
  final SearchItem searchItem;
  const ChapterNewPage({Key key, this.searchItem}) : super(key: key);

  @override
  State<ChapterNewPage> createState() => _ChapterNewPageState();
}

class _ChapterNewPageState extends State<ChapterNewPage> {
  SearchItem searchItem;
  var currentRoad = 0;
  @override
  void initState() {
    searchItem = widget.searchItem;
    super.initState();
  }

  List<ChapterRoad> parseChapers(List<ChapterItem> chapters) {
    currentRoad = 0;
    final roads = <ChapterRoad>[];
    if (chapters.isEmpty || !chapters.first.name.startsWith('@线路')) return roads;
    var roadName = chapters.first.name.substring(3);
    var startIndex = 1;
    for (var i = 1, len = chapters.length; i < len; i++) {
      if (chapters[i].name.startsWith('@线路')) {
        if (searchItem.durChapterIndex >= startIndex && searchItem.durChapterIndex < i) {
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

 Widget _buildChapter(BuildContext context) {
    return Consumer<ChapterPageProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return SliverToBoxAdapter(
            child: Container(height: 200, child: LandingPage()),
          );
        }
        final roads = parseChapers(searchItem.chapters);
        return ListView.builder(itemBuilder: (context, index) {
          return Text(searchItem.chapters[index].name);
        },
          itemCount: searchItem.chapters.length,
        );
      },
    );
 }
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return ChangeNotifierProvider<ChapterPageProvider>(
      create: (context) {
        return ChapterPageProvider(searchItem: searchItem, size: size);
      },
      builder: (context, child) {
        return Container(
          width: double.infinity,
          height: 318,
          margin: const EdgeInsets.only(top: 12.0),
          decoration: globalDecoration,
          child: _buildChapter(context),
        );
      },
    );
  }
}
