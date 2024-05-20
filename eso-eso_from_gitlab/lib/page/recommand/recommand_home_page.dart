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
import 'package:eso/page/recommand/widget/recommand_cartoon_widget.dart';
import 'package:eso/utils/org_color_utils.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../global.dart';
import '../../ui/round_indicator.dart';
import '../../ui/widgets/keep_alive_widget.dart';
import '../../ui/widgets/size_bar.dart';
import '../chapter_page.dart';
import '../langding_page.dart';
import 'entity/product_item.dart';

class RecommendHomePage extends StatefulWidget {
  final HomeContentType contentType;
  const RecommendHomePage({Key key, this.contentType}) : super(key: key);

  @override
  State<RecommendHomePage> createState() => _RecommendHomePageState();
}

class _RecommendHomePageState extends State<RecommendHomePage>
    with AutomaticKeepAliveClientMixin,SingleTickerProviderStateMixin {
  List<ProductItem> itemList;
  EditSourceProvider _provider;
  List<DiscoverMap> discoverMap;
  TabController _tabController;


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

  PreferredSizeWidget _buildAppBarBottom(
      BuildContext context, DiscoverPageController pageController) {
    if (pageController == null || pageController.showSearchField) return null;
    if (discoverMap == null || discoverMap.isEmpty || discoverMap.length <= 1)
      return null;
    if (_tabController == null) {
      _tabController = TabController(length: discoverMap.length, vsync: this);
      _tabController.addListener(() {
        _select(pageController, _tabController.index);
      });
    }
    return SizedBar(
      child: TabBar(
        controller: _tabController,
        isScrollable: true,
        tabs: discoverMap.map((e) => Tab(text: e.name ?? '')).toList(),
        indicatorSize: TabBarIndicatorSize.label,
        indicator: RoundTabIndicator(
            insets: EdgeInsets.only(left: 5, right: 5),
            borderSide:
            BorderSide(width: 3.0, color: Theme.of(context).primaryColor)),
        labelColor: Theme.of(context).primaryColor,
        unselectedLabelColor: Theme.of(context).textTheme.bodyText1.color,
        onTap: (index) {
          _select(pageController, index);
        },
      ),
    );
  }

  _select(DiscoverPageController pageController, int index,
      [DiscoverPair pair]) {
    pageController.selectDiscoverPair(discoverMap[index].name, pair);
  }

  Widget _buildListView(
      BuildContext context, DiscoverPageController pageController, ListDataItem item,
      [DiscoverMap map, int index]) {
    if (item.isLoading) {
      return Column(
        children: [Expanded(child: LandingPage())],
      );
    }
    return  Column(
      children: [
        Expanded(
          child: GridView(
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 155 / 93,
                mainAxisSpacing: 5,
                crossAxisSpacing: 5,
              ),
              padding: EdgeInsets.symmetric(
                vertical: 8,
                horizontal: 10,
              ),
              children: (item == null || item.items.isEmpty)
                  ? [Container()]
                  : _yourFavorite(dataItem: item)),
        )
      ],
    );
  }

  Widget findListView({BuildContext context}) {
    double screenH = MediaQuery.of(context).size.height;
    final controller = Provider.of<DiscoverPageController>(context);
    if (controller.items != null && controller.items.isNotEmpty) {
      //小说
      List<Widget> children = [];
      if (controller.discoverMap.isNotEmpty) {
        for (var i = 0; i < discoverMap.length; i++) {
          children.add(KeepAliveWidget(
            wantKeepAlive: true,
            child: _buildListView(
                context, controller, controller.items[i], discoverMap[i], i),
          ));
        }
      }

      return ListView.builder(
        itemBuilder: (context, index) {
          if (index == 0) {
            return Container(
              margin: const EdgeInsets.all(16),
              height: (454 / 928) * screenH,
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
                  _buildAppBarBottom(context, controller),
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: children,
                    ),
                  )
                ],
              ),
            );
          } else {
            return RecommendCartoonWidget();
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
                    discoverMap = snapshot.data;
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

