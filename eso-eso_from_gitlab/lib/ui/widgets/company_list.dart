
import 'package:flutter/material.dart';


import '../../../utils/org_color_utils.dart';
import 'company_item.dart';

class CompanyListWidget extends StatelessWidget {
  final List<String> companyList;
  final Function() onTap;

  const CompanyListWidget({
    Key key,
     this.companyList,
     this.onTap,
  }) : super(key: key);

  double boundingTextHeight(
      { BuildContext context,
      String text,
        TextStyle style,
      int maxLines = 2 ^ 31,
      double maxWidth = double.infinity}) {
    if (text == null || text.isEmpty) {
      return 0;
    }
    TextPainter textPainter = TextPainter(
      textDirection: TextDirection.ltr,
      locale: Localizations.localeOf(context),
      text: TextSpan(text: text, style: style),
      maxLines: maxLines,
    )..layout(maxWidth: maxWidth);
    return textPainter.size.height;
  }

  double _calculateHeight({ BuildContext context, double maxWidth}) {
    double longTitleH = 0.0;
    for (var entity in companyList) {
      double height = boundingTextHeight(
        context: context,
        text: entity,
        style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black),
      );
      height = height + 24;
      longTitleH = longTitleH + height;
    }

    double totalHeight = longTitleH + 40.0;
    if (totalHeight > 318) {
      return 318.0;
    } else {
      return totalHeight;
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width - 80.0 - 24.0 - 12.0;
    return Container(
      width: double.infinity,
      height: _calculateHeight(context: context,maxWidth: screenWidth),
      margin: const EdgeInsets.only(top: 12.0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: ColorsUtil.contractColor("000000", alpha: 0.2),
              offset: const Offset(0, 4.0),
              blurRadius: 6.0,
            ),
          ]),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              children: [
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return CompanyItem(
                                entity: companyList[index],
                              );
                            },
                            itemCount: companyList.length,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.only(right: 20, top: 20),
              child: Icon(Icons.close_sharp),
            ),
          ),
        ],
      ),
    );
  }
}


