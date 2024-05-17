import 'dart:io';

import 'package:eso/api/api.dart';
import 'package:eso/api/api_from_rule.dart';
import 'package:eso/database/rule.dart';
import 'package:eso/database/search_item.dart';
import 'package:eso/hive/theme_box.dart';
import 'package:eso/model/discover_page_controller.dart';
import 'package:eso/model/edit_source_provider.dart';
import 'package:eso/page/enum/content_type.dart';
import 'package:eso/page/recommand/widget/hot_recommend_item.dart';
import 'package:eso/page/recommand/widget/product_item_widget.dart';
import 'package:eso/utils/org_color_utils.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../global.dart';
import '../chapter_page.dart';
import 'entity/product_item.dart';

class RecommendHomePage extends StatefulWidget {
  final HomeContentType contentType;
  const RecommendHomePage({Key key, this.contentType}) : super(key: key);

  @override
  State<RecommendHomePage> createState() => _RecommendHomePageState();
}

class _RecommendHomePageState extends State<RecommendHomePage>
    with AutomaticKeepAliveClientMixin {
  List<ProductItem> itemList;
  EditSourceProvider _provider;
  EditSourceProvider _videoProvider;
  EditSourceProvider _pictureProvider;
  List<ListDataItem> _novelList = [];
  List<ListDataItem> _videoList = [];
  List<ListDataItem> _pictureList = [];
  int contentType;
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();


  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  void _openBox() async{
    await Hive.openBox(Global.rewardAdShowCountKey);
  }
  @override
  void initState() {
    createProvider();
    _openBox();
    super.initState();
  }

  void createProvider() async {
    _provider = EditSourceProvider(type: 2);
    _provider.ruleContentType = 1;
    await _provider.refreshData();
  }

  void createVideoProvider() async {
    _videoProvider = EditSourceProvider(type: 2);
    _videoProvider.ruleContentType = 2;
    await _videoProvider.refreshData();
  }

  void createPictureProvider() async {
    _pictureProvider = EditSourceProvider(type: 2);
    _pictureProvider.ruleContentType = 2;
    await _pictureProvider.refreshData();
  }

  List<Widget> _yourFavorite({ListDataItem dataItem}) {
    return dataItem.items.sublist(0, 6).map((searchItem) {
      return GestureDetector(
          onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (context) => ChapterPage(searchItem: searchItem)),
              ),
          child: ProductItemWidget(
            item: searchItem,
          ));
    }).toList();
  }

  Widget findListView({BuildContext context}) {
    double screenH = MediaQuery.of(context).size.height;
    final controller = Provider.of<DiscoverPageController>(context);
    if (controller.items != null && controller.items.isNotEmpty) {
      // print("findListView has data ${controller.items.length}");
      // for (var item in controller.items) {
      //   print("itemListCount ${item.items.length}");
      // }
      //小说
      if (contentType == 1) {
        print("小说数据回来了${controller.items.length}");
        _novelList = controller.items;
        //图片
      } else if (contentType == 0) {
        print("图片数据回来了${controller.items.length}");
        _pictureList = controller.items;
        //视频
      } else if (contentType == 2) {
        print("视频数据回来了");
        _videoList = controller.items;
      }

      ListDataItem item = controller.items[0];
      DiscoverMap map = controller.discoverMap[0];
      return ListView.builder(
        itemBuilder: (context, index) {
          if (index == 0) {
            return Container(
              margin: const EdgeInsets.all(16),
              height: (394 / 928) * screenH,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(15)),
              ),
              child: Column(
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 10, right: 10, top: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "猜你喜欢",
                          style: TextStyle(fontSize: 16, color: Colors.black),
                        ),
                        Text(
                          "换一换",
                          style: TextStyle(
                              fontSize: 14,
                              color: ColorsUtil.contractColor("#86909C")),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: GridView(
                        physics: NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 155 / 93,
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 10,
                        ),
                        padding: EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 10,
                        ),
                        children: item.items.isEmpty
                            ? [Container()]
                            : _yourFavorite(dataItem: item)),
                  )
                ],
              ),
            );
          } else {
            return Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 157 / 230,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10),
                itemBuilder: (context, index) {
                  SearchItem searchItem = item.items[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) =>
                                ChapterPage(searchItem: searchItem)),
                      );
                    },
                    child: HotRecommendItem(
                      searchItem: searchItem,
                    ),
                  );
                },
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: item.items.length,
              ),
            );
          }
        },
        itemCount: 2,
      );
    } else {
      print("findListView no data");
      return Center(
        child: CircularProgressIndicator(
          color: Colors.pink,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    print("${widget.contentType} recommand build");
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<EditSourceProvider>(
          create: (context) => _provider,
        ),
        // ChangeNotifierProvider<EditSourceProvider>(
        //   create: (context) => _pictureProvider,
        // ),
        // ChangeNotifierProvider<EditSourceProvider>(
        //   create: (context) => _videoProvider,
        // ),
      ],
      child: Consumer<EditSourceProvider>(builder: (context, value, child) {
        if (value.rules.isEmpty) {
          print("数据源空");
          return Container();
        } else {
          //数据源
          print("数据源不为空");
          Rule rule;
          rule = value.rules[5];
          print("返回的数据类型是${value.ruleContentType}");
          contentType = value.ruleContentType;
          // if (widget.contentType == HomeContentType.Picture) {
          //   rule = value.rules.last;
          // } else {
          //   rule = value.rules[5];
          // }
          return FutureBuilder<List<DiscoverMap>>(
            initialData: null,
            future: APIFromRUle(rule).discoverMap(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text("error: ${snapshot.error}");
              }
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(
                    color: Color(primaryColor),
                  ),
                );
              }
              return ChangeNotifierProvider<DiscoverPageController>(
                  create: (context) {
                return DiscoverPageController(
                    originTag: rule.id,
                    discoverMap: snapshot.data,
                    origin: rule.name,
                    searchUrl: rule.searchUrl);
              }, child: LayoutBuilder(
                builder: (context, p1) {
                  return findListView(context: context);
                },
              ));
            },
          );
        }
      }),
    );
  }
}
/*
*
* */
