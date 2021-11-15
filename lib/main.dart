/*
 * @Author: your name
 * @Date: 2021-06-22 11:54:15
 * @LastEditTime: 2021-08-17 17:26:36
 * @LastEditors: Please set LastEditors
 * @Description: In User Settings Edit
 * @FilePath: /Rocks_Flutter/lib/main.dart
 */
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hdec_flutter/pages/intro/intro_view.dart';
import 'package:hdec_flutter/pages/login/login_view.dart';
import 'package:oktoast/oktoast.dart';
import 'pages/tab/tabbar.dart';
import 'package:get/get.dart';
import 'package:flustars/flustars.dart';
import '../utils/storage/authorStorage.dart';
// 注册地图
import 'package:amap_all_fluttify/amap_all_fluttify.dart';
//页面路由配置
import 'config/routeConfig.dart';
// 用户权限
import 'permission/permission.dart';
// 系统配置
import 'config/systemConfig.dart';
import 'utils/storage/authorStorage.dart';

class GlobalHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() async {
  // 缓存服务
  WidgetsFlutterBinding.ensureInitialized();
  await SpUtil.getInstance();
  initApp();
  runApp(MyApp());
}

// 初始化应用相关
void initApp() async {
  HttpOverrides.global = GlobalHttpOverrides(); // 禁用证书校验
  SystemConfigInstance(); // 获取系统配置
  if (AuthorStorage.getAuthorInfo() != null) PermissionSharedInstance(); // 用户权限
  // 注册地图key
  await enableFluttifyLog(false);
  await AmapService.init(
    iosKey: 'bcc2e942b32aab72e915b47cee80da1c',
    androidKey: 'a8d8297b5dd28842f771ed6a900c291f',
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return OKToast(
        child: Container(
      color: Colors.white,
      child: GetMaterialApp(
        color: Colors.white,
        initialRoute: RouteConfig.main,
        getPages: RouteConfig.getPages,
        home: switchRootWidget(),
        unknownRoute: RouteConfig.unknownRoutePage,
      ),
    ));
  }
}

// 获取用户权限信息

Widget switchRootWidget() {
  // app 启动登录校验
  var currentUserInfo = AuthorStorage.getAuthorInfo();
  if (currentUserInfo != null) {
    return BaseTabBar();
  } else {
    if (AuthorStorage.getFirstOpenKey()) {
      return IntroPage();
    } else {
      return LoginPage();
    }
  }
}
