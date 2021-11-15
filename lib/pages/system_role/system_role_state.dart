/*
 * @Author: 凡琛
 * @Date: 2021-08-05 10:16:34
 * @LastEditTime: 2021-08-05 12:25:43
 * @LastEditors: Please set LastEditors
 * @Description: 系统角色
 * @FilePath: /Rocks_Flutter/lib/pages/system_role/system_role_state.dart
 */

import 'package:get/state_manager.dart';

class SystemRoleState {
  RxList list;
  // 角色
  String roleName;
  int roleLevel;
  SystemRoleState() {
    list = [].obs;
    roleName = '';
    roleLevel = -1;
  }
}
