/*
 * @Author: 凡琛
 * @Date: 2021-06-22 16:51:26
 * @LastEditTime: 2021-06-23 17:00:08
 * @LastEditors: Please set LastEditors
 * @Description: In User Settings Edit
 * @FilePath: /Rocks_Flutter/lib/pages/mine/mine_state.dart
 */
import 'package:get/state_manager.dart';

class MineState {
  RxString msg;
  RxList list;
  RxMap baseInfo;
  RxBool flag;
  MineState() {
    msg = ''.obs;
    list = [].obs;
    flag=false.obs;
    baseInfo = {}.obs;
  }
}
