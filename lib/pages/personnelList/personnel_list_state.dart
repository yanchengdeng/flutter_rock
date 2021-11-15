/*
 * @Author: 凡琛
 * @Date: 2021-07-23 09:08:50
 * @LastEditTime: 2021-08-05 15:02:28
 * @LastEditors: Please set LastEditors
 * @Description: 人员列表
 * @FilePath: 
 */

import 'package:get/state_manager.dart';

class PersonnelListState {
  RxList list;
  PersonnelListState() {
    list = [].obs;
  }
}
