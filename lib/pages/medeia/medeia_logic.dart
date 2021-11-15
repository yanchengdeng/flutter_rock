import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'medeia_state.dart';
import 'package:flutter_absolute_path/flutter_absolute_path.dart';

/// @description:
/// @王梓豪
/// @date: 2021/07/12 15:40:38

class MedeiaLogic extends GetxController {
  final state = MedeiaState();
  PageController pageController;
  bool flag = true;
  @override
  void onInit() {
    super.onInit();
    //显示图片接口
    state.files.value = Get.arguments['images'];
    state.temIndex.value = Get.arguments['index'];
    pageController = PageController(initialPage: state.temIndex.value);
    // //下拉小菜单项目接口
    flag = isNetWorkImg(state.files[state.temIndex.value]);
    state.title = Get.arguments['medeia_title'] == null
        ? []
        : Get.arguments['medeia_title'];
    state.value = Get.arguments['medeia_value'] == null
        ? []
        : Get.arguments['medeia_value'];
    // state.callback = Get.arguments['callback'];
  }

  @override
  void onReady() {
    super.onReady();
    //初始化下拉小菜单中可点击的项目

    //添加默认项目
    state.menuList = [
      PopupMenuItem(
        child: Text('保存图片'),
        value: 1001,
      ),
      PopupMenuItem(
        child: Text('保存原图'),
        value: 1002,
      ),
    ].obs;

    //初始化下拉菜单栏的项目
    if (state.title != null && state.value != null) {
      for (int i = 0; i < state.title.length; i++) {
        state.addMenuList[i] = PopupMenuItem(
          child: Text('${state.title[i]}'),
          value: state.value[i],
        );
      }
    }
    if (state.addMenuList != null) {
      state.menuList.addAll(state.addMenuList);
    }
  }

  fuction(dynamic objects) {
    // objects ;
    // state.callback();
  }
  //图片解码接口
  Future<List<File>> convert(RxList<Asset> images) async {
    List<File> files = [];
    for (int i = 0; i < images.length; i++) {
      var path =
          await FlutterAbsolutePath.getAbsolutePath(images[i].identifier);
      File file = File(path);
      files.add(file);
    }
    return files;
  }

  bool isNetWorkImg(dynamic url) {
    if (url is String) {
      return true;
    } else
      return false;
  }
}
//-----------------------------------------代码列表-----------------------------------------
//保存图片--1001
//保存原图--1002
