/*
 * @Author: your name
 * @Date: 2021-07-30 18:27:36
 * @LastEditTime: 2021-08-06 16:07:13
 * @LastEditors: Please set LastEditors
 * @Description: In User Settings Edit
 * @FilePath: /Rocks_Flutter/lib/pages/register/register_logic.dart
 */
import 'package:get/get.dart';
import 'register_state.dart';
import 'package:flutter/material.dart';
import '../register/register_widget.dart';
import '../../http/http.dart';
import '../../api/system.dart';

class RegisterLogic extends GetxController {
  final state = RegisterState();
  PageController pageController;
  @override
  void onInit() {
    convert();
    // Widget i = new RegisterWidget(items: state.data);
    // state.pagWidgets.add(i);
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
    print('closeed');
  }

  void convert() {
    HttpRequest.get(SystemApi.getSignUpInfo, {"AccessToken": "RockRec"},
        success: (result) {
      state.registerInfo = result;
      //摘取无用数据（将外层多余数据去掉）
      state.registerInfo.removeWhere((key, value) => key == 'code');
      state.registerInfo = state.registerInfo.values.elementAt(0);
      if (state.registerInfo.containsValue(false)) {
        Widget i = new RegisterWidget(
          hasData: false,
          hasButton: true,
        );
        state.pagWidgets.add(i);
      }
      state.registerInfo
          .removeWhere((key, value) => key == 'success' || key == 'msg');
      //输出有用数据
      state.registerInfo = state.registerInfo.values.elementAt(0);
      state.data = state.registerInfo.values.elementAt(0);
      state.agreement = state.registerInfo.values.elementAt(1);
      for (int i = 0; i < state.data.length; i++) {
        state.title.add('');
      }
      state.pagWidgets.add(RegisterWidget(
        hasButton: false,
        agreement: state.agreement,
      ));
      Widget i = new RegisterWidget(
        items: state.data,
        hasData: true,
        hasButton: true,
        title: state.title,
        agreement: state.agreement,
      );
      state.pagWidgets.add(i);
    }, fail: (error) {
      Widget i = new RegisterWidget(
        hasData: false,
        hasButton: true,
      );
      state.pagWidgets.add(i);
      print(error);
    });
  }
}
