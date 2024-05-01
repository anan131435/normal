import 'package:eso/page/recommand/widget/hot_recommend_item.dart';
import 'package:eso/page/recommand/widget/product_item_widget.dart';
import 'package:eso/utils/org_color_utils.dart';
import 'package:flutter/material.dart';

import 'entity/product_item.dart';

class RecommendPage extends StatefulWidget {
  const RecommendPage({Key key}) : super(key: key);

  @override
  State<RecommendPage> createState() => _RecommendPageState();
}

class _RecommendPageState extends State<RecommendPage> {
  List<ProductItem> itemList;
  @override
  void initState() {
    itemList = [
      ProductItem("王者荣耀", "img", "腾讯"),
      ProductItem("吃鸡", "img", "ali"),
      ProductItem("原神", "img", "腾讯"),
      ProductItem("王者荣耀", "img", "iOS"),
      ProductItem("吃鸡", "img", "Android"),
      ProductItem("原神", "img", "Flutter"),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
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
                    children: itemList
                        .map((e) => ProductItemWidget(
                              item: e,
                            ))
                        .toList(),
                  ),
                )
              ],
            ),
          );
        } else {
          return Container(
            width: double.infinity,
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Colors.white,
            ),
            child: Expanded(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 10, right: 10, top: 10.0),
                    child: Text("热门推荐",style: TextStyle(fontSize: 16, color: Colors.black)),
                  ),
                  Expanded(
                      child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 1/2,
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10
                      ), itemBuilder: (context, index) {
                        return HotRecommendItem();
                      },
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: 30,
                      )
                  ),
                ],
              ),
            ),
          );
        }
      },
      itemCount: 2,
    );
  }
}
