import 'dart:convert';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:eso/api/api.dart';
import 'package:eso/api/api_from_rule.dart';
import 'package:eso/database/rule.dart';
import 'package:eso/database/rule_dao.dart';
import 'package:eso/main.dart';
import 'package:eso/menu/menu.dart';
import 'package:eso/menu/menu_discover_source.dart';
import 'package:eso/menu/menu_edit_source.dart';
import 'package:eso/page/discover_new_page.dart';
import 'package:eso/page/discover_search_page.dart';
import 'package:eso/page/source/edit_source_page.dart';
import 'package:eso/model/edit_source_provider.dart';
import 'package:eso/page/langding_page.dart';
import 'package:eso/ui/ui_text_field.dart';
import 'package:eso/ui/widgets/empty_list_msg_view.dart';
import 'package:eso/ui/widgets/keyboard_dismiss_behavior_view.dart';
import 'package:eso/utils.dart';
import 'package:eso/utils/rule_comparess.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:provider/provider.dart';
import '../eso_theme.dart';
import '../fonticons_icons.dart';
import '../global.dart';
import '../ui/ui_add_rule_dialog.dart';
import '../utils/auto_decode_cli.dart';
import 'discover_waterfall_page.dart';
import 'hidden/leshi_page.dart';
import 'hidden/linyuan_page.dart';
import 'hidden/schulte_grid.dart';
import 'share_page.dart';
import 'source/edit_rule_page.dart';

class DiscoverFuture extends StatelessWidget {
  final Rule rule;
  const DiscoverFuture({Key key, this.rule}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (rule.discoverUrl.startsWith("测试新发现瀑布流") || rule.discoverUrl.contains("@@DiscoverRule:")) {
      return DiscoverWaterfallPage(rule: rule);
    }
    if (rule.discoverUrl.startsWith("测试新发现")) {
      return DiscoverNewPage(rule: rule);
    }
    return FutureBuilder<List<DiscoverMap>>(
      future: APIFromRUle(rule).discoverMap(),
      initialData: null,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasError) {
          return Scaffold(
            body: Text("error: ${snapshot.error}"),
          );
        }
        if (!snapshot.hasData) {
          return LandingPage();
        }
        return DiscoverSearchPage(
          rule: rule,
          originTag: rule.id,
          origin: rule.name,
          discoverMap: snapshot.data,
        );
      },
    );
  }
}

class DiscoverPage extends StatefulWidget {
  @override
  _DiscoverPageState createState() => _DiscoverPageState();
}

EditSourceProvider editSourceProviderTemp;

class _DiscoverPageState extends State<DiscoverPage> {
  Widget _page;
  EditSourceProvider __provider;
  TextEditingController _searchEdit = TextEditingController();

  var isLargeScreen = false;
  Widget detailPage;

  void invokeTap(Widget detailPage) {
    if (isLargeScreen) {
      this.detailPage = detailPage;
      setState(() {});
    } else {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => detailPage,
          ));
    }
  }

  static int _lastContextType = -1;

  @override
  void dispose() {
    __provider?.dispose();
    editSourceProviderTemp = null;
    super.dispose();
  }
  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    if (_page == null) {
      _page = _buildPage();
    }

    return OrientationBuilder(builder: (context, orientation) {
      if (MediaQuery.of(context).size.width > 600) {
        isLargeScreen = true;
      } else {
        isLargeScreen = false;
      }

      return Row(children: <Widget>[
        Expanded(
          child: _page,
        ),
        SizedBox(
          height: double.infinity,
          width: 2,
          child: Material(
            color: Colors.grey.withAlpha(123),
          ),
        ),
        isLargeScreen ? Expanded(child: detailPage ?? Scaffold()) : Container(),
      ]);
    });
  }

  Widget _buildLinyuan() {
    return Row(
      children: [
        Container(
          height: 100,
          width: 100,
          padding: EdgeInsets.all(10),
          child: CircleAvatar(
            backgroundImage: CachedNetworkImageProvider(
                "https://cdn.nlark.com/yuque/0/2021/png/12924434/1628124182247-avatar/48d73035-8ee5-44ac-bbb2-0583092a4985.png?x-oss-process=image%2Fresize%2Cm_fill%2Cw_328%2Ch_328%2Fformat%2Cpng"),
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  "临渊先生 ",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "语雀",
                  style: TextStyle(
                      backgroundColor: Theme.of(context).primaryColor,
                      color: Colors.white),
                ),
              ],
            ),
            Text("宁在直中取，不向曲中求。"),
            Row(
              children: [
                Icon(Icons.place_outlined, size: 14),
                Text("人间彼岸"),
                Icon(Icons.card_travel_rounded, size: 14),
                Text("设计、写作"),
              ],
            ),
            Row(
              children: [
                Icon(Icons.home, size: 14),
                Text("yuque.com/mrlinyuan"),
              ],
            ),
          ],
        )
      ],
    );
  }

  Widget _buildSchulteGrid() {
    return ListTile(
      title: Row(
        children: [
          Text(
            "舒尔特方格 ",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            "小游戏",
            style: TextStyle(
              backgroundColor: Theme.of(context).primaryColor,
              fontSize: 12,
              color: Colors.white,
            ),
          ),
        ],
      ),
      subtitle: Text("成绩记录功能待增加"),
    );
  }

  Widget _buildLeshi() {
    return ListTile(
      title: Row(
        children: [
          Text(
            "乐事 ",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            "万事屋",
            style: TextStyle(
              backgroundColor: Theme.of(context).primaryColor,
              fontSize: 12,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildPage() {
    print("_buildDisCoverPage");
    return ChangeNotifierProvider.value(
      value: EditSourceProvider(type: 2),
      builder: (BuildContext context, _) {
        EditSourceProvider provider = Provider.of<EditSourceProvider>(context, listen: true);
        return Container(
          decoration: globalDecoration,
          child: Scaffold(
            appBar: AppBar(
              centerTitle: false,
              titleSpacing: NavigationToolbar.kMiddleSpacing,
              title: SearchTextField(
                controller: _searchEdit,
                hintText: "搜索发现站点(共${provider.rules?.length ?? 0}条)",
                onSubmitted: (value) => __provider.getRuleListByName(value),
                onChanged: (value) => __provider.getRuleListByNameDebounce(value),
              ),
              actions: [
                IconButton(
                  icon: Icon(Icons.add),
                  tooltip: '添加规则',
                  onPressed: () => showDialog(
                    context: context,
                    builder: (context) {
                      //TODO: 这里需要自动刷新UI 暂且不做
                     // provider.refreshData();
                     return UIAddRuleDialog(refresh: () => refreshData(provider));
                    }
                  ),
                ),
                IconButton(
                  icon: Icon(OMIcons.settingsEthernet),
                  tooltip: '新建空白规则',
                  onPressed: () => Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) => EditRulePage()))
                      .whenComplete(() => refreshData(provider)),
                ),
                IconButton(
                  icon: Icon(FIcons.edit),
                  tooltip: '规则管理',
                  onPressed: () => Utils.startPageWait(context, EditSourcePage())
                      .whenComplete(() => refreshData(provider)),
                ),
              ],
            ),
            body: Consumer<EditSourceProvider>(
              builder: (context, EditSourceProvider provider, _) {
                if (editSourceProviderTemp == null) {
                  editSourceProviderTemp = provider;
                }
                if (__provider == null) {
                  __provider = provider;

                  provider.ruleContentType = _lastContextType;
                }
                if (provider.isLoading) {
                  return Stack(
                    children: [
                      LandingPage(),
                      _buildFilterView(context, provider),
                    ],
                  );
                }

                final box = Hive.box<int>(EditSourceProvider.unlock_hidden_functions);
                int extCount = 1;
                final extW = <Widget>[];
                if (box.get(EditSourceProvider.schulte_grid) == null) {
                  box.put(EditSourceProvider.schulte_grid, 1);
                }
                if (box.get(EditSourceProvider.schulte_grid, defaultValue: 0) == 1) {
                  extCount += 1;
                  extW.add(InkWell(
                      onTap: () => invokeTap(SchulteGrid()), child: _buildSchulteGrid()));
                }
                if (box.get(EditSourceProvider.leshi, defaultValue: 0) == 1) {
                  extCount += 1;
                  extW.add(
                      InkWell(onTap: () => invokeTap(LeshiPage()), child: _buildLeshi()));
                }
                if (box.get(EditSourceProvider.linyuan, defaultValue: 0) == 1) {
                  extCount += 1;
                  extW.add(InkWell(
                      onTap: () => invokeTap(LinyuanPage()), child: _buildLinyuan()));
                }

                final _listView = ListView.builder(
                  itemCount: provider.rules.length + extCount,
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (BuildContext context, int index) {
                    if (index == 0) return _buildFilterView(context, provider);
                    if (extCount - index > 0) return extW[index - 1];
                    return _buildItem(provider, index - extCount);
                  },
                );
                return KeyboardDismissBehaviorView(
                  child: provider.rules.length == 0
                      ? Stack(
                          children: [
                            _listView,
                            _buildEmptyHintView(provider),
                          ],
                        )
                      : _listView,
                );
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildFilterView(BuildContext context, EditSourceProvider provider) {
    return Container(
      color: Colors.red,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            _buildFilterItemView(context, provider, -1),
            SizedBox(width: 8),
            _buildFilterItemView(context, provider, API.NOVEL),
            SizedBox(width: 8),
            _buildFilterItemView(context, provider, API.MANGA),
            SizedBox(width: 8),
            _buildFilterItemView(context, provider, API.AUDIO),
            SizedBox(width: 8),
            _buildFilterItemView(context, provider, API.VIDEO),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterItemView(
      BuildContext context, EditSourceProvider provider, int contextType) {
    bool selected = provider.ruleContentType == contextType;
    return GestureDetector(
      onTap: () {
        print("ruleContentType $contextType");
        provider.ruleContentType = contextType;
        _lastContextType = contextType;
        if (Utils.empty(_searchEdit?.text))
          provider.refreshData();
        else
          provider.getRuleListByName(_searchEdit.text);
      },
      child: Material(
        color: selected ? Theme.of(context).primaryColor : Theme.of(context).cardColor,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(15.0)),
            side: BorderSide(
                width: Global.borderSize,
                color: selected
                    ? Theme.of(context).primaryColor
                    : Theme.of(context).dividerColor)),
        child: Padding(
          padding: EdgeInsets.fromLTRB(8, 3, 8, 3),
          child: Text(
            contextType < 0 ? '全部' : API.getRuleContentTypeName(contextType),
            style: TextStyle(
              fontSize: 11,
              color: selected
                  ? Theme.of(context).cardColor
                  : Theme.of(context).textTheme.bodyText1.color,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildItem(EditSourceProvider provider, int index) {
    print("rulesindex$index");
    final rule = provider.rules[index];
    final _theme = Theme.of(context);
    final _leadColor = () {
      switch (rule.contentType) {
        case API.MANGA:
          return _theme.primaryColorLight;
        case API.VIDEO:
          return _theme.primaryColor;
        case API.AUDIO:
          return _theme.primaryColorDark;
        default:
          return Colors.white;
      }
    }();
    final _leadTextColor = () {
      switch (rule.contentType) {
        case API.MANGA:
          return Colors.black;
        case API.VIDEO:
          return Colors.white;
        case API.AUDIO:
          return Colors.white;
        default:
          return Colors.black;
      }
    }();
    final _leadBorder = rule.contentType == API.NOVEL
        ? Border.all(color: _theme.primaryColor, width: 1.0)
        : null;
    final iconUrl = rule.icon != null && rule.icon.isNotEmpty
        ? rule.icon
        : Uri.tryParse(rule.host)?.resolve("/favicon.ico")?.toString();
    var showIcon = iconUrl != null;
    final hostPre = RegExp("https?://");
    final host = rule.host.replaceFirst("https://", "").replaceFirst("http://", "");
    Widget _child = ListTile(
      minLeadingWidth: 6,
      leading: StatefulBuilder(
        builder: (BuildContext context, setState) {
          if (showIcon) {
            return Container(
              height: 32,
              width: 32,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: _leadColor,
                shape: BoxShape.circle,
                border: _leadBorder,
              ),
              child: CircleAvatar(
                foregroundImage: CachedNetworkImageProvider(iconUrl),
                foregroundColor: Colors.transparent,
                backgroundColor: Colors.transparent,
                // backgroundImage: AssetImage(Global.waitingPath),
                onForegroundImageError: (exception, stackTrace) =>
                    setState(() => showIcon = false),
                // backgroundImage: AssetImage(Global.waitingPath),
              ),
            );
          }
          return Container(
            height: 32,
            width: 32,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: _leadColor,
              shape: BoxShape.circle,
              border: _leadBorder,
            ),
            child: Text(
              rule.ruleTypeName,
              style: TextStyle(
                fontSize: 11,
                color: _leadTextColor,
                fontFamily: ESOTheme.staticFontFamily,
              ),
            ),
          );
        },
      ),
      onTap: () => invokeTap(DiscoverFuture(rule: rule, key: Key(rule.id.toString()))),
      onLongPress: () => Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => EditRulePage(rule: rule)))
          .whenComplete(() => refreshData(provider)),
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        textBaseline: TextBaseline.alphabetic,
        children: <Widget>[
          Flexible(
            child: Text(
              "${rule.name}",
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: TextStyle(
                textBaseline: TextBaseline.alphabetic,
                fontSize: 16,
                // fontWeight: FontWeight.bold,
                height: 1,
              ),
            ),
          ),
          SizedBox(width: 10),
          Container(
            height: 16,
            decoration: BoxDecoration(
              color: _leadColor,
              borderRadius: BorderRadius.circular(2),
            ),
            padding: EdgeInsets.symmetric(horizontal: 3, vertical: 0),
            alignment: Alignment.centerLeft,
            child: Text(
              '${rule.ruleTypeName}',
              style: TextStyle(
                fontSize: 12,
                color: _leadTextColor,
                height: 1.3,
              ),
            ),
          ),
        ],
      ),
      subtitle: Text(
        rule.author == '' ? host : '@${rule.author} [$host]',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Menu<MenuDiscoverSource>(
        // color: Theme.of(context).iconTheme.color,
        tooltip: "选项",
        items: discoverSourceMenus,
        onSelect: (value) {
          switch (value) {
            // case MenuDiscoverSource.copy:
            //   Clipboard.setData(ClipboardData(text: jsonEncode(rule.toJson())));
            //   Utils.toast("已复制 ${rule.name}");
            //   break;
            case MenuDiscoverSource.replica:
              Global.ruleDao.insertOrUpdateRule(rule.replica());
              refreshData(provider);
              Utils.toast("创建副本成功 ${rule.name}");
              break;
            case MenuDiscoverSource.share:
              invokeTap(SharePage(
                text: RuleCompress.compass(rule),
                addInfo: "亦搜 eso 规则分享 ${rule.name}",
                fileName: rule.name,
              ));
              // Share.share(RuleCompress.compass(rule));
              // FlutterShare.share(
              //   title: '亦搜 eso',
              //   text: RuleCompress.compass(rule), //jsonEncode(rule.toJson()),
              //   //linkUrl: '${searchItem.url}',
              //   chooserTitle: '选择分享的应用',
              // );
              break;
            case MenuDiscoverSource.top:
              provider.handleSelect([rule], MenuEditSource.top);
              break;
            case MenuDiscoverSource.edit:
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => EditRulePage(rule: rule)))
                  .whenComplete(() => refreshData(provider));
              break;
            case MenuDiscoverSource.delete:
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text("警告(不可恢复)"),
                      content: Text("删除 ${rule.name}"),
                      actions: [
                        TextButton(
                          child: Text(
                            "取消",
                            style: TextStyle(color: Theme.of(context).hintColor),
                          ),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                        TextButton(
                          child: Text(
                            "确定",
                            style: TextStyle(color: Colors.red),
                          ),
                          onPressed: () {
                            provider.handleSelect([rule], MenuEditSource.delete_this);
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  });
              break;
            default:
          }
        },
      ),
    );
    if (index < provider.rules.length - 1) return _child;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [_child, SizedBox(height: 30)],
    );
  }

  Widget _buildEmptyHintView(EditSourceProvider provider) {
    final _shape = RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(3),
        side:
            BorderSide(color: Theme.of(context).dividerColor, width: Global.borderSize));
    final _txtStyle =
        TextStyle(fontSize: 13, color: Theme.of(context).hintColor, height: 1.3);
    return EmptyListMsgView(
        text: Column(
      children: [
        Text("没有可用的规则~~~"),
        SizedBox(height: 8),
        ButtonTheme(
          minWidth: 50,
          height: 20,
          shape: _shape,
          buttonColor: Colors.transparent,
          padding: EdgeInsets.fromLTRB(8, 5, 8, 5),
          child: Wrap(
            spacing: 8,
            runSpacing: 6,
            children: [
              TextButton(
                child: Text("导入规则", style: _txtStyle),
                onPressed: () => showDialog(
                  context: context,
                  builder: (context) =>
                      UIAddRuleDialog(refresh: () => refreshData(provider)),
                ),
              ),
              TextButton(
                child: Text("新建规则", style: _txtStyle),
                onPressed: () => Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => EditRulePage())),
              ),
              TextButton(
                child: Text("规则管理", style: _txtStyle),
                onPressed: () => Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => EditSourcePage())),
              ),
            ],
          ),
        )
      ],
    ));
  }

  refreshData(EditSourceProvider provider) {
    if (Utils.empty(_searchEdit?.text))
      provider.refreshData();
    else
      provider.getRuleListByName(_searchEdit.text);
  }
}
