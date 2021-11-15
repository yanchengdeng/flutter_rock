/*
 * @Author: 凡琛
 * @Date: 2021-06-22 16:51:26
 * @LastEditTime: 2021-08-11 10:48:55
 * @LastEditors: Please set LastEditors
 * @Description: 我的页面
 * @FilePath: /Rocks_Flutter/lib/pages/mine/mine_logic.dart
 */
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:oktoast/oktoast.dart';
import 'mine_state.dart';
import '../../utils/storage/authorStorage.dart';
import '../../http/http.dart';
import '../../api/system.dart';
// import 'package:package_info/package_info.dart';

void loadData() {
  print('name');
}

class MineLogic extends GetxController {
  final state = MineState();
  @override
  void onInit() {
    getPersonInfo(); //获取用户信息

    super.onInit();
  }

  void onReady() {
    super.onReady();
  }

// 获取用户信息
  getPersonInfo() async {
    var version = '0.0.1';
    // if (GetPlatform.isAndroid || GetPlatform.isIOS || GetPlatform.isMacOS) {
    //   PackageInfo packageInfo = await PackageInfo.fromPlatform();
    //   version = packageInfo.version;
    // }
    HttpRequest.post(SystemApi.getPersonalInfo, {'version': version},
        success: (result) {
      if (result != null &&
          result['data'] != null &&
          result['data']['mineData'] != null) {
        var res = result['data']['mineData'];
        List list = res['list'];
        state.list.value = list;
      }
    }, fail: (error) {
      print(error);
    });
  }

// 点击退出
  onTapExit() {
    Get.defaultDialog(
        title: '退出登录',
        middleText: '是否继续退出登录？',
        textCancel: '取消',
        textConfirm: '退出',
        barrierDismissible: false,
        confirmTextColor: Colors.white,
        titleStyle: TextStyle(fontSize: 18),
        radius: 6,
        onConfirm: () => {exit()});
  }

// 退出登录请求
  exit() {
    HttpRequest.post(SystemApi.logout, {}, success: (result) {
      if (result != null &&
          result['data'] != null &&
          result['data']['success']) {
        showToast('退出成功');
      } else {
        showToast('退出失败');
      }
      // 清空本地用户登录信息
      AuthorStorage.removeAuthorInfo();
      Get.offNamedUntil(
        '/login',
        (Route<dynamic> route) => false,
      );
    }, fail: (error) {});
  }

// 点击cell 事件
  onTapCell(var item) async {
    var jumpUrl = item['jumpUrl'];
    if (jumpUrl == null || jumpUrl == '') {
      return;
    }
    var data = await Get.toNamed(jumpUrl, arguments: {'item': item});
    if (data == true) {
      getPersonInfo();
    }
  }
}
