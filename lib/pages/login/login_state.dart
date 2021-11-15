/*
 * @Author: your name
 * @Date: 2021-06-24 15:00:28
 * @LastEditTime: 2021-08-13 11:51:31
 * @LastEditors: Please set LastEditors
 * @Description: In User Settings Edit
 * @FilePath: /Rocks_Flutter/lib/pages/login/login_state.dart
 */
import 'package:get/get_rx/get_rx.dart';
import '../../utils/storage/authorStorage.dart';

class LoginState {
  RxString name;
  RxString pwd;
  RxString avatar;
  RxObjectMixin context;
  LoginState() {
    var baseInfo = AuthorStorage.getAuthorPasswordInfo();
    String str = baseInfo != null
        ? (baseInfo['name'] != null ? baseInfo['name'] : '')
        : '';
    name = str.obs;
    pwd = ''.obs;
    String avatarUrl = baseInfo != null
        ? baseInfo['avatar'] != null
            ? baseInfo['avatar']
            : ''
        : '';
    avatar = avatarUrl.obs;
  }
}
