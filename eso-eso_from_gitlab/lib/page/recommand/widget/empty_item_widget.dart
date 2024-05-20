import 'package:eso/database/rule.dart';
import 'package:eso/database/search_item.dart';
import 'package:eso/utils/org_color_utils.dart';
import 'package:flutter/material.dart';

import '../entity/product_item.dart';
class EmptyItemWidget extends StatelessWidget {
  EmptyItemWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double itemWidth = (screenWidth - 62 ) / 2;

    return Container(
      color: Colors.white,
      // height: 73,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.all(8.0),
            width: itemWidth * 0.4 ,
            height: 1.27 * itemWidth * 0.4,
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.hourglass_empty),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 16.0,right: 8.0,bottom: 8.0),
              child: Column(
                children: [
                  Text("加载中",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500,color: Colors.black,),maxLines: 1,),
                  const SizedBox(height: 4,),
                  Text("加载中",style: TextStyle(fontSize: 14,color: ColorsUtil.contractColor("#A6A6A6")),maxLines: 1,),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
