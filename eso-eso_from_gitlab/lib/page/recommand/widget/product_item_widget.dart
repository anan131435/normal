import 'package:eso/utils/org_color_utils.dart';
import 'package:flutter/material.dart';

import '../entity/product_item.dart';
class ProductItemWidget extends StatelessWidget {
  ProductItem item;
  ProductItemWidget({Key key,this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.red,
      // width: 130,
      // height: 73,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Container(

              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.yellow,
              ),
              // child: Icon(Icons.alarm),
            ),
          ),
          Column(
            children: [
              Text(item.name,style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500,color: Colors.black),),
              const SizedBox(height: 4,),
              Text(item.author,style: TextStyle(fontSize: 14,color: ColorsUtil.contractColor("#A6A6A6")),),
            ],
          ),
        ],
      ),
    );
  }
}
