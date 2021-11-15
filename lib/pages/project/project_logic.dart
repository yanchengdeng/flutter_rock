/*
 * @Author: 凡琛
 * @Date: 2021-06-23 15:18:22
 * @LastEditTime: 2021-08-17 16:22:08
 * @LastEditors: Please set LastEditors
 * @Description:项目
 * @FilePath: /Rocks_Flutter/lib/pages/project/project_logic.dart
 */

import 'package:get/get.dart';
import 'project_state.dart';
import '../../api/system.dart';
import '../../http/http.dart';
import 'package:flutter/material.dart';
import '../../permission/permission.dart';
import '../../notification/notification.dart';

class ProjectLogic extends GetxController {
  final state = ProjectState();
  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onInit() {
    super.onInit();
    setCreateProjectStatus();
    //监听登录事件
    bus.on(Emit.updatePermission, (arg) async {
      setCreateProjectStatus();
    });
  }

  @override
  void onClose() {
    super.onClose();
    bus.off(Emit.updatePermission); //移除广播机制
  }

  void myDispose(GetBuilderState stateFormBulider) {
    // 还原默认值
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      state.tag.value = 0;
    });
  }

// 组件初始化方式
  void initState(GetBuilderState stateFormBulider) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      state.tag.value = Get.arguments != null ? Get.arguments['tag'] : 0;
    });
    request(); // 请求列表数据
  }

// 页面更新
  void didChangeDependencies(GetBuilderState stateFormBulider) {
    // print('页面更新');
  }

// 组件刷新
  void didUpdateWidget(GetBuilder oldWidget, GetBuilderState stateFormBulider) {
    // print('组件刷新');
  }
  // 设置tag
  void setCreateProjectStatus() async {
    state.createProject.value =
        await PermissionSharedInstance.getSystemAccess(Auth.projectCreate);
  }

  // 新增项目
  onTapCreateProject() async {
    await Get.toNamed('/newproject');
    request();
  }

  // 点击项目
  void onTapItem(Map item) {
    if (state.tag.value == 1) {
      // 从发布页进来
      Get.back(result: item); // 回传数据,关闭页面
    } else {
      // tab 进入 点击打卡项目详情页
      Get.toNamed('/projectHome', arguments: {'item': item});
    }
  }

  void request([String name]) async {
    var req = {"search": name};
    //请求项目列表
    HttpRequest.get(SystemApi.getProject, req, success: (result) {
      var data = result['data'];
      if (data != null &&
          data['data'] != null &&
          data['data']['rows'] != null) {
        state.list.value = data['data']['rows'];
      }
    }, fail: (error) {});
  }

  // 输入框回调
  void onSearchTextChanged(String context) => {state.input = context};
  // 清除输入框回调
  void onCleanSearch() => {state.input = '', request(state.input)};
}
