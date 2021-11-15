/// @description:
/// @王梓豪
/// @date: 2021/07/12 15:40:38
import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import 'package:photo_view/photo_view.dart';
import 'package:get/get.dart';

class MedeiaState {
  //当前图片
  RxInt temIndex;

  //滑动控制器
  PhotoViewScaleStateController scaleStateController;
  List<String> title;
  List<int> value;
  //接受自定义菜单项目
  RxList<PopupMenuItem> menuList;
  RxList<PopupMenuItem> addMenuList;
  RxList<dynamic> files;
  Function callback;
  // RxBool enabled;
  MedeiaState() {
    files = [].obs;
    temIndex = 0.obs;
  }
}
