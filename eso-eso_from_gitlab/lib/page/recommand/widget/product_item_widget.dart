import 'package:eso/utils/org_color_utils.dart';
import 'package:flutter/material.dart';

import '../entity/product_item.dart';
class ProductItemWidget extends StatelessWidget {
  ProductItem item;
  ProductItemWidget({Key key, this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      // height: 73,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.all(8.0),
            width: 65,
            height: 83,
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
            padding: const EdgeInsets.only(top: 16.0,right: 8.0,bottom: 8.0),
            child: Column(
              children: [
                Text(item.name,style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500,color: Colors.black),),
                const SizedBox(height: 4,),
                Text(item.author,style: TextStyle(fontSize: 14,color: ColorsUtil.contractColor("#A6A6A6"))),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
