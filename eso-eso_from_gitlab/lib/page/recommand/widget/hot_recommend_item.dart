import 'package:eso/utils/org_color_utils.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HotRecommendItem extends StatelessWidget {
  const HotRecommendItem({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
        color: Colors.white,
      ),
      child: Column(
        children: [
          Container(
            width: 157,
            height: 188,
            margin: const EdgeInsets.all(8),
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Image.network(
              "https://img1.baidu.com/it/u=3593114214,976018682&fm=253&fmt=auto&app=138&f=JPEG?w=800&h=500",
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16.0,top: 4.0,right: 8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "名称",
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.black),
                ),
                const SizedBox(height: 3.0,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "分类",
                      style: TextStyle(
                          fontSize: 12, color: ColorsUtil.contractColor("#86909C")),
                    ),
                    Text(
                      "作者",
                      style: TextStyle(
                          fontSize: 12, color: ColorsUtil.contractColor("#86909C")),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
