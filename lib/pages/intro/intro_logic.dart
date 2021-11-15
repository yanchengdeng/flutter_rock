import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'intro_state.dart';

/// @description:
/// @author
/// @date: 2021/07/21 11:39:46
class IntroLogic extends GetxController {
  final state = IntroState();
  @override
  void onInit() {
    super.onInit();
    state.imgList.forEach((value) {
      state.imgWidgets.add(Image.asset(value,
          alignment: Alignment.center,
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity));
//      _imgWidgets.add(Image.network(value,
//          fit: BoxFit.fill, width: double.infinity, height: double.infinity));
    });
  }
}
