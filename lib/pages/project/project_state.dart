/*
 * @Author: 凡琛
 * @Date: 2021-06-23 15:18:22
 * @LastEditTime: 2021-08-09 15:05:54
 * @LastEditors: Please set LastEditors
 * @Description: In User Settings Edit
 * @FilePath: /Rocks_Flutter/lib/pages/project/project_state.dart
 */
import 'package:get/state_manager.dart';

class ProjectState {
  RxList list;
  RxInt tag;
  RxBool createProject;
  String input;
  ProjectState() {
    list = [].obs;
    tag = 0.obs;
    input = '';
    createProject = false.obs;
  }
}
