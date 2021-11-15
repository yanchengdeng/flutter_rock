/*
 * @Author: 凡琛
 * @Date: 2021-06-24 15:00:28
 * @LastEditTime: 2021-08-17 16:44:12
 * @LastEditors: Please set LastEditors
 * @Description: 登录页面
 * @FilePath: /Rocks_Flutter/lib/pages/login/login_logic.dart
 */
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'login_state.dart';
import '../../api/system.dart';
import '../../http/http.dart';
import 'package:jhtoast/jhtoast.dart';
import '../../config/projectConfig.dart';
import '../../utils/storage/localStorage.dart';
import '../../permission/permission.dart';
import 'package:hdec_flutter/utils/storage/encrypt.dart';

class LoginLogic extends GetxController {
  final state = LoginState();
  var pageContext;
  @override
  void onReady() {
    super.onReady();
  }

  // 点击登录
  void onTapSubmit(BuildContext context) async {
    pageContext = Get.overlayContext;
    if (state.name.value.isEmpty || state.pwd.value.isEmpty) {
      showToast("用户名或密码不可为空");
      return;
    }
    request();
  }

// 忘记密码
  void onTapForget() {}

  void loading() {
    Future.delayed(Duration(seconds: 2), () {
      JhToast.showLoadingText(
        pageContext,
        msg: "正在登录...",
      );
    });
  }

  void showToast(String msg, {int duration, int gravity}) {
    // Toast.show(msg, pageContext, duration: duration, gravity: gravity);
    JhToast.showText(pageContext, msg: msg);
  }

  void request() {
    var userInfo = {
      "UserName": state.name.value,
      "Password": JhEncryptUtils.encodeMd5(state.pwd.value)
    };
    var hide = JhToast.showIOSLoadingText(
      pageContext,
      msg: "正在登录...",
    );
    //请求项目列表
    HttpRequest.post(SystemApi.login, userInfo, success: (result) async {
      final data = result['data'];
      if (data['success']) {
        // 设置客户端登录标志
        data['authenticated'] = true;
        // 登录信息保存在本地
        await StorageUtils.saveModel(KEY_USER_DEFAULT_INFO, data);
        // 保存用户名&密码
        StorageUtils.saveModel(KEY_USER_DEFAULT_BASE_INFO, {
          "name": state.name.value,
          "pwd": state.pwd.value,
          "avatar": data['Avatar']
        });
        // 获取当前用户权限
        PermissionSharedInstance.refreshPermission();
        hide();
        // 提示登录成功
        showToast("登录成功");
        // 关闭页面
        Future.delayed(Duration(seconds: 1), () {
          Get.offNamedUntil(
            '/tabbar',
            (Route<dynamic> route) => false,
          );
        });
      } else {
        hide();
        // 提示登录失败
        String errMsg = data['msg'];
        showToast("$errMsg");
      }
    }, fail: (error) {
      hide();
      showToast("登录失败,错误码：$error");
    });
  }
}
