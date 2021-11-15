/*
 * @Author: 凡琛
 * @Date: 2021-07-28 14:44:31
 * @LastEditTime: 2021-08-16 17:32:35
 * @LastEditors: Please set LastEditors
 * @Description: 项目主页
 * @FilePath: /Rocks_Flutter/lib/pages/project/project_home/project_home_state.dart
 */
import 'package:get/state_manager.dart';

class ProjectHomeState {
  RxList<dynamic> list;
  List<dynamic> staffs = [];
  List<dynamic> roles = [];
  RxList<String> data;
  RxString title;
  Map project;
  int projectID;
  RxInt tabIndex;

  // 角色
  String roleName;
  int roleLevel;
  // 权限变量
  RxBool add;
  ProjectHomeState() {
    list = [].obs;
    data = ['header', 'cell'].obs;
    title = '项目主页'.obs;
    tabIndex = 0.obs;
    roleName = '';
    roleLevel = -1;
    //
    add = false.obs;
  }
}
