import 'package:eso/database/rule.dart';
import 'package:eso/database/search_item.dart';
import 'package:eso/utils/org_color_utils.dart';
import 'package:flutter/material.dart';

import '../entity/product_item.dart';
class ProductItemWidget extends StatelessWidget {
  Rule rule;
  ProductItemWidget({Key key, this.rule}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final iconUrl = rule.icon != null && rule.icon.isNotEmpty
        ? rule.icon
        : Uri.tryParse(rule.host)?.resolve("/favicon.ico")?.toString();
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
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Image.network(
              iconUrl,
              fit: BoxFit.cover,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 16.0,right: 8.0,bottom: 8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(rule.name,style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500,color: Colors.black,),maxLines: 2,),
                  const SizedBox(height: 4,),
                  Text(rule.author,style: TextStyle(fontSize: 14,color: ColorsUtil.contractColor("#A6A6A6")),maxLines: 1,),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
