/*
 * @Author: 凡琛
 * @Date: 2021-06-22 17:18:30
 * @LastEditTime: 2021-08-11 15:44:24
 * @LastEditors: Please set LastEditors
 * @Description: 路由配置类
 * @FilePath: /Rocks_Flutter/lib/pages/routeConfig.dart
 */
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/** 注册登录 */
import '../pages/intro/intro_view.dart';
import '../pages/login/login_view.dart';
import '../pages/register/register_view.dart';
import 'package:hdec_flutter/pages/info_modify/info_modify_view.dart';
/** tab页 */
import '../pages/tab/tabbar.dart';
import '../pages/home/home_view.dart';
import '../pages/mine/mine_view.dart';
import '../pages/project/project_view.dart';
import '../pages/common/templete.dart';
/** 功能页面 */
import 'package:hdec_flutter/widgets/WebView.dart';
import '../pages/publish/publish_view.dart';
import '../pages/project/project_home/project_home_view.dart';
import '../pages/new_project/new_project_view.dart';
import '../pages/company/company_view.dart';
import '../pages/company/company_home/company_home_view.dart';
import '../pages/department/department_view.dart';
import '../pages/person/person_view.dart';
import '../pages/system_role/system_role_view.dart';
/** 通用页面 */
import 'package:hdec_flutter/pages/detail/detail_view.dart';
import 'package:hdec_flutter/pages/search_widget/search_widget_view.dart';
import '../pages/common/selecterPage.dart';
import '../pages/selectedPage/selected_page.dart';
import '../pages/amap/amap_view.dart';
import '../pages/permission/permission_page.dart';
import '../pages/personnelList/personnel_list_view.dart';
/** 多媒体 */
import '../pages/medeia/medeia_view.dart';
import '../pages/video/video_view.dart';
/** 中间件 */
import '../middleware/globalMiddleWare.dart';

class RouteConfig {
  static final String main = "/";
  static final GetPage unknownRoutePage =
      GetPage(name: '/templete', page: () => Templete());
  static final List<GetPage> getPages = [
    /** 注册登录 */
    GetPage(name: '/intro', page: () => IntroPage()),
    GetPage(
        name: '/login',
        page: () => LoginPage(),
        transition: Transition.downToUp),
    GetPage(name: '/registor', page: () => RegisterPage()),
    GetPage(name: '/infoModify', page: () => InfoModifyPage()),
    /** tab页 */
    GetPage(
        name: '/tabbar',
        page: () => BaseTabBar(),
        middlewares: [GlobalMiddleware()],
        transition: Transition.downToUp),
    GetPage(name: '/search', page: () => SearchWidgetPage()),
    GetPage(
        name: '/home',
        page: () => HomePage(),
        middlewares: [GlobalMiddleware()]),
    GetPage(
        name: '/project',
        page: () => ProjectPage(),
        middlewares: [GlobalMiddleware()]),
    GetPage(name: '/templete', page: () => Templete()),
    GetPage(
        name: '/mine',
        page: () => MinePage(),
        middlewares: [GlobalMiddleware()]),
    /** 功能页面 */
    GetPage(
        name: '/publish',
        page: () => PublishPage(),
        middlewares: [GlobalMiddleware()]),
    GetPage(
        name: '/projectHome',
        page: () => ProjectHomePage(),
        middlewares: [GlobalMiddleware()]),
    GetPage(
        name: '/newproject',
        page: () => NewProjectPage(),
        middlewares: [GlobalMiddleware()]),
    GetPage(
        name: '/company',
        page: () => CompanyPage(),
        middlewares: [GlobalMiddleware()]),
    GetPage(
        name: '/companyHome',
        page: () => CompanyHomePage(),
        middlewares: [GlobalMiddleware()]),
    GetPage(
        name: '/person',
        page: () => PersonPage(),
        middlewares: [GlobalMiddleware()]),
    GetPage(
        name: '/department',
        page: () => DepartmentPage(),
        middlewares: [GlobalMiddleware()]),
    GetPage(
        name: '/systemRolePage',
        page: () => SystemRolePage(),
        middlewares: [GlobalMiddleware()]),
    /** 通用页面 */
    GetPage(name: '/detail', page: () => DetailPage()),
    GetPage(
        name: '/selecter',
        page: () => SelecterPage(),
        middlewares: [GlobalMiddleware()]),
    GetPage(
        name: '/seletedPage',
        page: () => SelectedPage(),
        middlewares: [GlobalMiddleware()]),
    GetPage(
        name: '/amap',
        page: () => AmapPage(),
        middlewares: [GlobalMiddleware()]),
    GetPage(
        name: '/permission',
        page: () => PermissionPage(),
        middlewares: [GlobalMiddleware()]),
    GetPage(
        name: '/personnelList',
        page: () => PersonnelListPage(),
        middlewares: [GlobalMiddleware()]),
    GetPage(name: '/web', page: () => MyWebView()),
    /** 多媒体 */
    GetPage(
      name: '/medeia',
      page: () => MedeiaPage(),
      transition: Transition.zoom,
    ),
    GetPage(
      name: '/video',
      page: () => VideoPage(),
      transition: Transition.zoom,
    ),
  ];
  void redirectToLogin() {
    Get.offNamedUntil(
      '/login',
      (Route<dynamic> route) => false,
    );
  }
}
