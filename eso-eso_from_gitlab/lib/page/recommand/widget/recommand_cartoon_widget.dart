import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../api/api.dart';
import '../../../api/api_from_rule.dart';
import '../../../database/rule.dart';
import '../../../database/search_item.dart';
import '../../../hive/theme_box.dart';
import '../../../model/discover_page_controller.dart';
import '../../../model/edit_source_provider.dart';
import '../../chapter_page.dart';
import 'hot_recommend_item.dart';
class RecommendCartoonWidget extends StatefulWidget {
  const RecommendCartoonWidget({Key key}) : super(key:key);

  @override
  State<RecommendCartoonWidget> createState() => _RecommendCartoonWidgetState();
}

class _RecommendCartoonWidgetState extends State<RecommendCartoonWidget> {
  EditSourceProvider _provider;

  void createProvider() async {
    _provider = EditSourceProvider(type: 2);
    _provider.ruleContentType = 0;
    await _provider.refreshData();
  }
  @override
  void initState() {
    createProvider();
    super.initState();
  }

  Widget findListView({BuildContext context}) {

    final controller = Provider.of<DiscoverPageController>(context);
    print("动漫listView ${controller.items}");
    if (controller.items == null || controller.items.isEmpty) {
      return Container();
    } else {
      ListDataItem item = controller.items[0];
      print("动漫实例${item.length}");
      return Padding(
        padding: const EdgeInsets.only(left: 16.0, right: 16.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 157 / 230,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10),
          itemBuilder: (context, index) {
            SearchItem searchItem = item.items[index];
            return GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (context) =>
                          ChapterPage(searchItem: searchItem)),
                );
              },
              child: HotRecommendItem(
                searchItem: searchItem,
              ),
            );
          },
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: item.items.length,
        ),
      );
    }


  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => _provider,
      builder: (context, child) {
        if (_provider.rules.isEmpty) {
          return Container();
        } else {
          Rule rule;
          rule = _provider.rules.last;
          return FutureBuilder<List<DiscoverMap>>(
            initialData: null,
            future: APIFromRUle(rule).discoverMap(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text("error: ${snapshot.error}");
              }
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(
                    color: Color(primaryColor),
                  ),
                );
              }
              return ChangeNotifierProvider<DiscoverPageController>(
                  create: (context) {
                    return DiscoverPageController(
                        originTag: rule.id,
                        discoverMap: snapshot.data,
                        origin: rule.name,
                        searchUrl: rule.searchUrl);
                  }, child: LayoutBuilder(
                builder: (context, p1) {
                  return findListView(context: context);
                },
              ));
            },
          );
        }
      },
    );
  }



}
