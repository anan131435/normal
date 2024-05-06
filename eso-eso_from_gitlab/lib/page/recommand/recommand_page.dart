import 'dart:io';

import 'package:eso/api/api.dart';
import 'package:eso/api/api_from_rule.dart';
import 'package:eso/database/rule.dart';
import 'package:eso/model/discover_page_controller.dart';
import 'package:eso/model/edit_source_provider.dart';
import 'package:eso/page/enum/content_type.dart';
import 'package:eso/page/recommand/widget/hot_recommend_item.dart';
import 'package:eso/page/recommand/widget/product_item_widget.dart';
import 'package:eso/utils/org_color_utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'entity/product_item.dart';

class RecommendPage extends StatefulWidget {
  final HomeContentType contentType;
  const RecommendPage({Key key, this.contentType}) : super(key: key);

  @override
  State<RecommendPage> createState() => _RecommendPageState();
}

class _RecommendPageState extends State<RecommendPage> {
  List<ProductItem> itemList;
  EditSourceProvider _provider;
  Rule _rule = null;
  List<DiscoverMap> _discoverMap;
  int contentTypeTag(HomeContentType type) {
    switch (type) {
      case HomeContentType.Novel:
        return 1;
      case HomeContentType.Picture:
        return 4;
      case HomeContentType.Audio:
        return 3;
      case HomeContentType.Video:
        return 2;
    }
  }

  @override
  void initState() {
    createProvider();
    super.initState();
  }

  void createProvider() async {
    _provider = EditSourceProvider(type: 2);
    _provider.ruleContentType = contentTypeTag(widget.contentType);
    await _provider.refreshData();
  }

  void _findDataSource() async {
    _discoverMap = await APIFromRUle(_rule).discoverMap();
  }

  @override
  Widget build(BuildContext context) {
    print("recommand build");
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => _provider,
        ),
      ],
      child: Consumer<EditSourceProvider>(
        builder: (context, value, child) {
          print("Consumer<EditSourceProvider>");
          return  ListView.builder(
            itemBuilder: (context, index) {
              if (index == 0) {
                return Container(
                  margin: const EdgeInsets.all(16),
                  height: 374,
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
                          children:  value.rules.isEmpty ? [Container()] : value.rules.sublist(0,6)
                              .map((e) => ProductItemWidget(
                            rule: e,
                          )).toList(),
                        ),
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
                      final rule = value.rules[index];
                      return HotRecommendItem(rule: rule,);
                    },
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: value.rules.length,
                  ),
                );
              }
            },
            itemCount: 2,
          );
        },
      ),
    );
  }
}
