import 'package:outline_material_icons/outline_material_icons.dart';

import '../fonticons_icons.dart';
import '../global.dart';
import 'menu_item.dart';

enum MenuDiscoverSource {
  edit,
  delete,
  top,
  // copy,
  replica,
  share,
}

List<MenuItemEso<MenuDiscoverSource>> discoverSourceMenus = [
  MenuItemEso<MenuDiscoverSource>(
    text: '编辑',
    icon: OMIcons.settingsEthernet,
    value: MenuDiscoverSource.edit,
    color: Global.primaryColor,
  ),
  MenuItemEso<MenuDiscoverSource>(
    text: '置顶',
    icon: OMIcons.arrowUpward,
    value: MenuDiscoverSource.top,
    color: Global.primaryColor,
  ),
  MenuItemEso<MenuDiscoverSource>(
    text: '删除',
    icon: OMIcons.deleteSweep,
    value: MenuDiscoverSource.delete,
    color: Global.primaryColor,
  ),
  // MenuItem<MenuDiscoverSource>(
  //   text: '复制',
  //   icon: OMIcons.fileCopy,
  //   value: MenuDiscoverSource.copy,
  //   color: Global.primaryColor,
  // ),
  MenuItemEso<MenuDiscoverSource>(
    text: '副本',
    icon: OMIcons.fileCopy,
    value: MenuDiscoverSource.replica,
    color: Global.primaryColor,
  ),
  MenuItemEso<MenuDiscoverSource>(
    text: '分享',
    icon: FIcons.share_2,
    value: MenuDiscoverSource.share,
    color: Global.primaryColor,
  ),
];
