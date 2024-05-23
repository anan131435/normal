import 'package:eso/database/search_item.dart';
import 'package:eso/utils/org_color_utils.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HotRecommendItem extends StatelessWidget {
  final SearchItem searchItem;
  const HotRecommendItem({Key key,this.searchItem}) : super(key: key);
  String fetchCorrectImageCover() {
    if (searchItem.cover.contains(".jpg") && !searchItem.cover.endsWith(".jpg")) {
      int index = searchItem.cover.indexOf(".jpg");
      String cover = searchItem.cover.substring(0,index);
      print("截取后的字符串是$cover");
      return cover + ".jpg";
    } else {
      return searchItem.cover;
    }
  }
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double itemWidth = (screenWidth - 74 ) / 2;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
        color: Colors.white,
      ),
      child: Column(
        children: [
          Container(
            width: itemWidth - 2,
            height: (itemWidth - 2) * 1.18,
            margin: const EdgeInsets.all(8),
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Image.network(
             fetchCorrectImageCover(),
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
                  searchItem.name,
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.black),
                  maxLines: 1,
                ),
                const SizedBox(height: 3.0,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      searchItem.origin,
                      style: TextStyle(
                          fontSize: 12, color: ColorsUtil.contractColor("#86909C"),
                      ),
                      maxLines: 1,
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Text(
                            searchItem.author,
                            style: TextStyle(
                                fontSize: 12, color: ColorsUtil.contractColor("#86909C")),
                            maxLines: 1,
                          ),
                        ],
                      ),
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
