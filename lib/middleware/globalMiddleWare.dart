/*
 * @Author: 凡琛
 * @Date: 2021-07-12 11:29:09
 * @LastEditTime: 2021-08-02 14:38:10
 * @LastEditors: Please set LastEditors
 * @Description: 全局中间件
 * @FilePath: /Rocks_Flutter/lib/middleware/globalMiddleWare.dart
 */
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../utils/storage/authorStorage.dart';

class GlobalMiddleware extends GetMiddleware {
  @override
  RouteSettings redirect(String route) {
    // 获取本地登录状态
    Map currentUserInfo = AuthorStorage.getAuthorInfo();
    bool authenticated =
        currentUserInfo != null && currentUserInfo['authenticated'] != null
            ? currentUserInfo['authenticated']
            : false;
    if (!authenticated) {
      Future.delayed(Duration(seconds: 1), () => Get.snackbar("提示", "请先登录"));
    }
    return authenticated
        ? super.redirect(route)
        : RouteSettings(name: '/login', arguments: {});
  }

  @override
  GetPage onPageCalled(GetPage page) {
    return super.onPageCalled(page);
  }

  @override
  List<Bindings> onBindingsStart(List<Bindings> bindings) {
    return super.onBindingsStart(bindings);
  }

  @override
  GetPageBuilder onPageBuildStart(GetPageBuilder page) {
    return super.onPageBuildStart(page);
  }

  @override
  Widget onPageBuilt(Widget page) {
    return super.onPageBuilt(page);
  }

  @override
  void onPageDispose() {
    super.onPageDispose();
  }
}
