import 'package:flutter/material.dart';

/// 路由帮助类
class RouterHelper {
  RouterHelper._();

  /// 显示底部弹窗
  static Future<T> showBottomSheet<T>(Widget child,
      {BuildContext context,
      Color barrierColor,
      Color backgroundColor,
      bool isScrollControlled = false,
      bool enableDrag = false,
      bool isDismissible = true,
      double borderRadius = 16}) {
    final ctx = context ;
    return showModalBottomSheet<T>(
      context: ctx,
      barrierColor: barrierColor ?? Colors.black.withOpacity(0.5),
      isScrollControlled: isScrollControlled,
      enableDrag: enableDrag,
      clipBehavior: Clip.hardEdge,
      isDismissible: isDismissible,
      constraints: BoxConstraints(
          maxHeight: MediaQuery.of(ctx).size.height - MediaQuery.of(ctx).viewPadding.top),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(borderRadius),topRight: Radius.circular(borderRadius))),
      backgroundColor: backgroundColor,
      routeSettings: RouteSettings(arguments: {}),
      builder: (context) => child,
    );
  }

  


}
