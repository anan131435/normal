import 'package:eso/database/rule.dart';
import 'package:eso/utils/org_color_utils.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HotRecommendItem extends StatelessWidget {
  final Rule rule;
  const HotRecommendItem({Key key,this.rule}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final iconUrl = rule.icon != null && rule.icon.isNotEmpty
        ? rule.icon
        : Uri.tryParse(rule.host)?.resolve("/favicon.ico")?.toString();
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
              iconUrl,
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
                  rule.name,
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
                      rule.group,
                      style: TextStyle(
                          fontSize: 12, color: ColorsUtil.contractColor("#86909C")),
                    ),
                    Text(
                      rule.author,
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
