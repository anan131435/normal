import 'package:eso/page/recommand/widget/product_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../api/api.dart';
import '../../../api/api_from_rule.dart';
import '../../../database/rule.dart';
import '../../../database/search_item.dart';
import '../../../hive/theme_box.dart';
import '../../../model/discover_page_controller.dart';
import '../../../model/edit_source_provider.dart';
import '../../../ui/round_indicator.dart';
import '../../../ui/widgets/keep_alive_widget.dart';
import '../../../ui/widgets/size_bar.dart';
import '../../../utils/org_color_utils.dart';
import '../../chapter_page.dart';
import '../../langding_page.dart';
import 'hot_recommend_item.dart';

class RecommendCartoonWidget extends StatefulWidget {
  const RecommendCartoonWidget({Key key}) : super(key: key);

  @override
  State<RecommendCartoonWidget> createState() => _RecommendCartoonWidgetState();
}

class _RecommendCartoonWidgetState extends State<RecommendCartoonWidget>
    with SingleTickerProviderStateMixin {
  EditSourceProvider _provider;
  List<DiscoverMap> discoverMap;
  TabController _tabController;
  void createProvider() async {
    _provider = EditSourceProvider(type: 2);
    _provider.ruleContentType = 0;
    await _provider.refreshData();
  }

  @override
  void initState() {
    createProvider();
    super.initState();
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

  Widget _buildListView(BuildContext context,
      DiscoverPageController pageController, ListDataItem item,
      [DiscoverMap map, int index]) {
    if (item.isLoading) {
      return Column(
        children: [Expanded(child: LandingPage())],
      );
    }
    return Column(
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
    print("动漫listView ${controller.items}");
    if (controller.items == null || controller.items.isEmpty) {
      return Container();
    } else {
      ListDataItem item = controller.items[0];
      print("动漫实例${item.length}");

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
              padding: const EdgeInsets.only(left: 10, right: 10, top: 10.0),
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
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => _provider,
      builder: (context, child) {
        if (_provider.rules.isEmpty) {
          return Container();
        } else {
          Rule rule;
          rule = _provider.rules.last;
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
      },
    );
  }
}
