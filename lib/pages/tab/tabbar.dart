/*
 * @Author: 凡琛
 * @Date: 2021-06-22 11:54:15
 * @LastEditTime: 2021-08-12 19:34:55
 * @LastEditors: Please set LastEditors
 * @Description: In User Settings Edit
 * @FilePath: /Rocks_Flutter/lib/pages/tabbar.dart
 */
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:hdec_flutter/pages/search_widget/search_widget_view.dart';
import 'package:oktoast/oktoast.dart';
import '../home/home_view.dart';
import '../mine/mine_view.dart';
import '../../utils/jh_image_utils.dart';
import '../project/project_view.dart';
import '../../../utils/picker.dart';
import '../../utils/storage/authorStorage.dart';
import '../../http/http.dart';
import '../../api/system.dart';
import 'package:get/get.dart';
import 'package:jhtoast/jhtoast.dart';
import '../publish/request.dart';

class BaseTabBar extends StatefulWidget {
  BaseTabBar({Key key}) : super(key: key);

  _BaseTabBarState createState() => _BaseTabBarState();
}

class _BaseTabBarState extends State<BaseTabBar> {
  int _currentIndex = 0;
  List<Widget> _pageList = [
    HomePage(),
    ProjectPage(),
    Container(),
    SearchWidgetPage(),
    MinePage()
  ];
  static double _iconWH = 24.0;
  static double _fontSize = 10.0;
  File file;
  Color selColor = Color(0xFF1296DB);

  List<BottomNavigationBarItem> bottomTabs = [
    BottomNavigationBarItem(
      label: "首页",
      icon: JhLoadAssetImage('tab/nav_tab_1', width: _iconWH),
      activeIcon: JhLoadAssetImage('tab/nav_tab_1_on', width: _iconWH),
    ),
    BottomNavigationBarItem(
      label: "项目",
      icon: JhLoadAssetImage('tab/doc', width: _iconWH),
      activeIcon: JhLoadAssetImage('tab/doc_on', width: _iconWH),
    ),
    BottomNavigationBarItem(
        icon: SizedBox(
          height: 24,
        ),
        label: '识别'),
    BottomNavigationBarItem(
        label: "鉴定",
        activeIcon: JhLoadAssetImage('tab/search_on', width: _iconWH),
        icon: JhLoadAssetImage('tab/search', width: _iconWH)),
    BottomNavigationBarItem(
      label: "我的",
      icon: JhLoadAssetImage('tab/nav_tab_4', width: _iconWH),
      activeIcon: JhLoadAssetImage('tab/nav_tab_4_on', width: _iconWH),
    ),
  ];

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((Duration timestamp) {
      // 设置EasyRefresh的默认样式
      EasyRefresh.defaultHeader = ClassicalHeader(
        enableInfiniteRefresh: false,
        refreshText: '下拉刷新',
        refreshReadyText: '释放刷新',
        refreshingText: '加载中...',
        refreshedText: '加载完成',
        refreshFailedText: '加载失败',
        noMoreText: '没有更多',
        showInfo: false,
      );
      EasyRefresh.defaultFooter = ClassicalFooter(
        loadReadyText: '准备加载',
        loadingText: '正在加载...',
        loadedText: '加载完成',
        showInfo: false,
      );
    });
  }

//唤起相机页面
  void startCamera() async {
    var data = AuthorStorage.getAuthorPublishInfo();
    if (data == null) {
      Get.toNamed('/publish');
      return;
    }
    // 提交复选框
    if (AuthorStorage.getQuickPublish() == null ||
        AuthorStorage.getQuickPublish() == false) {
      Get.defaultDialog(
          title: '快捷发布',
          middleText: '依据上一次发布的基本信息直接发布',
          textCancel: '取消',
          textConfirm: '确认',
          barrierDismissible: true,
          confirmTextColor: Colors.white,
          titleStyle: TextStyle(fontSize: 18),
          radius: 6,
          onConfirm: () => {publish(data), Get.back()});
      AuthorStorage.saveQuickPublish();
    } else {
      showToast('依据上一次发布的基本信息直接发布');
      Future.delayed(Duration(seconds: 1), () {
        publish(data);
      });
    }
  }

  void publish(var data) async {
    var asset = await getTakeAssetFromCamera(false);
    var file = await asset?.originFile;
    if (file == null) return;
    var hide = JhToast.showIOSLoadingText(
      context,
      msg: "图片压缩上传中...",
    );
    var publishInfo = data['publishInfo'] ?? {};
    // 上传图片
    String fileUrl = await uploadFile(
        publishInfo['InitialType'].toString() ?? '400000', file);
    publishInfo['videoUrl'] = null;
    publishInfo['imageUrls'] = fileUrl.isEmpty ? [] : [fileUrl];
    //发布接口
    HttpRequest.post(SystemApi.publishSampleImage, data['publishInfo'],
        success: (result) {
      hide();
      showToast('发布成功');
      Future.delayed(Duration(seconds: 2), () {
        Get.back();
      });
    }, fail: (error) {});
  }

// 文件上传
  Future<String> uploadFile(String fileId, File file) async {
    String res;
    if (file == null) {
      return res;
    }
    String path = file.absolute.path;
    var formData = await PublishRequest.dealWithFileData(path, fileId, 'file');
    // 上传接口
    await HttpRequest.post(SystemApi.upLoadFile, formData, success: (result) {
      print('${result['data']['url']}');
      res = result['data']['url'];
    }, fail: (error) {});
    return res;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: IndexedStack(
        index: _currentIndex,
        children: _pageList,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: startCamera,
        // backgroundColor: Colors.black
        child: JhLoadAssetImage('tab/takePhoto_cricle', width: 30),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomNavigationBar(
        fixedColor: selColor,
        //选中的颜色
        unselectedFontSize: _fontSize,
        selectedFontSize: _fontSize,
        type: BottomNavigationBarType.fixed,
        //配置底部BaseTabBar可以有多个按钮
        items: bottomTabs,
        currentIndex: this._currentIndex,
        //配置对应的索引值选中
        onTap: (int index) {
          FocusScope.of(context).requestFocus(FocusNode());
          if (index == 2) return;
          setState(() {
            //改变状态
            this._currentIndex = index;
          });
        },
      ),
    );
  }
}
