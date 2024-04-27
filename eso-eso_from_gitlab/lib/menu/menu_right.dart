import 'menu_item.dart';

enum MenuRight {
  copy,
  cut,
  paste,
  all,
  clear,
}

const List<MenuItemEso<MenuRight>> rightMenus = [
  MenuItemEso<MenuRight>(text: '复制', value: MenuRight.copy),
  MenuItemEso<MenuRight>(text: '剪切', value: MenuRight.cut),
  MenuItemEso<MenuRight>(text: '粘贴', value: MenuRight.paste),
  MenuItemEso<MenuRight>(text: '全选', value: MenuRight.all),
  MenuItemEso<MenuRight>(text: '清空', value: MenuRight.clear),
];
