import 'package:get/get.dart';

import 'info_modify_state.dart';
import '../../http/http.dart';
import '../../api/system.dart';
import 'package:oktoast/oktoast.dart';
import 'package:flutter/material.dart';
import 'package:hdec_flutter/utils/storage/encrypt.dart';

/// @description:
/// @author
/// @date: 2021/08/03 15:43:12
class InfoModifyLogic extends GetxController {
  final state = InfoModifyState();
  @override
  void onReady() {}
  Map dataMakeup(dynamic item) {
    Map result = {};
    switch (item) {
      case items.Password:
        {
          result = {
            'Password': '${JhEncryptUtils.encodeMd5(state.newpass.value)}',
            'OriginalPassword':
                '${JhEncryptUtils.encodeMd5(state.oldpass.value)}'
          };
        }
        break;
      case items.PhoneNumber:
        {
          result = {'PhoneNumber': '${state.phone}'};
        }
        break;
      case items.RealName:
        {
          result = {'RealName': '${state.name}'};
        }
        break;
      case items.Email:
        {
          result = {'Email': '${state.emial}'};
        }
        break;
      default:
    }
    return result;
  }

  //页面校验
  void makeSure(dynamic item) {
    switch (item) {
      case items.Password:
        if (state.newpass.value != state.repass.value) {
          showToast('两次密码不一致');
          return;
        }
        if (state.oldpass.value == '' ||
            state.newpass.value == '' ||
            state.oldpass.value == '') {
          showToast('密码不能为空');
          return;
        }
        if (state.oldpass.value.length < 6 ||
            state.newpass.value.length < 6 ||
            state.oldpass.value.length < 6) {
          showToast('密码至少为6位');
          return;
        }
        post(item);
        break;
      case items.PhoneNumber:
        if (state.phone.value.length != 11) {
          showToast('手机号格式不正确');
          return;
        } else {
          post(item);
        }
        break;
      case items.Email:
        post(item);
        break;
      case items.RealName:
        post(item);
        break;
      default:
    }
  }

  //发送数据
  void post(dynamic item) {
    HttpRequest.post(SystemApi.editUser, dataMakeup(item), success: (result) {
      if (result['data']['success']) {
        showToast('修改成功');
        item == items.Password
            ? Get.offNamedUntil(
                '/login',
                (Route<dynamic> route) => false,
              )
            : Get.back(result: true);
      } else {
        showToast('原始密码错误');
      }
    }, fail: (error) {
      showToast('保存失败');
    });
  }
}
